# Straw Hat Samurai Duels — User Guide

Play the old Flash browser game *Straw Hat Samurai Duels* v0.682 entirely offline on your own computer.

## What you need

- Python 3
- A web browser (Chrome, Brave, Firefox, Safari)
- No Adobe Flash — the game runs through [Ruffle](https://ruffle.rs/)

## Quick start

```bash
git clone https://github.com/godman4242/shs-solo.git
cd shs-solo
./play.sh
```

On Windows, run `python3 solo_server.py` and open `http://playerio.localhost:8765/` in your browser.

## What you will see

The game auto-logs in as Guest and drops you into **KASUTA FOREST**:
- Action Points, Experience, and the quest **"LOOK FOR A MAN"**
- Territories, sectors, NPCs, shops, quests
- Animated solo adventure in the overworld

## Controls

- **Move:** click the ground
- **Interact:** click NPCs / objects
- **Combat:** click enemies for a duel
- **Character / inventory:** HUD icons

## Troubleshooting

| Problem | Fix |
|---|---|
| Stuck at login | Make sure `solo_server.py` is running |
| Black screen | Wait 10 seconds for Ruffle to compile |
| "Site locked" | `playerio.localhost` contains the required keyword and resolves to 127.0.0.1 |
| No overworld | Restart the server to get a fresh guest profile |

## What works / what doesn't

✅ Solo campaign, quests, NPCs, items, skills, AI combat  
❌ PvP multiplayer, minimap (empty `mapdata.xml`), premium purchases

## Note

This is a preservation build. The original source repo was never released; the game was reconstructed by decompiling the SWF and patching the network calls so it can run offline.
