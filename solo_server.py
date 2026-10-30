#!/usr/bin/env python3
"""
Straw Hat Samurai Duels - local solo server.

Serves the game assets AND emulates the dead PHP backend so the game can be
played offline in a single-player "guest" session.

WHY THE URL PATCH IS NEEDED
---------------------------
The game hardcodes its backend base URL in the SWF:
    http://www.strawhatsamuraiduels.com/server/     (43 bytes, NXDOMAIN today)
We byte-patch that exact-length string to:
    http://playerio.localhost:8765/solo/server/      (also 43 bytes)
"playerio" is kept in the replacement because the game's own anti-piracy gate
(GameEngine.checkSiteLock) only accepts URLs containing playerio,
strawhatsamuraiduels.com or explosivebarrel.net.
macOS resolves *.localhost -> 127.0.0.1, so no sudo / /etc/hosts edit needed.

VERIFIED DEAD (2026-10-30)
--------------------------
  strawhatsamuraiduels.com   -> DNS NXDOMAIN
  r.playerio.com (connect)   -> HTTP 500
  whipflash.com/api.php      -> HTTP 502 (payments only, not on boot path)
  cdn.playerio.com GameFS    -> HTTP 200  (assets still alive, mirrored locally)
"""
import http.server
import json
import os
import re
import socketserver
import sys
import urllib.parse
from datetime import datetime, timezone
from urllib.parse import urlencode

ROOT = os.path.dirname(os.path.abspath(__file__))
PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8765
STATE_FILE = os.path.join(ROOT, ".solo_state.json")

# Guest character: name,level -> charstring format is "name,level"
GUEST_CHAR = "Kenshin,1"

CHAR_FIELDS = (
    "charname playerlevel playerxp playermoney playergold playerexp "
    "playerhonor playerreputation playerhealth playermana playerenergy "
    "playermaxhealth playermaxmana playermaxenergy playergun ammo item0 "
    "item1 item2 item3 item4 item5 item6 item7 item8 item9 item10 item11 "
    "item12 item13 item14 item15 item16 item17 item18 item19 item20 "
    "item21 item22 item23 item24 item25 item26 item27 item28 item29 "
    "item30 item31 item32 item33 item34 item35 item36 item37 item38 "
    "item39 item40 item41 item42 item43 item44 item45 item46 item47 "
    "item48 item49 item50 item51 item52 item53 item54 item55 item56 "
    "item57 item58 item59 item60 item61 item62 item63 item64 item65 "
    "item66 item67 item68 item69 item70 item71 item72 item73 item74 "
    "item75 item76 item77 item78 item79 item80 item81 item82 item83 "
    "item84 item85 item86 item87 item88 item89 item90 item91 item92 "
    "item93 item94 item95 item96 item97 item98 item99"
).split()


def default_player() -> dict:
    p = {f: "0" for f in CHAR_FIELDS}
    p["charname"] = GUEST_CHAR.split(",")[0]
    p["playerlevel"] = "1"
    p["playerxp"] = "0"
    p["playermoney"] = "5000"
    p["playergold"] = "25"
    p["playerexp"] = "0"
    p["playerhonor"] = "0"
    p["playerreputation"] = "0"
    p["playerhealth"] = "100"
    p["playermana"] = "100"
    p["playerenergy"] = "100"
    p["playermaxhealth"] = "100"
    p["playermaxmana"] = "100"
    p["playermaxenergy"] = "100"
    p["playergun"] = "0"
    p["ammo"] = "0"
    return p


def load_state() -> dict:
    try:
        with open(STATE_FILE) as fh:
            return json.load(fh)
    except Exception:
        return {"player": default_player(), "chars": GUEST_CHAR,
                "username": "Guest", "town": {},
                "gold": "25", "unlocked": []}


def save_state(state: dict) -> None:
    try:
        with open(STATE_FILE, "w") as fh:
            json.dump(state, fh, indent=1)
    except Exception:
        pass


STATE = load_state()


