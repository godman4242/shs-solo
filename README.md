# Straw Hat Samurai Duels — Local Solo Build

A playable offline build of *Straw Hat Samurai Duels* (v0.682), reconstructed
from the game's own decompiled source and the surviving CDN assets.

## Play it

```bash
cd . && ./play.sh
```

It auto-logs in as **Guest** and auto-starts into the overworld. No clicking
needed (synthetic input is unreliable in headless/automated contexts anyway).

## What is real vs. what is dead (verified 2026-10-30)

| Component | Status |
|---|---|
| Game code (954 ActionScript classes) | ✅ recovered — decompiled from the real SWF |
| Game assets (`res/*.swf`, `data/*.xml`, `lang/*.xml`) | ✅ still live on `cdn.playerio.com` (16 MB) |
| `strawhatsamuraiduels.com` PHP backend | ❌ **NXDOMAIN** — dead |
| PlayerIO RPC backend (`r.playerio.com`) | ❌ **HTTP 500** — dead |
| `whipflash.com` (premium payments) | ❌ HTTP 502 — dead, payments only |
| `cdn.playerio.com` GameFS | ✅ HTTP 200 — still serving |

**Conclusion:** the game is *not* deleted. The code and nearly all the content
survive. What is gone is the *multiplayer server*. So this build is **solo
only** — PvP cannot work without a PlayerIO backend.

## How it works

### 1. Assets mirrored locally
`solo_server.py` serves the SWF, the 5 resource libraries, the data XMLs and
the language pack from `public/`-style local paths.

### 2. The hardcoded PHP URL is patched
The SWF hardcodes its backend base:
```
http://www.strawhatsamuraiduels.com/server/     (43 bytes, dead)
```
It is byte-patched to:
```
http://playerio.localhost:8765/solo/server/      (also exactly 43 bytes)
```
`playerio` must stay in the replacement — the game's own anti-piracy gate
`GameEngine.checkSiteLock()` only accepts URLs containing `playerio`,
`strawhatsamuraiduels.com` or `explosivebarrel.net`. `*.localhost` resolves to
127.0.0.1 on macOS, so no `sudo` and no `/etc/hosts` edit is needed.

### 3. Source patches (JPEXS `-replace`)

All patches live in `patches/` as decompiled `.as` files.

| File | Patch | Why |
|---|---|---|
| `StatsManager.as` | `useCirrus = false` | Cirrus was a 2003-era RTMFP P2P socket to `rtmfp://218.99.12.19/shs3/`. `NetworkManager.connected` reads a dead PlayerIO connection, so `loginComplete` never called `serverResponse(0)` and login hung forever. |
| `StatsManager.as` | `server = "http://playerio.localhost:8765/solo/server/"` | Repoint the backend. |
| `QueryManagerBase.as` | `autoLogin()` → guest session, `offlineMode = true` | Skips the login round-trip; `offlineMode` also makes the game load `data/*.xml` locally. |
| `QueryManagerBase.as` | `loadCharCookieData()` seeds `STAT_LOCATION=8382465`, `STAT_LOCATION_ROOM=0` | Without a saved SharedObject the game returned early with location `0` and the world never loaded. Node 8382465 is the starting town (Kasuta Forest). |
| `QueryManagerPIO.as` | `autoLogin()` override → guest session | The base-class patch was bypassed by the subclass override. |
| `QueryManagerPIO.as` | `getPayVaultCoins()` returns 0 when the vault is null | The premium-currency backend is dead; this was throwing every frame. |
| `GameEngine.as` | `initTitleScreen()`: create `titleMCS` **before** `new TitleUI()` | Ordering bug: `TitleUI`'s constructor triggers auto-login → `resetTitleMCS()` → dereferences `titleMCS`, which did not exist yet → Error #1009. |
| `GameEngine.as` | `initTitleScreen()`: `MCSCharacter.initAnimationData()` if `animList == null` | `animList` is normally only built during battle setup, so `startAnim()` threw. |
| `GameEngine.as` | `resetTitleMCS()` null-guard | Belt and braces. |
| `GameEngine.as` | `initBattleMode()`: create `OverworldHUD` if null | The HUD is normally created by `NetworkManager` when the P2P session connects. |
| `GameEngine.as` | `initOverworld()`: create `Overworld.map` | Same — `Overworld.map` was only assigned by the dead network path; `Overworld.update()` dereferences it every frame. |
| `GameEngine.as` | guard `OverworldMap.init()` | `mapdata.xml` on the live CDN is empty (65 bytes), so `QuestEngine.getMapSquareData()` returns null. The minimap overlay is optional. |
| `LoginForm.as` | offline `serverResponse(0)` → `switchToReady()` | Offline mode normally jumps to Character Create, whose form assets are missing in this build. |
| `TitleUI.as` | `switchToReady()` auto-calls `startgame()` after 1.5 s | Removes the need to click START GAME. |

### 4. The local PHP emulator
`solo_server.py` answers `login_internal.php` with the exact contract the game
parses (`QueryManagerBase.loginComplete` reads the response as **URL variables**,
not JSON):

```
status=0 & chars=<name>,<level> & id=1 & motd=... & magicnum=0
& username=Guest & verified=1 & playerrow=<116 comma-separated fields>
```

`status=0` is the success branch → `serverResponse(0)` → character select →
START GAME → overworld.

## Verification (2026-10-30)

```
frame errors : 0
AVM2 errors  : 0
boot chain   : offline load user data complete → load cookie data
               → startExploreMode() → startAdventureMode()
stage        : 11 display objects, hud=true
screen       : "KASUTA FOREST", "ACTION POINTS", "EXPERIENCE POINTS",
               "STORY QUEST: LOOK FOR A MAN", "TERRITORY", "SECTOR(0,3)",
               "BALANCED STANCE"
```

The overworld renders with the quest system, HUD, territories and character
animation all live.

## Known limitations

- **No PvP.** The PlayerIO backend is dead; duels need a live socket server.
- **No overworld minimap.** `mapdata.xml` is empty on the CDN and no archived
  copy was found. Everything else in the world works.
- **Premium currency / whipflash features** are dead (server gone).
- The `logonready` main menu *renders* correctly — the auto-start just skips it.

## Rebuilding the patched SWF

```bash
java -jar ffdec/ffdec.jar -replace build.swf out.swf StatsManager patches/StatsManager.as
```

Requires JPEXS Flash Decompiler (https://github.com/jindrapetrik/jpexs-decompiler).

## User Guide

See [USER_GUIDE.md](<USER_GUIDE.md>) for step-by-step activation + play instructions.

## Files

```
.
├── shs3_solo.swf          the patched game (play this)
├── shs3_decoded.swf       unmodified deobfuscated SWF (input to the patcher)
├── solo_server.py         local asset server + PHP emulator
├── index.html             browser build (Ruffle web player)
├── play.sh                launcher
├── patches/               the 6 patched .as files
├── data/  res/  lang/     mirrored game assets
├── USER_GUIDE.md           step-by-step player guide
└── ruffle.js + *.wasm     Ruffle web player (optional, for the browser build)
```
