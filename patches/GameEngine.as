package
{
   import com.flappsh.WhipFlash;
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Stage;
      import flash.events.Event;
   
   import flash.utils.ByteArray;
   import flash.geom.Rectangle;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageScaleMode;
   import flash.events.FullScreenEvent;
   import flash.geom.Point;
   
   public class GameEngine
   {
      
      internal static var stageMC:Stage;
      
      internal static var loadingScreen:LoadingScreen = new LoadingScreen();
      
      internal static var titleScreenBG:GameStage;
      
      internal static var titleScreenUI:TitleUI;
      
      internal static var titleMCS:MCSCharacter;
      
      internal static var overworld:Overworld;
      
      internal static var questID:int;
      
      internal static var action:int;
      
      internal static var returnToAdventureMode:Boolean = false;
      
      internal static var isPaused:Boolean = false;
      
      internal static var playbackClient:Boolean = false;
      
      internal static var playbackClientShowSlash:Boolean = false;
      
      internal static var whipFlashInitialized:* = false;
      
      internal static var MODE_INIT:int = 0;
      
      internal static var MODE_TITLE:int = 1;
      
      internal static var gameMode:int = MODE_TITLE;
      
      internal static var MODE_OVERWORLDLOADING:int = 2;
      
      internal static var MODE_OVERWORLD:int = 3;
      
      internal static var MODE_BATTLELOADING:int = 4;
      
      internal static var MODE_BATTLELOADINGDONE_WAITINGFORCLICK:int = 5;
      
      internal static var MODE_TITLESTOP:int = 6;
      
      internal static var MODE_BATTLE:int = 7;
      
      internal static var MODE_BATTLEENDWIN:int = 8;
      
      internal static var MODE_BATTLEENDLOSE:int = 9;
      
      internal static var MODE_BATTLEENDWINDUEL:int = 10;
      
      internal static var MODE_BATTLEENDLOSEDUEL:int = 11;
      
      internal static var ACTION_NOTHING:int = 0;
      
      internal static var ACTION_FIGHT:int = 1;
      
      internal static var ACTION_ASSASSINATE:int = 2;
      
      internal static var ACTION_ESCORT:int = 3;
      
      internal static var ACTION_SURVIVE:int = 4;
      
      internal static var ACTION_REACHMARKER:int = 5;
      
      internal static var ACTION_DUEL:int = 6;
      
      internal static var ACTION_ADVENTURE:int = 7;
      
      internal static var ACTION_HARVEST:int = 8;
      
      internal static var ACTION_SURVIVALMODE:int = 9;
      
      internal static var ACTION_WARROOMBATTLE:int = 10;
      
      internal static var ACTION_PLAYBACK:int = 11;
      
      internal static var ACTION_PVPROOM:int = 12;
      
      internal static var ACTION_CUTSCENE:int = 13;
      
      internal static var ACTION_SURVIVECLEANUP:int = 14;
      
      internal static var u_blocker:Blocker;
      
      internal static var d_blocker:Blocker;
      
      internal static var l_blocker:Blocker;
      
      internal static var r_blocker:Blocker;
      
      internal static var counter:int = 0;
      
      internal static var topParent:DisplayObject;
       
      
      public function GameEngine()
      {
         super();
      }
      
      public static function getGameMode() : int
      {
         return gameMode;
      }
      
      public static function setGameMode(param1:int) : *
      {
         gameMode = param1;
      }
      
      public static function isTitle() : Boolean
      {
         return gameMode == MODE_TITLE;
      }
      
      public static function isBattleMode() : Boolean
      {
         return gameMode == MODE_BATTLE;
      }
      
      public static function isOverworld() : Boolean
      {
         return gameMode == MODE_OVERWORLD;
      }
      
      public static function isPlayback() : Boolean
      {
         return action == ACTION_PLAYBACK || action == ACTION_CUTSCENE;
      }
      
      public static function setStageMC(param1:Stage) : *
      {
         stageMC = param1;
         stageMC.scaleMode = StageScaleMode.NO_SCALE;
         stageMC.align = StageAlign.TOP_LEFT;
         stageMC.addEventListener(Event.RESIZE,resizeHandler);
         stageMC.addEventListener(FullScreenEvent.FULL_SCREEN,fullScreenHandler);
         stageMC.showDefaultContextMenu = false;
         resizeHandler(null);
         loadingScreen.visible = false;
      }
      
      public static function setFullScreen() : *
      {
         var gameStage:GameStage;
         var newScale:Number = stageMC.fullScreenHeight / 800;
         if(titleScreenUI != null)
         {
            titleScreenUI.scaleX = newScale;
            titleScreenUI.scaleY = newScale;
         }
         if(titleScreenBG != null)
         {
            titleScreenBG.scaleX = newScale;
            titleScreenBG.scaleY = newScale;
         }
         if(OverworldHUD.instance != null)
         {
            OverworldHUD.instance.scaleX = newScale;
            OverworldHUD.instance.scaleY = newScale;
         }
         if(BattleUI.instance != null)
         {
            BattleUI.instance.scaleX = newScale;
            BattleUI.instance.scaleY = newScale;
         }
         gameStage = StageManager.getGameStage();
         if(gameStage != null)
         {
            gameStage.scaleX = newScale;
            gameStage.scaleY = newScale;
         }
         stageMC.fullScreenSourceRect = new Rectangle(0,0,800 * newScale,480 * newScale);
         StatsManager.stageScale = newScale;
         StatsManager.stageOffsetX = 0;
         StatsManager.stageOffsetY = 0;
         StatsManager.stageShowingFriendBar = false;
         try
         {
            stageMC.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
         catch(error:Error)
         {
            trace("cannot fullscreen");
            unFullScreen();
         }
      }
      
      public static function leaveFullScreen() : *
      {
         if(StatsManager.isFullScreen && !StatsManager.isMobile)
         {
            stageMC.displayState = StageDisplayState.NORMAL;
         }
      }
      
      internal static function fullScreenHandler(param1:FullScreenEvent) : *
      {
         if(param1.fullScreen)
         {
            StatsManager.isFullScreen = true;
         }
         else
         {
            unFullScreen();
         }
      }
      
      internal static function unFullScreen() : *
      {
         StatsManager.isFullScreen = false;
         if(gameMode != MODE_TITLE)
         {
            StatsManager.doFullScreen = false;
            if(OverworldHUD.instance.optionsUI != null)
            {
               OverworldHUD.instance.optionsUI.fullscreencheck.setCheck(false);
            }
         }
         if(titleScreenUI != null)
         {
            titleScreenUI.scaleX = 1;
            titleScreenUI.scaleY = 1;
         }
         if(titleScreenBG != null)
         {
            titleScreenBG.scaleX = 1;
            titleScreenBG.scaleY = 1;
         }
         if(OverworldHUD.instance != null)
         {
            OverworldHUD.instance.scaleX = 1;
            OverworldHUD.instance.scaleY = 1;
         }
         if(BattleUI.instance != null)
         {
            BattleUI.instance.scaleX = 1;
            BattleUI.instance.scaleY = 1;
         }
         var _loc1_:GameStage = StageManager.getGameStage();
         if(_loc1_ != null)
         {
            _loc1_.scaleX = 1;
            _loc1_.scaleY = 1;
         }
         StatsManager.stageScale = 1;
         resizeHandler(null);
      }
      
      internal static function resizeHandler(param1:Event) : void
      {
         var _loc2_:int = 800;
         var _loc3_:int = 480;
         var _loc4_:int = 690;
         var _loc5_:Number = _loc2_ / _loc3_;
         var _loc6_:Number = _loc2_ / _loc4_;
         var _loc7_:Number;
         if((_loc7_ = stageMC.stageWidth / stageMC.stageHeight) <= _loc6_)
         {
            _loc5_ = _loc6_;
            _loc3_ = _loc4_;
            StatsManager.stageShowingFriendBar = true;
            if(OverworldHUD.instance != null)
            {
               OverworldHUD.instance.friendpanel.init();
            }
         }
         else
         {
            StatsManager.stageShowingFriendBar = false;
         }
         var _loc8_:Number = 1;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Boolean = false;
         if(_loc5_ >= _loc7_)
         {
            _loc8_ = stageMC.stageWidth / _loc2_;
            _loc9_ = 0;
            _loc10_ = (stageMC.stageHeight - _loc3_ * _loc8_) / 2;
            _loc11_ = true;
         }
         else
         {
            _loc8_ = stageMC.stageHeight / _loc3_;
            _loc9_ = (stageMC.stageWidth - _loc2_ * _loc8_) / 2;
            _loc10_ = 0;
            _loc11_ = false;
         }
         StatsManager.stageScale = _loc8_;
         StatsManager.stageOffsetX = _loc9_;
         StatsManager.stageOffsetY = _loc10_;
         StatsManager.stageFitWidth = _loc11_;
         StatsManager.stageBaseWidth = _loc2_;
         StatsManager.stageBaseHeight = _loc3_;
         if(StatsManager.mainTimeLine.currentScene.name == "loading")
         {
            StatsManager.mainTimeLine.videocover.scaleX = _loc8_;
            StatsManager.mainTimeLine.videocover.scaleY = _loc8_;
            StatsManager.mainTimeLine.videocover.x = _loc9_;
            StatsManager.mainTimeLine.videocover.y = _loc10_;
            StatsManager.mainTimeLine.loadingScreen.scaleX = _loc8_;
            StatsManager.mainTimeLine.loadingScreen.scaleY = _loc8_;
            StatsManager.mainTimeLine.loadingScreen.x = _loc9_;
            StatsManager.mainTimeLine.loadingScreen.y = _loc10_;
            StatsManager.mainTimeLine.messageDialog.scaleX = _loc8_;
            StatsManager.mainTimeLine.messageDialog.scaleY = _loc8_;
            StatsManager.mainTimeLine.messageDialog.x = _loc9_;
            StatsManager.mainTimeLine.messageDialog.y = _loc10_;
            StatsManager.mainTimeLine.adloadertext.scaleX = _loc8_;
            StatsManager.mainTimeLine.adloadertext.scaleY = _loc8_;
            StatsManager.mainTimeLine.adloadertext.x = _loc9_ + 274 * _loc8_;
            StatsManager.mainTimeLine.adloadertext.y = _loc10_ + 355 * _loc8_;
            StatsManager.mainTimeLine.epicAds.scaleX = _loc8_;
            StatsManager.mainTimeLine.epicAds.scaleY = _loc8_;
            StatsManager.mainTimeLine.epicAds.x = _loc9_ + 234 * _loc8_;
            StatsManager.mainTimeLine.epicAds.y = _loc10_ + 67 * _loc8_;
            u_blocker = StatsManager.mainTimeLine.u_blocker;
            d_blocker = StatsManager.mainTimeLine.d_blocker;
            l_blocker = StatsManager.mainTimeLine.l_blocker;
            r_blocker = StatsManager.mainTimeLine.r_blocker;
            placeBlockers();
            return;
         }
         var _loc12_:GameStage;
         if((_loc12_ = StageManager.getGameStage()) != null)
         {
            _loc12_.doResize();
         }
         if(titleScreenUI != null)
         {
            titleScreenUI.doResize();
         }
         if(titleScreenBG != null)
         {
            titleScreenBG.scaleX = _loc8_;
            titleScreenBG.scaleY = _loc8_;
            titleScreenBG.x = _loc9_;
            titleScreenBG.y = _loc10_;
         }
         if(OverworldHUD.instance != null)
         {
            OverworldHUD.instance.doResize();
         }
         if(BattleUI.instance != null)
         {
            BattleUI.instance.doResize();
         }
      }
      
      public static function placeBlockers() : *
      {
         if(u_blocker == null)
         {
            u_blocker = new Blocker();
         }
         if(d_blocker == null)
         {
            d_blocker = new Blocker();
         }
         if(l_blocker == null)
         {
            l_blocker = new Blocker();
         }
         if(r_blocker == null)
         {
            r_blocker = new Blocker();
         }
         stageMC.addChild(u_blocker);
         stageMC.addChild(d_blocker);
         stageMC.addChild(l_blocker);
         stageMC.addChild(r_blocker);
         if(StatsManager.stageOffsetX == 0 && StatsManager.stageOffsetY == 0)
         {
            u_blocker.visible = false;
            d_blocker.visible = false;
            l_blocker.visible = false;
            r_blocker.visible = false;
            return;
         }
         if(StatsManager.stageFitWidth)
         {
            u_blocker.visible = true;
            d_blocker.visible = true;
            l_blocker.visible = false;
            r_blocker.visible = false;
         }
         else
         {
            u_blocker.visible = false;
            d_blocker.visible = false;
            l_blocker.visible = true;
            r_blocker.visible = true;
         }
         u_blocker.x = 0;
         u_blocker.y = 0;
         u_blocker.width = stageMC.stageWidth;
         u_blocker.height = StatsManager.stageOffsetY;
         d_blocker.x = 0;
         d_blocker.y = StatsManager.stageOffsetY + StatsManager.stageBaseHeight * StatsManager.stageScale;
         d_blocker.width = stageMC.stageWidth;
         d_blocker.height = StatsManager.stageOffsetY;
         l_blocker.x = 0;
         l_blocker.y = 0;
         l_blocker.width = StatsManager.stageOffsetX;
         l_blocker.height = stageMC.stageHeight;
         r_blocker.x = StatsManager.stageOffsetX + StatsManager.stageBaseWidth * StatsManager.stageScale;
         r_blocker.y = 0;
         r_blocker.width = StatsManager.stageOffsetX;
         r_blocker.height = stageMC.stageHeight;
      }
      
      public static function getStageMC() : Stage
      {
         return stageMC;
      }
      
      public static function startEngine() : *
      {
         if(stageMC == null)
         {
            trace("GameEngine.stageMC not set");
            return;
         }
         stageMC.addEventListener(Event.ENTER_FRAME,gameloop);
         new Tracker(stageMC);
         checkPlayBackMode();
         if(StatsManager.useExternalLang && !StatsManager.consoleEnabled)
         {
            checkSiteLock();
         }
         if(StatsManager.usePlayerIO)
         {
            checkFacebookLogin();
         }
         if(!whipFlashInitialized && !StatsManager.isMobile)
         {
            WhipFlash.initialize(stageMC,"a4c17b979682cb306cec1f5f177c748f6490c481",StatsManager.consoleEnabled);
            whipFlashInitialized = true;
         }
      }
      
      public static function stopEngine() : *
      {
         stageMC.removeEventListener(Event.ENTER_FRAME,gameloop);
         InputManager.disableInput();
      }
      
      public static function initTitleScreen() : *
      {
         titleScreenBG = new BG_BambooForest();
         MovieClip(titleScreenBG).redBG.visible = false;
         stageMC.addChild(titleScreenBG);
         // LOCAL SOLO BUILD FIX (ordering): titleMCS must exist BEFORE TitleUI is
         // constructed. TitleUI's constructor triggers autoLogin(), which calls
         // switchToCharacterCreate() -> resetTitleMCS(), which dereferences titleMCS.
         // Creating TitleUI first left titleMCS null -> Error #1009.
         // LOCAL SOLO BUILD FIX: MCSCharacter.animList is null at title-screen
         // time (it is normally only built during battle setup), so startAnim()
         // threw Error #1009 on animList[...]. Build it before creating the
         // title character.
         if(MCSCharacter.animList == null)
         {
            MCSCharacter.initAnimationData();
         }
         titleMCS = createTitleMCS();
         titleMCS.x = 150;
         titleMCS.y = 400;
         titleMCS.startAnim(MCSActor.WALK_SHEATHED);
         MovieClip(titleScreenBG).playercanvas.addChild(titleMCS);
         titleScreenUI = new TitleUI();
         stageMC.addChild(titleScreenUI);
         titleScreenBG.scaleX = StatsManager.stageScale;
         titleScreenBG.scaleY = StatsManager.stageScale;
         gameMode = MODE_TITLE;
         SoundManager.instance.playMusic(MusicManager.MUSIC_QUIET);
         GameEngine.startEngine();
         resizeHandler(null);
      }
      
      internal static function createTitleMCS() : MCSCharacter
      {
         var _loc1_:MCSCharacter = null;
         var _loc2_:String = QueryManager.instance.getLastCharacterEquipmentString();
         if(_loc2_ == "")
         {
            _loc1_ = new MCSCharacter();
            _loc1_.initMCS(new Item(4017),new Item(0),new Item(6019),new Item(0),new Item(0),new Item(0),new Item(0),new Item(11017),new Item(12017),new Item(13002));
         }
         else
         {
            _loc1_ = new MCSCharacter();
            StatsManager.parseEquipmentString(_loc2_);
            _loc1_.initMCS(StatsManager.equipment[StatsManager.EQ_ARMOR],StatsManager.equipment[StatsManager.EQ_GLOVES],StatsManager.equipment[StatsManager.EQ_HAIR],StatsManager.equipment[StatsManager.EQ_HAT],StatsManager.equipment[StatsManager.EQ_HEAD],StatsManager.equipment[StatsManager.EQ_MASK],StatsManager.equipment[StatsManager.EQ_NECK],StatsManager.equipment[StatsManager.EQ_PANTS],StatsManager.equipment[StatsManager.EQ_SHOES],StatsManager.equipment[StatsManager.EQ_WEAPON],StatsManager.equipment[StatsManager.EQ_SCABBARD].getItemID());
         }
         return _loc1_;
      }
      
      public static function resetTitleMCS() : *
      {
         // LOCAL SOLO BUILD: guard against a null titleMCS (Error #1009).
         if(titleMCS != null)
         {
            titleMCS.initMCS(new Item(4017),new Item(0),new Item(6019),new Item(0),new Item(0),new Item(0),new Item(0),new Item(11017),new Item(12017),new Item(13002));
         }
         if(StatsManager.getPlayerBust() != null)
         {
            StatsManager.getPlayerBust().initMCS(new Item(4017),new Item(6019),new Item(0),new Item(0),new Item(0),new Item(0));
         }
      }
      
      public static function leaveTitleScreen() : *
      {
         gameMode = MODE_INIT;
         QueryManager.instance.saveCharName();
         MovieClip(titleScreenBG).playercanvas.removeChild(titleMCS);
         titleMCS = null;
         stageMC.removeChild(titleScreenBG);
         titleScreenBG = null;
         stageMC.removeChild(titleScreenUI);
         titleScreenUI = null;
         showLoadingScreen();
         loadingScreen.setGameLoading();
         QueryManager.instance.loadCharData(StatsManager.charname);
      }
      
      public static function isLoadingScreen() : Boolean
      {
         return loadingScreen.visible;
      }
      
      public static function getRandomTip() : String
      {
         var _loc2_:String = null;
         var _loc1_:int = Math.random() * 39;
         if(_loc1_ == 0)
         {
            _loc2_ = "Tip: Select \"record duels\" in the options menu to record and rewatch your duels on Duels TV.";
         }
         else if(_loc1_ == 1)
         {
            _loc2_ = "Tip: When not in battle, try saying \"/sit\".";
         }
         else if(_loc1_ == 2)
         {
            _loc2_ = "Tip: When not in battle, try saying \"/bow\".";
         }
         else if(_loc1_ == 3)
         {
            _loc2_ = "Tip: When not in battle, try saying \"/kneel\".";
         }
         else if(_loc1_ == 4)
         {
            _loc2_ = "Tip: When sitting, say \"/stand\" to get back up.";
         }
         else if(_loc1_ == 5)
         {
            _loc2_ = "Tip: Try saying \"/fart\".";
         }
         else if(_loc1_ == 6)
         {
            _loc2_ = "Tip: When not in battle, try saying \"/gangnamstyle\".";
         }
         else if(_loc1_ == 7)
         {
            _loc2_ = "Tip: A green border indicates that an item is special.";
         }
         else if(_loc1_ == 8)
         {
            _loc2_ = "Tip: A blue border indicates that an item is rare.";
         }
         else if(_loc1_ == 9)
         {
            _loc2_ = "Tip: A purple border indicates that an item is unique.";
         }
         else if(_loc1_ == 10)
         {
            _loc2_ = "Tip: You can change whether your chat is broadcast the room, to your clan or to everyone.";
         }
         else if(_loc1_ == 11)
         {
            _loc2_ = "Tip: Stables can be used to quickly travel from town to town.";
         }
         else if(_loc1_ == 12)
         {
            _loc2_ = "Tip: In battle, you can use spacebar to change stance.";
         }
         else if(_loc1_ == 13)
         {
            _loc2_ = "Tip: In battle, you can use the number keys to activate your skills.";
         }
         else if(_loc1_ == 14)
         {
            _loc2_ = "Tip: In battle, you can drag and drop your skills to activate them at specific directions.";
         }
         else if(_loc1_ == 15)
         {
            _loc2_ = "Tip: Your location is only saved at special locations like towns and dungeons.";
         }
         else if(_loc1_ == 16)
         {
            _loc2_ = "Tip: You can tell which stance your opponent is using by the way he stands and runs.";
         }
         else if(_loc1_ == 17)
         {
            _loc2_ = "Tip: The quests, shops and items found in a town are related to the level of that town.";
         }
         else if(_loc1_ == 18)
         {
            _loc2_ = "Tip: Only the challenger is able to record duels.";
         }
         else if(_loc1_ == 19)
         {
            _loc2_ = "Tip: When fighting undead, target their heads.";
         }
         else if(_loc1_ == 20)
         {
            _loc2_ = "Tip: Complete quests for a village to help upgrade it to a town.";
         }
         else if(_loc1_ == 21)
         {
            _loc2_ = "Tip: Complete quests for a town to help upgrade it to a city.";
         }
         else if(_loc1_ == 22)
         {
            _loc2_ = "Tip: Complete quests for a city to help upgrade it to a castle.";
         }
         else if(_loc1_ == 23)
         {
            _loc2_ = "Tip: You should check out the Straw Hat Samurai comic.";
         }
         else if(_loc1_ == 24)
         {
            _loc2_ = "Tip: Wins are added to the leaderboards only when you defeat a live player in a duel.";
         }
         else if(_loc1_ == 25)
         {
            _loc2_ = "Tip: You can make money easily by buying goods from a market and selling in another town.";
         }
         else if(_loc1_ == 26)
         {
            _loc2_ = "Tip: When not in battle, you can hold down the mouse button to keep running in that direction.";
         }
         else if(_loc1_ == 27)
         {
            _loc2_ = "Tip: Crops grown from 12-hour seeds do not rot.";
         }
         else if(_loc1_ == 28)
         {
            _loc2_ = "Tip: Approach wildlife from behind to catch them without chasing them off.";
         }
         else if(_loc1_ == 29)
         {
            _loc2_ = "Tip: If you see a Red Oni, run! (Unless you think that you can beat him...)";
         }
         else if(_loc1_ == 30)
         {
            _loc2_ = "Tip: You can sneak pass Red Oni when they are napping.";
         }
         else if(_loc1_ == 31)
         {
            _loc2_ = "Tip: Sometimes if you are really quiet, you can hear what the fox says.";
         }
         else if(_loc1_ == 32)
         {
            _loc2_ = "Tip: If you do not seem to be doing much damage to an enemy, try using Heavy Stance.";
         }
         else if(_loc1_ == 33)
         {
            if(StatsManager.showChikakoAsNinja())
            {
               _loc2_ = LangManager.getString(723);
            }
            else
            {
               _loc2_ = "Tip: Play the story to unlock Chikako for special Ninja Services bonuses.";
            }
         }
         else if(_loc1_ == 34)
         {
            _loc2_ = "Tip: Scavenging Skill Level 5 lets you see hidden paths to secret areas.";
         }
         else if(_loc1_ == 35)
         {
            _loc2_ = "Tip: A higher speed stat will reduce skill cooldown times and also give you a longer slash line.";
         }
         else if(_loc1_ == 36)
         {
            _loc2_ = "Tip: Click on the minimap to see the entire world map.";
         }
         else if(_loc1_ == 37)
         {
            _loc2_ = "Tip: Converting a town through influence requires a team effort. You can\'t to do it alone.";
         }
         else if(_loc1_ == 38)
         {
            _loc2_ = "Tip: When you are out of AP, go duel or fight in the war room until it replenishes.";
         }
         return _loc2_;
      }
      
      public static function showLoadingScreen() : *
      {
         if(loadingScreen.visible)
         {
            return;
         }
         stageMC.addChild(loadingScreen);
         loadingScreen.scaleX = StatsManager.stageScale;
         loadingScreen.scaleY = StatsManager.stageScale;
         loadingScreen.x = StatsManager.stageOffsetX;
         loadingScreen.y = StatsManager.stageOffsetY;
         loadingScreen.setGameLoading();
         loadingScreen.visible = true;
         var _loc1_:int = Math.random() * 28;
         var _loc2_:String = getRandomTip();
         loadingScreen.tipstext.text = _loc2_;
         placeBlockers();
      }
      
      public static function hideLoadingScreen() : *
      {
         loadingScreen.visible = false;
      }
      
      public static function initOverworld() : *
      {
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         overworld = new Overworld(stageMC);
         hideLoadingScreen();
         gameMode = MODE_OVERWORLD;
         var _loc1_:int = StatsManager.getLocation();
         var _loc2_:Boolean = false;
         if(StatsManager.getPlayerStats(StatsManager.STAT_XP) == 0 && !StatsManager.checkActiveQuest("0"))
         {
            _loc1_ = 8382465;
            StatsManager.saveLocation(_loc1_);
            _loc2_ = true;
            Overworld.currentNode = _loc1_;
         }
         // LOCAL SOLO BUILD: Overworld.map is normally assigned by the embedded
         // assets.swf document class / NetworkManager path, neither of which runs
         // offline. Overworld.update() dereferences it every frame -> Error #1009.
         if(Overworld.currentNode == 0)
         {
            Overworld.currentNode = _loc1_;
         }
         if(Overworld.map == null)
         {
            // LOCAL SOLO BUILD: mapdata.xml on the live CDN is empty, so
            // QuestEngine.getMapSquareData() returns null and OverworldMap.init()
            // throws. The overworld minimap is optional - guard it.
            Overworld.map = new OverworldMap();
            try
            {
               Overworld.map.init(Overworld.currentNode);
            }
            catch(e:Error)
            {
               trace("SOLO: map init skipped (" + e + ")");
            }
         }
         var _loc3_:Point = NodeGenerator.instance.getTerritory(_loc1_);
         if(_loc1_ != 666 && !QuestEngine.hasTerritory(_loc3_.x,_loc3_.y))
         {
            trace("in non-territory, moving player",_loc3_);
            if((_loc6_ = NodeGenerator.instance.getNodeLevel(_loc1_)) < 10)
            {
               _loc1_ = 8382465;
            }
            else if(_loc6_ < 20)
            {
               _loc1_ = 8570879;
            }
            else if(_loc6_ < 30)
            {
               _loc1_ = 8800254;
            }
            else if(_loc6_ < 40)
            {
               _loc1_ = 9013236;
            }
            else if(_loc6_ < 50)
            {
               _loc1_ = 9037756;
            }
            else if(_loc6_ < 60)
            {
               _loc1_ = 9181094;
            }
            else if(_loc6_ < 70)
            {
               _loc1_ = 9168748;
            }
            else if(_loc6_ < 80)
            {
               _loc1_ = 9144102;
            }
            else
            {
               _loc1_ = 9365282;
            }
         }
         StageManager.setCurrentNode(_loc1_);
         QuestEngine.refreshNodeQuests(_loc1_);
         StatsManager.getPlayer().setScale(1);
         QuestEngine.startAdventureMode(_loc1_,_loc2_);
         StatsManager.parseGiftNotificationsString();
         var _loc4_:Boolean = false;
         if(QueryManager.instance.offlineMode)
         {
            if(!StatsManager.consoleEnabled)
            {
               OverworldHUD.instance.showDialog(LangManager.getString(295),LangManager.getString(5));
            }
         }
         else
         {
            if(StatsManager.usePlayerIO)
            {
               NetworkManager.instance.connectGlobalChat();
            }
            if(StatsManager.getLevel() >= 3 && StatsManager.getStat(30018) - QueryManager.instance.getServerTime() < 0)
            {
               OverworldHUD.instance.showGetDailyPrize();
               _loc4_ = true;
            }
         }
         var _loc5_:int = NodeGenerator.instance.getNodeLevel(_loc1_) - StatsManager.getLevel();
         if(!_loc4_)
         {
            if(_loc5_ < -3)
            {
               OverworldHUD.instance.showDialogBig(LangManager.getString(702),LangManager.getString(5));
            }
            else if(_loc5_ > 3 && _loc1_ != 666)
            {
               OverworldHUD.instance.showDialog(LangManager.getString(703),LangManager.getString(5));
            }
         }
         StatsManager.parseActiveQuestString();
         QuestEngine.refreshNodeQuests(_loc1_);
         StageManager.refreshRoomQuestObjects();
         if(StatsManager.activeQuestList.length > 0)
         {
            StatsManager.setStat(StatsManager.STAT_MARKEDNODE,0);
         }
         OverworldHUD.instance.territorymap.refresh();
         if(StatsManager.doFullScreen)
         {
            _loc7_ = stageMC.fullScreenHeight / 800;
            OverworldHUD.instance.scaleX = _loc7_;
            OverworldHUD.instance.scaleY = _loc7_;
         }
         placeBlockers();
      }
      
      public static function overworldToTitle() : *
      {
         gameMode = MODE_INIT;
         showLoadingScreen();
         stageMC.removeChild(overworld);
         overworld.destroy();
         overworld = null;
         stopEngine();
         initTitleScreen();
         TitleUI.instance.switchToReady();
      }
      
      public static function battleModeToTitle() : *
      {
         gameMode = MODE_INIT;
         showLoadingScreen();
         StageManager.disposeStage();
         stopEngine();
         initTitleScreen();
         leaveFullScreen();
         if(!QueryManager.instance.offlineMode)
         {
            QueryManager.instance.saveModifiedCharData();
            TitleUI.instance.switchToReady();
         }
         else
         {
            QueryManager.instance.logout();
            TitleUI.instance.switchToLogin();
         }
         StatsManager.reset();
         TitleUI.instance.doResize();
         if(titleScreenBG != null)
         {
            titleScreenBG.scaleX = StatsManager.stageScale;
            titleScreenBG.scaleY = StatsManager.stageScale;
            titleScreenBG.x = StatsManager.stageOffsetX;
            titleScreenBG.y = StatsManager.stageOffsetY;
         }
         placeBlockers();
      }
      
      public static function setCounter(param1:int) : *
      {
         counter = param1;
      }
      
      internal static function gameloop(param1:Event) : void
      {
         if(gameMode == MODE_TITLE)
         {
            titleScreenBG.scrollStage(-4);
            titleMCS.updateAnimation();
         }
         else if(gameMode == MODE_TITLESTOP)
         {
            titleScreenBG.scrollStage(-4);
            titleMCS.updateAnimation();
            ++counter;
            if(counter == 1)
            {
               TitleUI.instance.screenTransition.startClose(ScreenTransition.ACTION_NOTHING);
            }
            else if(counter == 25)
            {
               leaveTitleScreen();
               Tracker.instance.trackGameStart();
            }
         }
         else if(gameMode == MODE_OVERWORLD)
         {
            Overworld.update();
            StatsManager.update();
         }
         else if(gameMode == MODE_BATTLE && !isPaused)
         {
            StageManager.update();
            OverworldHUD.instance.screenTransition.update();
            if(action == ACTION_ADVENTURE || action == ACTION_PVPROOM)
            {
               StatsManager.update();
            }
            else if(action == ACTION_DUEL || action == ACTION_PLAYBACK || action == ACTION_CUTSCENE)
            {
               NetworkManager.instance.update();
            }
         }
         MusicManager.instance.update();
      }
      
      public static function togglePaused() : *
      {
         isPaused = !isPaused;
      }
      
      public static function setPaused(param1:Boolean) : *
      {
         isPaused = param1;
      }
      
      public static function setPvPRoomMode() : *
      {
         action = ACTION_PVPROOM;
      }
      
      public static function setAdventureMode() : *
      {
         action = ACTION_ADVENTURE;
      }
      
      public static function isSurviveCleanUp() : Boolean
      {
         return action == ACTION_SURVIVECLEANUP;
      }
      
      public static function isDuelMode() : Boolean
      {
         return gameMode != MODE_OVERWORLD && (action == ACTION_DUEL || action == ACTION_PLAYBACK || action == ACTION_CUTSCENE);
      }
      
      public static function isPvPRoomMode() : Boolean
      {
         return gameMode != MODE_OVERWORLD && action == ACTION_PVPROOM;
      }
      
      public static function isAdventureMode() : Boolean
      {
         return gameMode != MODE_OVERWORLD && action == ACTION_ADVENTURE;
      }
      
      public static function isPlayBack() : Boolean
      {
         return action == ACTION_PLAYBACK;
      }
      
      public static function isCutscene() : Boolean
      {
         return action == ACTION_CUTSCENE;
      }
      
      public static function shouldShowRespawn() : Boolean
      {
         if(isPvPRoomMode())
         {
            return false;
         }
         return !(questID == -1 && action == ACTION_DUEL) && action != ACTION_SURVIVALMODE && action != ACTION_WARROOMBATTLE;
      }
      
      public static function getAction() : int
      {
         return action;
      }
      
      public static function initBattleMode(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Vector.<XMLQuestWave>, param7:int, param8:Array = null, param9:int = 0) : *
      {
         // LOCAL SOLO BUILD: the overworld HUD is normally created by
         // NetworkManager when the (dead) P2P session connects. In offline mode
         // nothing creates it, so OverworldHUD.instance stays null.
         if(OverworldHUD.instance == null)
         {
            stageMC.addChild(new OverworldHUD());
         }
         trace("SOLO: initBattleMode, stage=" + stageMC.numChildren + " hud=" + (OverworldHUD.instance != null));
         // LOCAL SOLO BUILD DEBUG: capture the stage to a PNG so we can verify
         // the overworld actually renders.
         try
         {
         }
         catch(e:Error)
         {
            trace("SOLO: capture failed " + e);
         }
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(!QueryManager.instance.checkCurrentSessionId() && !isPlayBackClient())
         {
            OverworldHUD.instance.showMultipleClients();
            return;
         }
         OverworldHUD.instance.closeOpenDialogs(param2 == ACTION_WARROOMBATTLE);
         if(StageManager.getGameStage() != null)
         {
            StageManager.getGameStage().visible = true;
         }
         var _loc10_:*;
         if(_loc10_ = gameMode == MODE_BATTLE)
         {
            StageManager.saveReturnPosX();
            StageManager.clearRoom();
            NetworkManager.instance.leaveRoom();
         }
         gameMode = MODE_BATTLELOADING;
         questID = param1;
         returnToAdventureMode = _loc10_;
         action = param2;
         if(action != ACTION_ADVENTURE && param3 == GameStage.BG_BAMBOOFORESTTOWN)
         {
            param3 = GameStage.BG_BAMBOOFOREST;
         }
         if(!_loc10_ || param3 != -1 && StageManager.gameStageType != param3)
         {
            _loc12_ = 0;
            _loc13_ = 0;
            if(param8 != null && param8[param9] != null)
            {
               _loc12_ = int(param8[param9].getBGParam());
               _loc13_ = int(param8[param9].getBGParam2());
            }
            StageManager.initStage(action,stageMC,param3,param4,param5,_loc12_,_loc13_);
            MCSPool.init();
            ProjectilePool.init();
            MCSCharacter.initAnimationData();
            ProjectileManager.init();
            InputManager.initBattleMode();
         }
         else if(action != ACTION_ADVENTURE)
         {
            StageManager.reinitStage(action,param4,param5);
            InputManager.initBattleMode();
         }
         StatsManager.initPlayer();
         var _loc11_:MCSPlayer;
         (_loc11_ = StatsManager.getPlayer()).addToCanvas(StageManager.getGameStage().getPlayerCanvas());
         _loc11_.setPosition(param7,StageManager.getGroundY());
         _loc11_.mcs.faceRight();
         if(action == ACTION_DUEL || action == ACTION_PLAYBACK)
         {
            SoundManager.instance.playMusic(MusicManager.MUSIC_TOUGHBATTLE);
            StageManager.initDuel(param7 < StatsManager.stageWidth / 2);
            _loc11_.faceScreenCenter();
            _loc11_.startAction(MCSActor.IDLE_STATE);
            _loc11_.startAnim(MCSActor.BOW2);
            if(action == ACTION_PLAYBACK)
            {
               _loc11_.getMCS().visible = false;
               StageManager.initUIForPlayback();
            }
         }
         else if(action == ACTION_CUTSCENE)
         {
            _loc11_.getMCS().visible = false;
            StageManager.initUIForPlayback();
         }
         else if(action == ACTION_ADVENTURE || action == ACTION_PVPROOM)
         {
            StageManager.initRooms(param8,param9,param7);
         }
         else if(action == ACTION_WARROOMBATTLE)
         {
            SoundManager.instance.playMusic(MusicManager.MUSIC_PVP);
         }
         else if(action == ACTION_HARVEST)
         {
            SoundManager.instance.playMusic(MusicManager.MUSIC_DOJO);
         }
         else
         {
            SoundManager.instance.pickBattleMusic();
         }
         if(param6 != null)
         {
            NPCManager.init(param6);
         }
         ParticleSystemManager.getInstance().init();
         startBattleMode();
         if(action == ACTION_ADVENTURE)
         {
            InputManager.setAdventureMode();
         }
         else if(action == ACTION_PLAYBACK || action == ACTION_CUTSCENE)
         {
            InputManager.disableInput();
         }
         if(action == ACTION_HARVEST)
         {
            StageManager.hideForeground();
         }
      }
      
      public static function startBattleMode() : *
      {
         gameMode = MODE_BATTLE;
         InputManager.setBattleMode();
      }
      
      public static function endBattleMode(param1:Boolean) : *
      {
         var _loc2_:XMLNpc = null;
         if(param1 || action == ACTION_SURVIVALMODE || action == ACTION_WARROOMBATTLE)
         {
            gameMode = MODE_BATTLEENDWIN;
            if(action == ACTION_SURVIVALMODE)
            {
               OverworldHUD.instance.lootDialog.setSurvivalModeLoot();
               QueryManager.instance.updateGlobalVar(50005,NPCManager.getTotalKilled());
               StatsManager.getPlayer().setHP(StatsManager.getStat(StatsManager.STAT_HP));
               StatsManager.getPlayer().setChi(StatsManager.getStat(StatsManager.STAT_CHI));
               Overworld.endQuestStepIntro();
            }
            else if(action == ACTION_WARROOMBATTLE)
            {
               OverworldHUD.instance.lootDialog.setSurvivalModeLoot();
               QueryManager.instance.updateGlobalVar(50006,NPCManager.getTotalKilled());
               StatsManager.getPlayer().setHP(StatsManager.getStat(StatsManager.STAT_HP));
               StatsManager.getPlayer().setChi(StatsManager.getStat(StatsManager.STAT_CHI));
               if(StatsManager.getStat(60018) < NPCManager.getTotalKilled())
               {
                  StatsManager.reportAchievementStat(60018,NPCManager.getTotalKilled(),true);
               }
               Overworld.endQuestStepIntro();
            }
            else if(action == ACTION_SURVIVE)
            {
               OverworldHUD.instance.lootDialog.halfXPMaxFourLoot();
               Overworld.endQuestStepIntro();
            }
            else if(action == ACTION_DUEL)
            {
               _loc2_ = QuestEngine.getNPCData(-1);
               if(_loc2_ != null && _loc2_.nid != "" && Math.abs(StatsManager.getLevel() - _loc2_.lvl) > 2)
               {
                  OverworldHUD.instance.lootDialog.clearLoot();
               }
               if(NetworkManager.instance.isDuellingP2P())
               {
                  if(!NetworkManager.instance.isRecording())
                  {
                     Overworld.endQuestStepIntro();
                  }
                  if(BattleUI.instance.getIsDraw())
                  {
                     QueryManager.instance.duelEnd(StatsManager.charname,"draw");
                     StatsManager.setPlayerStats(StatsManager.STAT_DRAW,StatsManager.getPlayerStats(StatsManager.STAT_DRAW) + 1);
                     NetworkManager.instance.stopRecording(2);
                  }
                  else if(param1)
                  {
                     QueryManager.instance.duelEnd(StatsManager.charname,QuestEngine.getNPCName(-1));
                     StatsManager.setPlayerStats(StatsManager.STAT_WINS,StatsManager.getPlayerStats(StatsManager.STAT_WINS) + 1);
                     OverworldHUD.instance.friendpanel.refresh();
                     NetworkManager.instance.stopRecording(0);
                     StatsManager.reportAchievementStat(60000,1);
                  }
               }
               else if(action != ACTION_PLAYBACK && action != ACTION_CUTSCENE)
               {
                  Overworld.endQuestStepIntro();
               }
            }
            else if(action != ACTION_PLAYBACK && action != ACTION_CUTSCENE)
            {
               StatsManager.reportAchievementStat(60017,NPCManager.getTotalKilled());
               StatsManager.reportAchievementStat(60016,NPCManager.getTotalBeheading());
               Overworld.endQuestStepIntro();
            }
         }
         else
         {
            SoundManager.instance.playMusic(MusicManager.MUSIC_LOSE);
            gameMode = MODE_BATTLEENDLOSE;
            OverworldHUD.getInstance().lootDialog.clearLoot();
            if(isDuelMode())
            {
               OverworldHUD.instance.questDialogueUI.show(-1,DuelModeUI.instance.getTaunt());
               OverworldHUD.instance.questDialogueUI.disableClick();
               NetworkManager.instance.stopRecording(1);
            }
         }
      }
      
      public static function stopBattleMode() : *
      {
         var _loc6_:XMLNpc = null;
         var _loc7_:XMLNpc = null;
         var _loc8_:int = 0;
         var _loc9_:TerritoryData = null;
         var _loc1_:Boolean = false;
         var _loc2_:* = gameMode == MODE_BATTLEENDWIN;
         if(action == ACTION_PLAYBACK || action == ACTION_CUTSCENE)
         {
            StatsManager.getPlayer().getMCS().visible = true;
         }
         else if(_loc2_ || action == ACTION_SURVIVALMODE || action == ACTION_WARROOMBATTLE)
         {
            BattleUI.instance.hideWin();
            if(questID == -1 && action == ACTION_DUEL)
            {
               NetworkManager.instance.duelEnd();
            }
            else if(questID != -1)
            {
               _loc1_ = true;
            }
            if(action != ACTION_HARVEST && action != ACTION_DUEL)
            {
               StatsManager.saveHealthAfterBattle();
            }
            else if(action == ACTION_DUEL)
            {
               if((_loc6_ = QuestEngine.getNPCData(-1)) != null && (_loc6_.nid != "" || _loc6_.name != DuelModeUI.instance.selectedOpponentName))
               {
                  StatsManager.saveHealthAfterBattle();
               }
            }
         }
         else
         {
            if(questID == -1 && action == ACTION_DUEL)
            {
               NetworkManager.instance.duelEnd();
            }
            else
            {
               returnToAdventureMode = false;
            }
            if(LoseUI.instance.hasRespawn())
            {
               StatsManager.fullHealth();
            }
            else if(action == ACTION_DUEL)
            {
               if((_loc7_ = QuestEngine.getNPCData(-1)) != null && (_loc7_.nid != "" || _loc7_.name != DuelModeUI.instance.selectedOpponentName))
               {
                  StatsManager.partialHealth();
               }
            }
            else
            {
               StatsManager.partialHealth();
            }
         }
         StageManager.clearFilter();
         var _loc3_:int = action;
         var _loc5_:int;
         var _loc4_:int;
         if((_loc5_ = (_loc4_ = NPCManager.getTotalKilled()) / 100) <= 0)
         {
            _loc5_ = 1;
         }
         StatsManager.updateWeaponUse(_loc5_);
         QueryManager.instance.saveModifiedCharData();
         action = ACTION_ADVENTURE;
         StatsManager.initPlayer();
         if(returnToAdventureMode || LoseUI.instance.hasRespawn())
         {
            StageManager.returnToRoom();
         }
         else
         {
            _loc8_ = NodeGenerator.instance.getTerritoryId(StageManager.getCurrentNode());
            if((_loc9_ = NodeGenerator.instance.getTerritoryData(_loc8_ >> 12 & 4095,_loc8_ & 4095,false)).isTown(StageManager.getCurrentNode()) && _loc9_.territoryAtWar() && StageManager.getCurrentRoom() > 0 && StatsManager.getStat(30021) != 0)
            {
               StageManager.gotoRoom(0,150,StatsManager.getStat(30021));
               StatsManager.setStat(30021,0);
            }
            else
            {
               StageManager.gotoRoom(StatsManager.getPlayerStats(StatsManager.STAT_LOCATION_ROOM),150,StatsManager.getLocation());
            }
         }
         ParticleSystemManager.getInstance().init();
         returnToAdventureMode = false;
         startBattleMode();
         InputManager.setAdventureMode();
         if(_loc3_ == ACTION_WARROOMBATTLE)
         {
            OverworldHUD.instance.warUI.returnFromBattle(_loc4_);
         }
         else
         {
            StatsManager.parseGiftNotificationsString();
         }
         if(StatsManager.equipment[StatsManager.EQ_WEAPON] != null && StatsManager.equipment[StatsManager.EQ_WEAPON].isBroken())
         {
            OverworldHUD.instance.showDialogRepairWeapon();
            StatsManager.reportAchievementStat(60004,1,true);
         }
      }
      
      public static function endCutscene(param1:int, param2:int) : *
      {
         action = ACTION_ADVENTURE;
         StatsManager.initPlayer();
         StageManager.returnToRoom();
         ParticleSystemManager.getInstance().init();
         returnToAdventureMode = false;
         startBattleMode();
         InputManager.setAdventureMode();
         if(param1 != -1)
         {
            Overworld.startQuestStepIntro(param1,param2);
         }
      }
      
      public static function test() : *
      {
      }
      
      public static function checkPlayBackMode() : *
      {
         var _loc1_:Object = getLoaderInfo(StatsManager.mainTimeLine).parameters;
         if(_loc1_.playbackmode == null)
         {
            return;
         }
         playbackClient = true;
         if(OverworldHUD.instance)
         {
            OverworldHUD.instance.friendpanel.hideAll();
         }
         QueryManager.instance.offlineMode = true;
         if(NetworkManager.instance != null)
         {
            NetworkManager.instance.connected = false;
         }
         StatsManager.showFriends = false;
         StatsManager.charname = "guest";
         StatsManager.initNewPlayer();
         new Overworld(stageMC);
         new StageManager();
         new NetworkManager();
         StatsManager.createPlayer();
         StageManager.setPlayer(StatsManager.getPlayer());
         if(StatsManager.usePlayerIO)
         {
            showLoadingScreen();
            QueryManagerPIO.instance.playbackClientLogin(_loc1_.playbackid,_loc1_.playbackname);
            trace("checkPlayBackMode:",_loc1_.playbackid,_loc1_.playbackname);
         }
         else if(_loc1_.playbackid != "")
         {
            QueryManager.instance.getReplay(_loc1_.playbackid);
         }
         else if(_loc1_.playbackname != "")
         {
            QueryManager.instance.getReplayByName(_loc1_.playbackname);
         }
         else
         {
            QueryManager.instance.getReplay("0");
         }
         if(_loc1_.showslash != null)
         {
            playbackClientShowSlash = true;
         }
      }
      
      public static function isPlayBackClient() : Boolean
      {
         return playbackClient;
      }
      
      public static function isPlaybackClientShowSlash() : Boolean
      {
         return playbackClientShowSlash;
      }
      
      internal static function getLoaderInfo(param1:DisplayObject) : LoaderInfo
      {
         var _loc2_:DisplayObject = getRootDisplayObject(param1);
         if(_loc2_ != null)
         {
            return _loc2_.loaderInfo;
         }
         return null;
      }
      
      internal static function getRootDisplayObject(param1:DisplayObject) : DisplayObject
      {
         if(topParent == null)
         {
            if(param1.parent != null)
            {
               return getRootDisplayObject(param1.parent);
            }
            topParent = param1;
            return topParent;
         }
         return topParent;
      }
      
      internal static function checkSiteLock() : *
      {
         var _loc1_:CorruptedMessage = null;
         if(StatsManager.isKongregate || StatsManager.isMobile)
         {
            return;
         }
         if(getLoaderInfo(StatsManager.mainTimeLine).url.indexOf("playerio") == -1 && getLoaderInfo(StatsManager.mainTimeLine).url.indexOf("strawhatsamuraiduels.com") == -1 && getLoaderInfo(StatsManager.mainTimeLine).url.indexOf("explosivebarrel.net") == -1)
         {
            _loc1_ = new CorruptedMessage();
            _loc1_.prompt.text = "Error: Site-locked";
            _loc1_.strtext.text = "";
            stageMC.addChild(_loc1_);
            InputManager.disableInput();
            GameEngine.stopEngine();
         }
      }
      
      public static function checkFacebookLogin() : *
      {
         var _loc1_:Object = getLoaderInfo(StatsManager.mainTimeLine).parameters;
         StatsManager.useFlashVarsLogin = true;
      }
      
      public static function checkKongregate() : *
      {
         if(getLoaderInfo(StatsManager.mainTimeLine).parameters.kongregate_api_path != null)
         {
            StatsManager.isKongregate = true;
         }
      }
      
      public static function getPublisherId() : String
      {
         if(StatsManager.isAndroid)
         {
            return "999998";
         }
         if(StatsManager.isIOS)
         {
            return "999999";
         }
         var _loc1_:Object = getLoaderInfo(StatsManager.mainTimeLine).parameters;
         if(_loc1_.pubid == null)
         {
            return "";
         }
         return _loc1_.pubid;
      }

   }
}
