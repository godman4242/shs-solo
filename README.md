# Straw Hat Samurai: Duels — Local Solo Build

A playable offline copy of *Straw Hat Samurai: Duels* (v0.682), rebuilt from the original game files and a small local emulator.

## Play it (any OS)

You only need **Git** and **Python 3**.

**macOS / Linux:**
```bash
git clone https://github.com/godman4242/shs-solo.git
cd shs-solo
./play.sh
```

**Windows:**
```bat
git clone https://github.com/godman4242/shs-solo.git
cd shs-solo
play.bat
```

Your default browser opens to the game. Click **Play as Guest** — it runs entirely on your machine; nothing phones home.

If `playerio.localhost` does not load, add `127.0.0.1 playerio.localhost` to your hosts file once:
- **macOS/Linux:** `sudo nano /etc/hosts`
- **Windows:** edit `C:\Windows\System32\drivers\etc\hosts` as Administrator

## What works vs. what does not

| Feature | Status |
|---|---|
| Solo overworld, quests, NPCs, shops, skills | ✅ works |
| Saves (Guest character) | ✅ works locally in `.solo_state.json` |
| Sound, music, art, UI | ✅ works |
| PvP / multiplayer | ❌ needs the dead PlayerIO server — not possible today |
| Premium currency / payments | ❌ the payment server is dead — ignored |

## Project layout

| Path | What it is |
|---|---|
| `shs3_solo.swf` | The patched game (byte-repointed to your local machine) |
| `solo_server.py` | Tiny Python server that pretends to be the dead PHP backend and serves the assets |
| `play.py` / `play.sh` / `play.bat` | One-click launcher for your OS |
| `index.html` + `ruffle.js` + `*.wasm` | Browser-based Flash player (Ruffle) — no separate install needed |
| `res/`, `data/`, `lang/` | Game assets mirrored locally |
| `patches/` | The exact source changes made to the game to make it run offline |

## Need more detail?

See **[USER_GUIDE.md](<USER_GUIDE.md>)** for setup, controls, what you will see on screen, and troubleshooting.

### How we did it — full course

Want the whole story? **[Reviving a Dead Game](<REVIVAL-COURSE.md>)** is a build-along course on exactly how this rebuild was made — diagnosing the death, decompiling the client, reading the dead server's protocol out of the game's own parsing code, the 43-character byte patch, the two emulators, honest limits, and a reusable 7-step playbook for reviving other dead games.

- **Read on GitHub:** [REVIVAL-COURSE.md](<REVIVAL-COURSE.md>)
- **Download (PDF, recordings-free):** [REVIVAL-COURSE.pdf](<REVIVAL-COURSE.pdf>)

## Technical preservation notes

The game is **not** open source. This repo preserves the compiled SWF and the surviving assets so the game can still be played after the original servers shut down. The PHP backend (`strawhatsamuraiduels.com`) is NXDOMAIN and the PlayerIO RPC backend returns HTTP 500, so the online features are gone. The local server emulates just enough of the login/data API to make the solo portion of the game work.

For the full patch list, build notes, and asset recovery log, see the files under `docs/` and `patches/`.
