# Straw Hat Samurai Duels — User Guide

Play the old Flash browser game *Straw Hat Samurai Duels* v0.682 entirely offline
on your own computer.

## What you need

- **Python 3** (already on most Macs and Linux boxes)
- **Ruffle** — the open-source Flash emulator (only for the desktop app way)
- A web browser (for the browser way)

No Adobe Flash needed. Nothing is downloaded at runtime — the game is fully offline.

## Quick start

There are **two ways to play**. Both need the local server running, because the
game's PHP backend (login, quests, items) lives on your own machine.

### Way 1 — the desktop app (best experience)

```bash
git clone https://github.com/godman4242/shs-solo.git
cd shs-solo
./play.sh
```

`play.sh` starts the local server and opens the game in the **Ruffle desktop app**.
This is the way to play — it runs at full speed with sound.

If Ruffle isn't installed (only needed once):

```bash
brew install --cask ruffle
```

### Way 2 — in your browser

```bash
git clone https://github.com/godman4242/shs-solo.git
cd shs-solo
python3 solo_server.py
```

Then open **http://playerio.localhost:8765/** in your browser.

> **Important:** use `playerio.localhost`, not `localhost` and not `127.0.0.1`.
> The game has its own anti-piracy check that rejects any URL whose host
> doesn't contain the word "playerio". With the wrong host you get a
> "Site locked" error and nothing loads.

On Windows use `python3 solo_server.py` (or `py solo_server.py`).
Way 1 (`./play.sh`) is macOS/Linux only.

## What you will see

The game auto-logs in as **Guest** and drops you into the opening screen.
From there:

1. **Choose your character** — pick a look, then confirm
2. **The intro** — a short story sequence (press Space / click to advance)
3. **Kasuta Forest** — you're in. Action Points (AP) top-left, Experience bar
   below it, and the story quest **"LOOK FOR A MAN"** in the top-right

## How to play

| What | How |
|---|---|
| Move | Click anywhere on the ground — the character walks there |
| Talk to NPCs | Click the NPC |
| Attack / duel | Click an enemy |
| Quests | Top-right panel; click the tracker for the current objective |
| Shop | Click the shop keeper, or the coin/shop icon |
| Inventory & stats | HUD icons (bag = items, person = character sheet) |

**Fighting:** click an enemy and your character duels it. Click again at the
right moment on the timing bar to land a hit. AP is the fuel — each attack
costs AP and AP refills slowly, so you fight in bursts and explore in between.

**Progressing:** finish "LOOK FOR A MAN" in Kasuta Forest to get your first
real mission. Quests chain from there into territories and sectors — the quest
tracker tells you where to go next.

## Troubleshooting

| Problem | Fix |
|---|---|
| **"Site locked" / nothing loads in browser** | Wrong host. Use `http://playerio.localhost:8765/` — the word `playerio` must be in the URL |
| **`ruffle: command not found`** | `brew install --cask ruffle` (macOS) |
| **Black screen for 10–20 seconds** | Normal. Ruffle is compiling the SWF to WebAssembly. Wait, then refresh once |
| **Stuck on "Connecting..."** | The local server isn't running. Run `python3 solo_server.py` in another terminal |
| **"Connection refused"** | Port 8765 is taken by an old instance. `pkill -f solo_server.py` then start again |
| **Empty white page in browser** | You're on `localhost` instead of `playerio.localhost` |
| **Boots but no characters appear** | Asset files missing. Re-clone the repo — don't copy it by hand |
| **Frozen / no sound** | Close other tabs; the server is single-threaded and one heavy page can starve it |

### If something is really broken

```bash
pkill -f solo_server.py
pkill -f ruffle
cd shs-solo
python3 solo_server.py
```

Every request the game makes is logged to the terminal. A healthy boot looks
like this — note there is **no `r.playerio.com`** in the log, because assets
are served from your own machine:

```
[solo] REQ GET /shs3_solo.swf
[solo] REQ GET /solo/server/login_internal.php
[solo] REQ GET /r/.../res/shs3resource.swf
[solo] REQ GET /r/.../lang/shs3_en.xml
[solo] REQ GET /r/.../data/questdata.xml
[solo] quest engine loaded
```

If you see `r.playerio.com` in there, your `shs3_solo.swf` is the old one —
re-download the repo.

## What works / what doesn't

**Works**
- Full solo campaign: overworld, quests, NPCs, items, equipment, skills
- Combat against AI enemies, character progression
- All music and sound

**Doesn't work**
- **PvP duels** — the original PlayerIO multiplayer server is dead
- **Minimap** — the CDN's `mapdata.xml` is empty and no backup exists
- **Premium purchases** — the payment backend (`whipflash.com`) is gone

## Note

This is a preservation build. The original source repo was never released; the
game was reconstructed by decompiling the SWF and patching the network calls so
it runs offline. Assets are mirrored locally, so the game keeps working even
if the original CDN disappears.