def player_row() -> str:
    """The game parses the player row as a comma-separated list in a fixed
    field order. Build it from CHAR_FIELDS."""
    p = STATE["player"]
    return ",".join(str(p.get(f, "0")) for f in CHAR_FIELDS)


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=ROOT, **kw)

    def log_message(self, fmt, *args):
        sys.stderr.write("  [solo] " + (fmt % args) + "\n")

    def log_request(self, code="-", size="-"):
        sys.stderr.write("  [solo] REQ %s %s (%s bytes)\n" % (self.command, self.path, size))

    def _send(self, code, body, ctype="text/plain"):
        if isinstance(body, str):
            body = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.send_header("Access-Control-Allow-Methods", "GET,POST,OPTIONS")
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        if self.command != "HEAD":
            self.wfile.write(body)

    def do_OPTIONS(self):
        self._send(200, b"")

    def do_GET(self):
        self._route("GET")

    def do_POST(self):
        self._route("POST")

    def _body(self) -> str:
        n = int(self.headers.get("Content-Length") or 0)
        if not n:
            return ""
        raw = self.rfile.read(n)
        # The game posts form-encoded data with a JSON payload.
        try:
            from urllib.parse import parse_qs
            q = parse_qs(raw.decode("utf-8", "replace"))
            for v in q.values():
                if v and v[0].strip().startswith("{"):
                    return v[0]
            return raw.decode("utf-8", "replace")
        except Exception:
            return raw.decode("utf-8", "replace")

    def _route(self, method):
        path = urllib.parse.urlparse(self.path).path

        # --- PHP emulation -------------------------------------------------
        if "/server/" in path:
            ep = os.path.basename(path).replace(".php", "")
            return self._php(ep, method)

        # --- static ---------------------------------------------------------
        rel = path.lstrip("/")
        fs = os.path.join(ROOT, rel)
        if os.path.isfile(fs):
            with open(fs, "rb") as fh:
                data = fh.read()
            return self._send(200, data, self.guess_type(fs))
        return self._send(404, b"not found")

    def _php(self, ep, method):
        body = self._body()
        sys.stderr.write("  [solo] PHP %s %s body=%r\n" % (method, ep, body[:400]))
        p = STATE["player"]

        # ---- LOGIN -------------------------------------------------------
        if ep in ("login", "login_internal"):
            # The game parses this response as URL variables
            # (QueryManagerBase.loginComplete), NOT as JSON.
            STATE["chars"] = GUEST_CHAR
            save_state(STATE)
            params = {
                "status": "0",
                "chars": GUEST_CHAR,
                "username": "Guest",
                "id": "1",
                "motd": "Welcome to Straw Hat Samurai Duels (local solo build).",
                "magicnum": "0",
                "email": "solo@localhost",
                "verified": "1",
                "playertoken": "solo-token",
                "playerrow": player_row(),
                "gold": "25",
                "town": "",
                "unlocked": "",
            }
            return self._send(200, urlencode(params),
                              "application/x-www-form-urlencoded")

        # ---- REGISTER ----------------------------------------------------
        if ep == "register":
            STATE["chars"] = GUEST_CHAR
            save_state(STATE)
            params = {
                "status": "0", "chars": GUEST_CHAR,
                "username": "Guest", "id": "1", "motd": "Welcome to Straw Hat Samurai Duels (local solo build).",
                "magicnum": "0", "email": "solo@localhost", "verified": "1",
                "playertoken": "solo-token", "playerrow": player_row(),
                "gold": "25", "town": "", "unlocked": "",
            }
            return self._send(200, urlencode(params),
                              "application/x-www-form-urlencoded")

        # ---- SAVE PLAYER -------------------------------------------------
        if ep in ("saveplayer", "saveplayer_internal"):
            for kv in body.split("&"):
                if "=" in kv:
                    k, v = kv.split("=", 1)
                    k = urllib.parse.unquote(k)
                    v = urllib.parse.unquote(v)
                    if k in p:
                        p[k] = v
            save_state(STATE)
            return self._send(200, json.dumps({"status": 0}), "application/json")

        # ---- GOLD / STATS ------------------------------------------------
        if ep == "getgold":
            return self._send(200, json.dumps({"status": 0, "gold": p["playergold"]}),
                              "application/json")
        if ep == "getstats":
            return self._send(200, json.dumps({"status": 0, "playerrow": player_row()}),
                              "application/json")

        # ---- TOWN / WORLD -------------------------------------------------
        if ep in ("gettown", "getwar"):
            return self._send(200, json.dumps({
                "status": 0, "town": STATE["town"], "war": {},
            }), "application/json")

        # ---- GENERIC -----------------------------------------------------
        return self._send(200, urlencode({"status": "0", "message": "ok"}),
                          "application/x-www-form-urlencoded")


class Server(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True


if __name__ == "__main__":
    os.chdir(ROOT)
    print(f"[solo] serving {ROOT}")
    print(f"[solo] game   : http://playerio.localhost:{PORT}/shs3_patched.swf")
    print(f"[solo] php    : http://playerio.localhost:{PORT}/solo/server/*.php")
    print(f"[solo] guest  : {GUEST_CHAR}")
    with Server(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
