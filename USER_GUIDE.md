# Straw Hat Samurai: Duels — User Guide

## 1. Quick start

1. Clone the repo
2. Run the launcher for your OS
3. Your browser opens the game
4. Click **Play as Guest**

That is it. You do not need to install Flash or anything else — the browser player (Ruffle) is included.

## 2. Commands

**macOS / Linux:**
```bash
./play.sh
```

**Windows:**
```bat
play.bat
```

To stop the game, close the launcher terminal/window.

## 3. First-time hosts-file fix (rare)

The game checks that its URL contains `playerio`. We use `http://playerio.localhost:8765/`, and on most modern computers `*.localhost` already points to `127.0.0.1`.

If your browser says it cannot find `playerio.localhost`, add one line to your hosts file:

```
127.0.0.1  playerio.localhost
```

- **macOS / Linux:** `sudo nano /etc/hosts`, paste the line, save (Ctrl+O, Enter, Ctrl+X).
- **Windows:** run Notepad as Administrator, open `C:\Windows\System32\drivers\etc\hosts`, paste the line, save.

Then re-run `./play.sh` / `play.bat`.

## 4. What you will see

After clicking **Play as Guest**, the game auto-logs you in and drops you into the overworld. You can:
- move around,
- talk to NPCs,
- enter quests,
- use skills and shops,
- close and reopen the game — your Guest save is still there.

## 5. Saves

Your progress is stored in a local file called `.solo_state.json` next to `play.py`. If you delete that file, you start fresh.

## 6. Troubleshooting

| Problem | Fix |
|---|---|
| Browser says “Site-locked” | Make sure the URL is `http://playerio.localhost:8765/`, not `http://localhost:8765/`. |
| Browser cannot connect | The server might not have started. Re-run `./play.sh` / `play.bat`. |
| `python3` not found (Windows) | Install Python 3 from https://python.org and make sure “Add Python to PATH” is checked. |
| Game looks small / off-centre | Press F11 for full-screen, or click the Ruffle fullscreen button. |

## 7. What does not work

- **PvP / multiplayer:** the original PlayerIO backend is dead.
- **Premium purchases:** the payment server is dead; the game just pretends you have 0 coins.

If you only want to explore the solo world and quests, this build does exactly that.
