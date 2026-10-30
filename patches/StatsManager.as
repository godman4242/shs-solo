package
{
   public class StatsManager
   {
      
      public static var clientVersion:Number = 0.682;
      
      public static var buildType:int = 0;
      
      public static var questver:Number = 1;
      
      public static var npcver:Number = 1;
      
      public static var mapver:Number = 1;
      
      public static var itemver:Number = 1;
      
      public static var levelCap:int = 80;
      
      public static var expArray:Array = [0,550,1450,2950,5150,8350,12150,16350,20900,25900,31400,37400,43500,49850,56550,63900,71900,80300,89100,98300,108000,118300,129300,141100,154100,168100,183100,199100,216100,234100,253100,273100,294100,316100,339300,363300,389300,416800,445800,475800,507300,540300,574300,610300,647800,685800,725800,767800,812300,859300,908300,959300,1012300,1067300,1124300,1183300,1244800,1307800,1372800,1439800,1508800,1578800,1651800,1728800,1808800,1892800,1980800,2071800,2166800,2276800,2404800,2544800,2699800,2862800,3032800,3212800,3400800,3595800,3795800,4025800,4285800,4585800,4935800,5335800,5815800,6365800,6965800,7645800,8395800,9295800,10295800,11495800,12995800,14795800,16895800,19295800,22095800,25395800,29395800];
      
      public static var stageWidth:int = 800;
      
      public static var stageHeight:int = 480;
      
      public static var isFullScreen:Boolean = false;
      
      public static var stageScale:Number = 1;
      
      public static var stageOffsetX:Number = 0;
      
      public static var stageOffsetY:Number = 0;
      
      public static var stageFitWidth:Boolean = false;
      
      public static var stageShowingFriendBar:Boolean = true;
      
      public static var stageBaseWidth:int = 800;
      
      public static var stageBaseHeight:int = 480;
      
      public static var mainTimeLine:*;
      
      internal static var player:MCSPlayer;
      
      internal static var bust:MCSBust;
      
      public static var id:String;
      
      public static var charname:String = "";
      
      public static var stance:int = 1;
      
      internal static var playerStatsCount:int = 44;
      
      private static var playerStats:Vector.<ObfuscatedObject> = new Vector.<ObfuscatedObject>(playerStatsCount);
      
      public static var equipment:Vector.<Item> = new Vector.<Item>(13);
      
      public static var skillStats:Vector.<IntStat> = new Vector.<IntStat>();
      
      public static var inventory:Vector.<Item> = new Vector.<Item>();
      
      public static var questItems:Vector.<Item> = new Vector.<Item>();
      
      public static var intStats:Vector.<ObfusIntStat> = new Vector.<ObfusIntStat>();
      
      public static var booleanStats:Vector.<BooleanStat> = new Vector.<BooleanStat>();
      
      public static var achievementStats:Vector.<ObfusIntStat> = new Vector.<ObfusIntStat>();
      
      public static var activeQuestList:Vector.<ActiveQuest> = new Vector.<ActiveQuest>();
      
      public static var completedQuestList:Vector.<CompletedQuest> = new Vector.<CompletedQuest>();
      
      public static var skillSlots:Vector.<IntStat> = new Vector.<IntStat>(8);
      
      public static var stash:Vector.<Item> = new Vector.<Item>();
      
      public static var victoryTaunt:String;
      
      public static var friendList:String;
      
      internal static var combo:int;
      
      public static var facebookid:String = "";
      
      public static var facebookFriends:String = "";
      
      public static var rank:int;
      
      public static var bounty:int;
      
      public static var giftNotification:String = "";
      
      public static var key:int = 0;
      
      public static var lever:int = 0;
      
      public static var chatShowing:Boolean = false;
      
      public static var bigMapShowing:Boolean = false;
      
      public static var chatMode:int = 0;
      
      internal static var multiplier:int = Math.random() * 5 + 2;
      
      private static var honeyPot:Vector.<int> = new Vector.<int>(playerStatsCount);
      
      private static var honeyPotCheckSum:int;
      
      internal static var nextAPUpdate:int = 0;
      
      internal static var nextDTUpdate:int = 0;
      
      internal static var nextWarTurn:int = 0;
      
      public static var purchasesMade:ObfuscatedObject = new ObfuscatedObject();
      
      internal static var APINTERVAL:int = 60;
      
      internal static var DTINTERVAL:int = 2 * 60;
      
      internal static var WARMOVEINTERVAL:int = 60 * 60;
      
      internal static var MAXQUESTS:int = 7;
      
      internal static var MAXDUELTOKENS:int = 30;
      
      internal static var MAJORCUSTOMCLANTHRESHHOLD:int = 40;
      
      internal static var STAT_HP:int = 0;
      
      internal static var STAT_MAXHP:int = 1;
      
      internal static var STAT_HPREGEN:int = 2;
      
      internal static var STAT_CHI:int = 3;
      
      internal static var STAT_MAXCHI:int = 4;
      
      internal static var STAT_CHIREGEN:int = 5;
      
      internal static var STAT_ATTACK:int = 6;
      
      internal static var STAT_DEFENSE:int = 7;
      
      internal static var STAT_SPEED:int = 8;
      
      internal static var STAT_XP:int = 9;
      
      internal static var STAT_LEVEL:int = 10;
      
      internal static var STAT_GOLD:int = 11;
      
      internal static var STAT_HGOLD:int = 12;
      
      internal static var STAT_AP:int = 13;
      
      internal static var STAT_MAXAP:int = 14;
      
      internal static var STAT_DUELTOKENS:int = 15;
      
      internal static var STAT_MAXDUELTOKENS:int = 16;
      
      internal static var STAT_SKILLPOINTS:int = 17;
      
      internal static var STAT_STATPOINTS:int = 18;
      
      internal static var STAT_LOCATION:int = 19;
      
      internal static var STAT_WINS:int = 20;
      
      internal static var STAT_SIDE:int = 21;
      
      internal static var STAT_WARMOVES:int = 22;
      
      internal static var STAT_WARMOVESMADE:int = 23;
      
      internal static var STAT_WARCOINSDONATED:int = 24;
      
      internal static var STAT_DAN:int = 25;
      
      internal static var STAT_MARKEDNODE:int = 26;
      
      internal static var STAT_DRAW:int = 27;
      
      internal static var STAT_FIREATK:int = 28;
      
      internal static var STAT_WINDATK:int = 29;
      
      internal static var STAT_WATERATK:int = 30;
      
      internal static var STAT_EARTHATK:int = 31;
      
      internal static var STAT_COINSINBANK:int = 36;
      
      internal static var STAT_ISFEMALE:int = 37;
      
      internal static var STAT_BUFFTYPE:int = 38;
      
      internal static var STAT_BUFFEXPIRY:int = 39;
      
      internal static var STAT_BUFF2EXPIRY:int = 40;
      
      internal static var STAT_PAIDSTORAGE:int = 41;
      
      internal static var STAT_CHIKAKOLOVE:int = 42;
      
      internal static var STAT_LOCATION_ROOM:int = 43;
      
      internal static var STAT_FIREDEF:int = 200;
      
      internal static var STAT_WINDDEF:int = 201;
      
      internal static var STAT_WATERDEF:int = 202;
      
      internal static var STAT_EARTHDEF:int = 203;
      
      internal static var STAT_CRITICALDMG:int = 204;
      
      internal static var STAT_PIERCINGDMG:int = 205;
      
      internal static var EQ_ARMOR:int = 0;
      
      internal static var EQ_GLOVES:int = 1;
      
      internal static var EQ_HAIR:int = 2;
      
      internal static var EQ_HAT:int = 3;
      
      internal static var EQ_HEAD:int = 4;
      
      internal static var EQ_MASK:int = 5;
      
      internal static var EQ_NECK:int = 6;
      
      internal static var EQ_PANTS:int = 7;
      
      internal static var EQ_SHOES:int = 8;
      
      internal static var EQ_WEAPON:int = 9;
      
      internal static var EQ_SCABBARD:int = 10;
      
      internal static var EQ_ACCESSORY1:int = 11;
      
      internal static var EQ_ACCESSORY2:int = 12;
      
      internal static var BUFF_XP:int = 0;
      
      internal static var BUFF_ATTACK:int = 1;
      
      internal static var BUFF_DEFENSE:int = 2;
      
      internal static var BUFF_SPEED:int = 3;
      
      internal static var BUFF_AP:int = 4;
      
      internal static var BUFF_DUELTOKENS:int = 5;
      
      internal static var BUFF_COINS:int = 6;
      
      internal static var BUFF_RARELOOT:int = 7;
      
      internal static var BUFF_MUTE:int = 8;
      
      internal static var BUFF_FULLMUTE:int = 9;
      
      internal static var BUFF_HELL:int = 10;
      
      internal static var BUFF_INJURED:int = 11;
      
      internal static var BUFF_MODERATOR:int = 12;
      
      public static var censored:Boolean = false;
      
      public static var hasChatNotification:Boolean = true;
      
      public static var recordDuels:Boolean = false;
      
      public static var autoSlash:Boolean = false;
      
      public static var autoAssignStats:Boolean = false;
      
      public static var hideBloodOption:Boolean = false;
      
      public static var doFullScreen:Boolean = false;
      
      public static var skipIntro:Boolean = true;
      
      public static var showNinjaServant:Boolean = true;
      
      internal static var unlimitedAP:Boolean = false;
      
      internal static var superDamage:Boolean = true;
      
      internal static var consoleEnabled:Boolean = true;
      
      internal static var canChangeSide:Boolean = true;
      
      internal static var warCheat:Boolean = false;
      
      internal static var saveToCookie:Boolean = true;
      
      internal static var singleCharacter:Boolean = true;
      
      internal static var impersonateUser:Boolean = false;
      
      internal static var isInvincible:Boolean = true;
      
      internal static var noAggro:Boolean = true;
      
      internal static var canEquipAllSkills:Boolean = false;
      
      internal static var canMultiClient:Boolean = true;
      
      internal static var hideNewFeatures:Boolean = false;
      
      public static var useLocalXML:Boolean = true;
      
      public static var useExternalResource:Boolean = true;
      
      public static var useExternalLang:Boolean = false;
      
      public static var useExternalXML:Boolean = true;
      
      public static var useExternalLogin:Boolean = false;
      
      public static var useFlashVarsLogin:Boolean = false;
      
      public static var language:String = LangManager.ENGLISH;
      
      public static var useCirrus:Boolean = false;
      
      public static var useFMS:Boolean = false;
      
      public static var showFriends:Boolean = true;
      
      public static var skipUpdateGlobalVar:Boolean = true;
      
      public static var offlineModeOnly:Boolean = false;
      
      public static var usePlayerIO:Boolean = true;
      
      public static var usePlayerIODevServer:Boolean = true;
      
      public static var usePlayerIOForDuels:Boolean = true;
      
      public static var server:* = "http://playerio.localhost:8765/solo/server/";
      
      public static var cookieName:String = "shsd";
      
      public static var useTestData:Boolean = false;
      
      public static var encryptedResource:Boolean = true;
      
      public static var serverSideDuel:Boolean = false;
      
      public static var showCutsceneTiming:Boolean = true;
      
      public static var hackReported:Boolean = false;
      
      public static var bonusPrizeCollected:Boolean = false;
      
      public static var didRebirth:Boolean = false;
      
      public static var isKongregate:Boolean = false;
      
      public static var isAndroid:Boolean = false;
      
      public static var isIOS:Boolean = false;
      
      public static var isMobile:Boolean = false;
      
      internal static var serverTimeVariable:int;
      
      internal static var timeLeft:int = 0;
      
      internal static var pingCounterMax:int = 6480;
      
      internal static var pingCounter:int;
      
      internal static var secCounter:int = 0;
      
      internal static var customClanName:String = "Player Clan";
      
      internal static var customClanColor:int = 16737792;
      
      internal static var customClanLogoId:int = 1;
      
      internal static var customClanLogoColor:int = 16777215;
      
      internal static var customClanAcronym:String = "PLC";
      
      internal static var customClanOwned:int = 0;
      
      internal static var customClanFounder:String = "?";
      
      internal static var PLAYERLEVEL:int = 0;
      
      internal static var PLAYERSTAT:int = 1;
      
      internal static var EQUIPMENT:int = 2;
      
      internal static var SKILL:int = 3;
      
      internal static var ITEM:int = 4;
      
      internal static var QUESTITEM:int = 5;
      
      internal static var INTSTAT:int = 6;
      
      internal static var BOOLEANSTAT:int = 7;
      
      internal static var ACTIVEQUEST:int = 8;
      
      internal static var COMPLETEDQUEST:int = 9;
      
      internal static var LOCATION:int = 10;
      
      internal static var TAUNT:int = 11;
      
      internal static var FRIENDLIST:int = 12;
      
      internal static var GLOBALVAR:int = 13;
      
      internal static var SKILLSLOT:int = 14;
      
      internal static var PLAYERSIDE:int = 15;
      
      internal static var PLAYERDAN:int = 16;
      
      internal static var STASH:int = 17;
      
      internal static var OPTIONS:int = 18;
      
      internal static var ACHIEVEMENTSTAT:int = 19;
      
      internal static var activeQuestStr:String;
      
      {
         isMobile = isAndroid;
         superDamage = false;
         consoleEnabled = false;
         canChangeSide = false;
         warCheat = false;
         saveToCookie = true;
         singleCharacter = true;
         impersonateUser = false;
         isInvincible = false;
         noAggro = false;
         canEquipAllSkills = false;
         canMultiClient = false;
         hideNewFeatures = true;
         useLocalXML = false;
         useExternalResource = true;
         useExternalLang = true;
         useExternalXML = true;
         hideBloodOption = false;
         useExternalLogin = false;
         useFlashVarsLogin = false;
         skipUpdateGlobalVar = false;
         language = LangManager.ENGLISH;
         offlineModeOnly = false;
         server = "http://playerio.localhost:8765/solo/server/";
         skipIntro = false;
         useFMS = false;
         usePlayerIO = true;
         usePlayerIODevServer = false;
         usePlayerIOForDuels = true;
         useTestData = false;
         encryptedResource = true;
         serverSideDuel = false;
         showCutsceneTiming = false;
         isAndroid = false;
         isIOS = false;
      }
      
      public function StatsManager()
      {
         super();
      }
      
      private static function populatePlayerStats(param1:Vector.<ObfuscatedObject>) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_] = new ObfuscatedObject();
            _loc2_++;
         }
      }
      
      public static function getCharnameHash() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < charname.length)
         {
            _loc1_ += charname.charCodeAt(_loc2_) * 2;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function toggleBlood() : *
      {
         censored = !censored;
         QueryManager.instance.saveOptions();
      }
      
      public static function toggleNinjaServant() : *
      {
         showNinjaServant = !showNinjaServant;
         QueryManager.instance.saveOptions();
      }
      
      public static function toggleChat() : *
      {
         hasChatNotification = !hasChatNotification;
         QueryManager.instance.saveOptions();
      }
      
      public static function toggleRecordDuel() : *
      {
         recordDuels = !recordDuels;
         QueryManager.instance.saveOptions();
      }
      
      public static function toggleAutoSlash() : *
      {
         autoSlash = !autoSlash;
         QueryManager.instance.saveOptions();
      }
      
      public static function toggleAutoAssignStats() : *
      {
         autoAssignStats = !autoAssignStats;
         QueryManager.instance.saveOptions();
      }
      
      public static function toggleDoFullScreen() : *
      {
         doFullScreen = !doFullScreen;
         QueryManager.instance.saveOptions();
      }
      
      public static function isFacebook() : Boolean
      {
         return facebookid != "";
      }
      
      internal static function reset() : *
      {
         playerStats.fixed = false;
         playerStats = new Vector.<ObfuscatedObject>(playerStatsCount);
         populatePlayerStats(playerStats);
         playerStats.fixed = true;
         equipment.fixed = false;
         equipment.length = 0;
         equipment.fixed = true;
         skillStats.fixed = false;
         skillStats.length = 0;
         skillStats.fixed = true;
         skillSlots.fixed = false;
         skillSlots.length = 0;
         skillSlots.fixed = true;
         inventory.fixed = false;
         inventory.length = 0;
         inventory.fixed = true;
         questItems.fixed = false;
         questItems.length = 0;
         questItems.fixed = true;
         stash.fixed = false;
         stash.length = 0;
         stash.fixed = true;
         intStats.fixed = false;
         intStats.length = 0;
         intStats.fixed = true;
         achievementStats.fixed = false;
         achievementStats.length = 0;
         achievementStats.fixed = true;
         booleanStats.fixed = false;
         booleanStats.length = 0;
         booleanStats.fixed = true;
         activeQuestList.fixed = false;
         activeQuestList.length = 0;
         activeQuestList.fixed = true;
         completedQuestList.fixed = false;
         completedQuestList.length = 0;
         completedQuestList.fixed = true;
         combo = 0;
         nextAPUpdate = -1;
         nextDTUpdate = -1;
         nextWarTurn = -1;
         charname = "";
         customClanName = "Player Clan";
         customClanColor = 16737792;
         customClanLogoId = 1;
         customClanLogoColor = 16777215;
         customClanAcronym = "PLC";
         customClanOwned = 0;
         customClanFounder = "?";
      }
      
      public static function getPlayerStats(param1:int) : *
      {
         return playerStats[param1].getIntValue();
      }
      
      public static function setPlayerStats(param1:int, param2:int) : *
      {
         if(param1 >= playerStatsCount)
         {
            return;
         }
         checkHoneyPot();
         playerStats[param1].setIntValue(param2);
         honeyPot[param1] = param2;
         honeyPotCheckSum = calcHoneyPotCheckSum();
      }
      
      internal static function checkHoneyPot() : *
      {
         if(honeyPotCheckSum != calcHoneyPotCheckSum())
         {
            QueryManager.instance.reportHack("pot");
         }
      }
      
      internal static function calcHoneyPotCheckSum() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < honeyPot.length)
         {
            _loc1_ += honeyPot[_loc2_];
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function initNewPlayer(param1:String = "", param2:int = 0, param3:int = 1, param4:int = 4017, param5:int = 11017, param6:int = 0, param7:int = 12017, param8:Boolean = false) : *
      {
         reset();
         charname = param1;
         playerStats.fixed = false;
         setPlayerStats(STAT_HP,10);
         setPlayerStats(STAT_MAXHP,10);
         setPlayerStats(STAT_HPREGEN,1);
         setPlayerStats(STAT_CHI,10);
         setPlayerStats(STAT_MAXCHI,10);
         setPlayerStats(STAT_CHIREGEN,1);
         setPlayerStats(STAT_ATTACK,1);
         setPlayerStats(STAT_DEFENSE,1);
         setPlayerStats(STAT_SPEED,1);
         setPlayerStats(STAT_XP,0);
         setPlayerStats(STAT_LEVEL,1);
         setPlayerStats(STAT_GOLD,100);
         setPlayerStats(STAT_HGOLD,0);
         setPlayerStats(STAT_AP,30);
         setPlayerStats(STAT_MAXAP,30);
         setPlayerStats(STAT_DUELTOKENS,20);
         setPlayerStats(STAT_MAXDUELTOKENS,20);
         setPlayerStats(STAT_SKILLPOINTS,0);
         setPlayerStats(STAT_STATPOINTS,0);
         setPlayerStats(STAT_LOCATION,8382465);
         setPlayerStats(STAT_WINS,0);
         if(param8)
         {
            setPlayerStats(STAT_ISFEMALE,1);
         }
         else
         {
            setPlayerStats(STAT_ISFEMALE,0);
         }
         playerStats.fixed = true;
         equipment.fixed = false;
         equipment[EQ_ARMOR] = new Item(param4,1);
         equipment[EQ_GLOVES] = new Item(0,1);
         equipment[EQ_HAIR] = new Item(param2,1);
         equipment[EQ_HAT] = new Item(param6,1);
         equipment[EQ_HEAD] = new Item(param3,1);
         equipment[EQ_MASK] = new Item(0,1);
         equipment[EQ_NECK] = new Item(0,1);
         equipment[EQ_PANTS] = new Item(param5,1);
         equipment[EQ_SHOES] = new Item(param7,1);
         equipment[EQ_WEAPON] = new Item(0,1);
         equipment[EQ_SCABBARD] = new Item(13100,1);
         equipment[EQ_ACCESSORY1] = new Item(0,1);
         equipment[EQ_ACCESSORY2] = new Item(0,1);
         equipment.fixed = true;
         skillStats.fixed = false;
         skillStats.push(new IntStat(1000,1));
         skillStats.push(new IntStat(1001,1));
         skillStats.push(new IntStat(1002,1));
         skillStats.push(new IntStat(1003,1));
         skillStats.push(new IntStat(1042,1));
         skillStats.push(new IntStat(1049,1));
         skillStats.push(new IntStat(1050,1));
         skillStats.fixed = true;
         skillSlots.fixed = false;
         skillSlots[0] = new IntStat(1003,1);
         skillSlots.fixed = true;
         intStats.fixed = false;
         intStats.push(new ObfusIntStat(30004,4));
         intStats.fixed = true;
      }
      
      public static function update() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         serverTimeVariable = QueryManager.instance.getServerTime();
         --pingCounter;
         if(pingCounter <= 0)
         {
            pingCounter = pingCounterMax;
            QueryManager.instance.saveModifiedCharData();
            trace("auto ping");
         }
         --secCounter;
         if(secCounter <= 0)
         {
            secCounter = 24;
            if(nextAPUpdate != -1)
            {
               regenAP(serverTimeVariable);
            }
            updateAPCounter(serverTimeVariable);
            if(nextDTUpdate != -1)
            {
               regenDT(serverTimeVariable);
            }
            updateDTCounter(serverTimeVariable);
            OverworldHUD.instance.warUI.updateWarMoveCounter(serverTimeVariable - nextWarTurn,serverTimeVariable);
            OverworldHUD.instance.payUI.update(serverTimeVariable);
            OverworldHUD.instance.interactUI.update(serverTimeVariable);
            _loc1_ = getPlayerStats(STAT_BUFF2EXPIRY);
            if(_loc1_ != 0)
            {
               if(_loc1_ < serverTimeVariable)
               {
                  setPlayerStats(STAT_BUFF2EXPIRY,0);
               }
               OverworldHUD.instance.updateBuff(BUFF_INJURED,_loc1_ - serverTimeVariable);
            }
            else
            {
               _loc2_ = getPlayerStats(STAT_BUFFEXPIRY);
               if(_loc2_ != 0)
               {
                  if(_loc2_ < serverTimeVariable)
                  {
                     setPlayerStats(STAT_BUFFEXPIRY,0);
                     if(getPlayerStats(STAT_BUFFTYPE) == BUFF_HELL && StageManager.getRoomPrivate() == 8)
                     {
                        StageManager.gotoRoom(257,290,8382465);
                     }
                  }
                  OverworldHUD.instance.updateBuff(getPlayerStats(STAT_BUFFTYPE),_loc2_ - serverTimeVariable);
               }
            }
         }
         DuelModeUI.instance.update();
         OverworldHUD.instance.warUI.update(serverTimeVariable);
         OverworldHUD.instance.worldMapUI.update();
      }
      
      public static function setNextWarTurn() : *
      {
         if(nextWarTurn - QueryManager.instance.getServerTime() < 0)
         {
            nextWarTurn = QueryManager.instance.getServerTime() + WARMOVEINTERVAL;
         }
      }
      
      public static function getWarRank() : int
      {
         var _loc1_:int = getStat(STAT_WARMOVESMADE) + int(getStat(STAT_WARCOINSDONATED) / 1000);
         if(_loc1_ < 12 * 3)
         {
            return 0;
         }
         if(_loc1_ < 12 * 3 + 12 * 4)
         {
            return 1;
         }
         if(_loc1_ < 12 * 3 + 12 * 4 + 24 * 4)
         {
            return 2;
         }
         if(_loc1_ < 12 * 3 + 12 * 4 + 24 * 4 + 36 * 4)
         {
            return 3;
         }
         if(_loc1_ < 12 * 3 + 12 * 4 + 24 * 4 + 36 * 4 + 48 * 4)
         {
            return 4;
         }
         if(_loc1_ < 12 * 3 + 12 * 4 + 24 * 4 + 36 * 4 + 48 * 4 + 60 * 5)
         {
            return 5;
         }
         if(_loc1_ < 12 * 3 + 12 * 4 + 24 * 4 + 36 * 4 + 48 * 4 + 60 * 5 + 72 * 5)
         {
            return 6;
         }
         if(_loc1_ < 12 * 3 + 12 * 4 + 24 * 4 + 36 * 4 + 48 * 4 + 60 * 5 + 72 * 5 + 84 * 5)
         {
            return 7;
         }
         if(_loc1_ < 12 * 3 + 12 * 4 + 24 * 4 + 36 * 4 + 48 * 4 + 60 * 5 + 72 * 5 + 84 * 5 + 96 * 5)
         {
            return 8;
         }
         if(_loc1_ < 5000)
         {
            return 9;
         }
         return 10;
      }
      
      public static function getWarMovesToNextRank() : int
      {
         var _loc1_:int = getWarRank();
         if(_loc1_ == 0)
         {
            return 36;
         }
         if(_loc1_ == 1)
         {
            return 84;
         }
         if(_loc1_ == 2)
         {
            return 180;
         }
         if(_loc1_ == 3)
         {
            return 324;
         }
         if(_loc1_ == 4)
         {
            return 516;
         }
         if(_loc1_ == 5)
         {
            return 816;
         }
         if(_loc1_ == 6)
         {
            return 1176;
         }
         if(_loc1_ == 7)
         {
            return 1596;
         }
         if(_loc1_ == 8)
         {
            return 2076;
         }
         if(_loc1_ == 9)
         {
            return 5000;
         }
         return 5000;
      }
      
      public static function getWarRankName() : String
      {
         var _loc1_:int = getWarRank();
         if(_loc1_ == 0)
         {
            return LangManager.getString(330);
         }
         if(_loc1_ == 1)
         {
            return LangManager.getString(331);
         }
         if(_loc1_ == 2)
         {
            return LangManager.getString(332);
         }
         if(_loc1_ == 3)
         {
            return LangManager.getString(333);
         }
         if(_loc1_ == 4)
         {
            return LangManager.getString(334);
         }
         if(_loc1_ == 5)
         {
            return LangManager.getString(335);
         }
         if(_loc1_ == 6)
         {
            return LangManager.getString(336);
         }
         if(_loc1_ == 7)
         {
            return LangManager.getString(337);
         }
         if(_loc1_ == 8)
         {
            return LangManager.getString(338);
         }
         if(_loc1_ == 9)
         {
            return LangManager.getString(339);
         }
         if(_loc1_ == 10)
         {
            return LangManager.getString(403);
         }
         return "";
      }
      
      public static function getMaxWarMoves() : int
      {
         var _loc1_:int = getWarRank();
         if(_loc1_ == 0)
         {
            return 3;
         }
         if(_loc1_ == 1)
         {
            return 4;
         }
         if(_loc1_ == 2)
         {
            return 4;
         }
         if(_loc1_ == 3)
         {
            return 4;
         }
         if(_loc1_ == 4)
         {
            return 4;
         }
         if(_loc1_ == 5)
         {
            return 5;
         }
         if(_loc1_ == 6)
         {
            return 5;
         }
         if(_loc1_ == 7)
         {
            return 5;
         }
         if(_loc1_ == 8)
         {
            return 5;
         }
         if(_loc1_ == 9)
         {
            return 5;
         }
         if(_loc1_ == 10)
         {
            return 6;
         }
         return 3;
      }
      
      public static function resetPingCounter() : *
      {
         pingCounter = pingCounterMax;
      }
      
      public static function refreshStats() : *
      {
         if(getPlayerStats(STAT_HP) > getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP))
         {
            setStat(STAT_HP,getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP));
         }
         if(getPlayerStats(STAT_CHI) > getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI))
         {
            setStat(STAT_CHI,getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI));
         }
         if(getPlayerStats(STAT_AP) >= getPlayerStats(STAT_MAXAP) + findBonusStat(STAT_MAXAP))
         {
            serverTimeVariable = QueryManager.instance.getServerTime();
            nextAPUpdate = -1;
            setStat(STAT_AP,getPlayerStats(STAT_MAXAP) + findBonusStat(STAT_MAXAP));
            timeLeft = 0;
            updateAPCounter(serverTimeVariable);
         }
         if(getPlayerStats(STAT_DUELTOKENS) >= MAXDUELTOKENS)
         {
            serverTimeVariable = QueryManager.instance.getServerTime();
            nextDTUpdate = -1;
            setStat(STAT_DUELTOKENS,MAXDUELTOKENS);
            timeLeft = 0;
            updateDTCounter(serverTimeVariable);
         }
         if(getPlayerStats(STAT_HP) <= 0)
         {
            setPlayerStats(STAT_HP,1);
         }
         if(getPlayerStats(STAT_CHI) < 0)
         {
            setPlayerStats(STAT_CHI,0);
         }
         if(getPlayerStats(STAT_AP) < 0)
         {
            setPlayerStats(STAT_AP,0);
         }
      }
      
      internal static function updateAPCounter(param1:int) : *
      {
         var _loc2_:String = null;
         if(getPlayerStats(STAT_MAXAP) == getPlayerStats(STAT_AP))
         {
            InventoryUI.instance.updateAPRegen("");
            OverworldHUD.instance.updateAPtimer("");
         }
         else
         {
            _loc2_ = String(nextAPUpdate - param1);
            InventoryUI.instance.updateAPRegen(_loc2_);
            OverworldHUD.instance.updateAPtimer(_loc2_);
         }
      }
      
      internal static function updateDTCounter(param1:int) : *
      {
         var _loc2_:String = null;
         if(getPlayerStats(STAT_DUELTOKENS) == MAXDUELTOKENS)
         {
            OverworldHUD.instance.updateTokenTimer("");
         }
         else
         {
            _loc2_ = String(nextDTUpdate - param1);
            OverworldHUD.instance.updateTokenTimer(_loc2_);
         }
      }
      
      public static function regenAP(param1:int) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 >= nextAPUpdate)
         {
            _loc2_ = param1 - nextAPUpdate;
            _loc3_ = Math.floor(_loc2_ / APINTERVAL) + 1;
            if(StatsManager.hasBuff(StatsManager.BUFF_AP))
            {
               _loc3_ *= 2;
            }
            _loc4_ = changeAP(_loc3_);
            _loc5_ = getPlayerStats(STAT_MAXAP);
            if(_loc4_ >= _loc5_)
            {
               nextAPUpdate = -1;
               setStat(STAT_AP,_loc5_);
               timeLeft = 0;
            }
            else
            {
               setNextAPUpdate(param1,APINTERVAL - _loc2_ % APINTERVAL);
            }
         }
         else
         {
            timeLeft = nextAPUpdate - param1;
         }
      }
      
      public static function regenDT(param1:int) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 >= nextDTUpdate)
         {
            _loc2_ = param1 - nextDTUpdate;
            _loc3_ = Math.floor(_loc2_ / DTINTERVAL) + 1;
            if(StatsManager.hasBuff(StatsManager.BUFF_DUELTOKENS))
            {
               _loc3_ *= 2;
            }
            _loc4_ = changeDT(_loc3_);
            _loc5_ = MAXDUELTOKENS;
            if(_loc4_ >= _loc5_)
            {
               nextDTUpdate = -1;
               setStat(STAT_DUELTOKENS,_loc5_);
               timeLeft = 0;
            }
            else
            {
               setNextDTUpdate(param1,DTINTERVAL - _loc2_ % DTINTERVAL);
            }
         }
         else
         {
            timeLeft = nextDTUpdate - param1;
         }
      }
      
      public static function initQuestLog() : void
      {
         activeQuestList = new Vector.<ActiveQuest>();
         completedQuestList = new Vector.<CompletedQuest>();
      }
      
      public static function getActiveQuestStep(param1:int) : int
      {
         var _loc2_:int = int(activeQuestList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(activeQuestList[_loc3_].questID == param1)
            {
               return activeQuestList[_loc3_].step;
            }
            _loc3_++;
         }
         return -1;
      }
      
      internal static function checkCompletedQuest(param1:int) : Boolean
      {
         var _loc2_:CompletedQuest = null;
         var _loc3_:int = int(completedQuestList.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = completedQuestList[_loc3_];
            if(_loc2_.questID == param1)
            {
               if(_loc2_.completedTime == 0 || _loc2_.completedTime < serverTimeVariable - 24 * 60 * 60)
               {
                  return true;
               }
               return false;
            }
            _loc3_--;
         }
         return false;
      }
      
      internal static function checkNotCompletedQuest(param1:int) : Boolean
      {
         var _loc2_:CompletedQuest = null;
         var _loc3_:int = int(completedQuestList.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = completedQuestList[_loc3_];
            if(_loc2_.questID == param1)
            {
               return false;
            }
            _loc3_--;
         }
         return true;
      }
      
      public static function checkCompletedProcGenQuest(param1:int, param2:int, param3:int, param4:int, param5:Boolean) : Boolean
      {
         var _loc6_:CompletedQuest = null;
         var _loc7_:int = int(completedQuestList.length - 1);
         while(_loc7_ >= 0)
         {
            if((_loc6_ = completedQuestList[_loc7_]).questID == -1 && _loc6_.nodeid == param1 && _loc6_.roomid == param2 && _loc6_.index == param3 && _loc6_.completedTime == param4 && _loc6_.forTrade == param5)
            {
               return true;
            }
            _loc7_--;
         }
         return false;
      }
      
      public static function checkActiveQuest(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc5_:ActiveQuest = null;
         var _loc2_:Array = param1.split(",");
         var _loc4_:int = -1;
         if(_loc2_.length == 2)
         {
            _loc3_ = int(_loc2_[0]);
            _loc4_ = int(_loc2_[1]);
         }
         else
         {
            _loc3_ = int(param1);
         }
         var _loc6_:int = int(activeQuestList.length - 1);
         while(_loc6_ >= 0)
         {
            if((_loc5_ = activeQuestList[_loc6_]).questID == _loc3_)
            {
               if(_loc4_ == -1)
               {
                  return true;
               }
               return _loc5_.step == _loc4_ - 1;
            }
            _loc6_--;
         }
         return false;
      }
      
      public static function addActiveQuests(param1:int, param2:Boolean = false) : Boolean
      {
         trace("addActiveQuest" + param1);
         var _loc3_:int = int(activeQuestList.length - 1);
         while(_loc3_ >= 0)
         {
            if(activeQuestList[_loc3_].questID == param1)
            {
               return true;
            }
            _loc3_--;
         }
         if(activeQuestList.length < MAXQUESTS || param2)
         {
            activeQuestList.fixed = false;
            activeQuestList.push(new ActiveQuest(param1));
            activeQuestList.fixed = true;
            QueryManager.instance.reportDataModified(ACTIVEQUEST);
            StatsManager.setStat(StatsManager.STAT_MARKEDNODE,activeQuestList.length - 1);
            QueryManager.instance.saveModifiedCharData();
            OverworldHUD.instance.territorymap.refresh();
            return true;
         }
         return false;
      }
      
      public static function setActiveQuest(param1:int, param2:int) : *
      {
         var _loc3_:int = int(activeQuestList.length - 1);
         while(_loc3_ >= 0)
         {
            if(activeQuestList[_loc3_].questID == param1)
            {
               activeQuestList[_loc3_].step = param2;
               QueryManager.instance.reportDataModified(ACTIVEQUEST);
               StatsManager.setStat(StatsManager.STAT_MARKEDNODE,_loc3_);
               QueryManager.instance.saveModifiedCharData();
               OverworldHUD.instance.territorymap.refresh();
               StageManager.refreshRoomQuestObjects();
               return;
            }
            _loc3_--;
         }
         activeQuestList.fixed = false;
         var _loc4_:ActiveQuest;
         (_loc4_ = new ActiveQuest(param1)).step = param2;
         activeQuestList.push(_loc4_);
         activeQuestList.fixed = true;
         QueryManager.instance.reportDataModified(ACTIVEQUEST);
         StatsManager.setStat(StatsManager.STAT_MARKEDNODE,activeQuestList.length - 1);
         QueryManager.instance.saveModifiedCharData();
         OverworldHUD.instance.territorymap.refresh();
         StageManager.refreshRoomQuestObjects();
      }
      
      public static function addProcGenDailyQuest(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:*) : int
      {
         var _loc10_:ActiveQuest = null;
         var _loc9_:int = int(activeQuestList.length - 1);
         while(_loc9_ >= 0)
         {
            if(activeQuestList[_loc9_].hasProcGenDailyQuest(param1,param2,param3,param4,param5 == QuestItem.QUEST_TRADE))
            {
               return _loc9_;
            }
            _loc9_--;
         }
         if(activeQuestList.length < MAXQUESTS)
         {
            activeQuestList.fixed = false;
            (_loc10_ = new ActiveQuest(-1)).setProcGenDailyQuest(param1,param2,param3,param4,param5,param6,param7,param8);
            activeQuestList.push(_loc10_);
            activeQuestList.fixed = true;
            QueryManager.instance.reportDataModified(ACTIVEQUEST);
            return activeQuestList.length - 1;
         }
         return -1;
      }
      
      public static function checkProcGenDailyQuestItem() : int
      {
         var _loc2_:ActiveQuest = null;
         var _loc1_:int = -1;
         var _loc3_:int = int(activeQuestList.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = activeQuestList[_loc3_];
            if(_loc2_.isProcGenDailyQuest && QuestGenerator.instance.playerHasNPCQuestItem(_loc2_))
            {
               _loc2_.procGenNextStep();
               _loc1_ = _loc3_;
            }
            _loc3_--;
         }
         return _loc1_;
      }
      
      public static function completeProcGenQuestStep(param1:int, param2:int, param3:int, param4:int, param5:int) : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:ActiveQuest = null;
         trace("completeProcGenQuestStep: " + param1 + " " + param2 + " " + param3 + " " + param4 + " " + param5);
         var _loc6_:int = int(QuestEngine.getQuestData(QuestGenerator.PROCGENQUEST).getStepList().length);
         var _loc9_:int = int(activeQuestList.length);
         var _loc11_:int = 0;
         while(_loc11_ < _loc9_)
         {
            if((_loc10_ = activeQuestList[_loc11_]).hasProcGenDailyQuest(param1,param2,param3,param4,param5 == QuestItem.QUEST_TRADE))
            {
               if((_loc7_ = activeQuestList[_loc11_].step) < _loc6_ - 1)
               {
                  activeQuestList[_loc11_].procGenNextStep();
                  QueryManager.instance.reportDataModified(ACTIVEQUEST);
                  OverworldHUD.instance.territorymap.refresh();
                  return false;
               }
            }
            _loc11_++;
         }
         return false;
      }
      
      public static function hasProcGenQuestAtLocation(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = int(activeQuestList.length - 1);
         while(_loc4_ >= 0)
         {
            if(activeQuestList[_loc4_].hasProcGenQuestAtLocation(param1,param2,QueryManager.instance.getServerDate(),param3))
            {
               return _loc4_;
            }
            _loc4_--;
         }
         return -1;
      }
      
      public static function getProcGenQuest(param1:int, param2:int, param3:int, param4:int, param5:Boolean) : ActiveQuest
      {
         var _loc6_:int = int(activeQuestList.length - 1);
         while(_loc6_ >= 0)
         {
            if(activeQuestList[_loc6_].hasProcGenDailyQuest(param1,param2,param3,param4,param5))
            {
               return activeQuestList[_loc6_];
            }
            _loc6_--;
         }
         return null;
      }
      
      public static function completeQuest(param1:int, param2:Boolean = false, param3:Boolean = false) : *
      {
         var _loc4_:CompletedQuest = null;
         var _loc5_:ActiveQuest = null;
         var _loc6_:int = 0;
         var _loc7_:ActiveQuest = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param2)
         {
            _loc4_ = QuestGenerator.instance.getCompletedQuest(param3);
            completedQuestList.fixed = false;
            completedQuestList.push(_loc4_);
            completedQuestList.fixed = true;
            QueryManager.instance.reportDataModified(COMPLETEDQUEST);
            _loc6_ = int(activeQuestList.length - 1);
            while(_loc6_ >= 0)
            {
               if((_loc5_ = activeQuestList[_loc6_]).hasProcGenDailyQuest(_loc4_.nodeid,_loc4_.roomid,_loc4_.index,_loc4_.completedTime,param3))
               {
                  activeQuestList.fixed = false;
                  activeQuestList.splice(_loc6_,1);
                  activeQuestList.fixed = true;
                  if(_loc5_.questType == QuestItem.QUEST_BOUNTYBOARD)
                  {
                     StatsManager.reportAchievementStat(60011,1);
                  }
                  else
                  {
                     StatsManager.reportAchievementStat(60010,1);
                  }
                  QueryManager.instance.reportDataModified(ACTIVEQUEST);
                  break;
               }
               _loc6_--;
            }
            if((_loc7_ = _loc5_) != null)
            {
               if(_loc7_.isForTrade() && _loc7_.targetroomid != -1 && _loc7_.targetnpcindex != -1)
               {
                  _loc6_ = int(activeQuestList.length - 1);
                  while(_loc6_ >= 0)
                  {
                     if((_loc5_ = activeQuestList[_loc6_]).hasTarget(_loc7_.targetnodeid,_loc7_.targetroomid,_loc7_.targetnpcindex))
                     {
                        activeQuestList.fixed = false;
                        activeQuestList.splice(_loc6_,1);
                        activeQuestList.fixed = true;
                        QueryManager.instance.reportDataModified(ACTIVEQUEST);
                     }
                     _loc6_--;
                  }
               }
            }
         }
         else
         {
            trace("completeQuest: " + param1);
            _loc8_ = int(activeQuestList.length);
            _loc6_ = 0;
            while(_loc6_ < _loc8_)
            {
               if(activeQuestList[_loc6_].questID == param1)
               {
                  activeQuestList.fixed = false;
                  activeQuestList.splice(_loc6_,1);
                  activeQuestList.fixed = true;
                  QueryManager.instance.reportDataModified(ACTIVEQUEST);
                  completedQuestList.fixed = false;
                  if(QuestEngine.getQuestData(param1).type != 1)
                  {
                     if(QuestEngine.getQuestData(param1).type == 3)
                     {
                        completedQuestList.push(new CompletedQuest(param1,serverTimeVariable));
                     }
                     else
                     {
                        completedQuestList.push(new CompletedQuest(param1));
                     }
                  }
                  completedQuestList.fixed = true;
                  QueryManager.instance.reportDataModified(COMPLETEDQUEST);
                  break;
               }
               _loc6_++;
            }
            if((_loc9_ = int(activeQuestList.length - 1)) >= 0)
            {
               StatsManager.setStat(StatsManager.STAT_MARKEDNODE,_loc9_);
               QueryManager.instance.saveModifiedCharData();
               OverworldHUD.instance.territorymap.refresh();
            }
            else
            {
               OverworldHUD.instance.setActiveQuestText("");
            }
            if(param1 == 59)
            {
               reportAchievementStat(60025,1,true);
            }
         }
      }
      
      public static function completeQuestStep(param1:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         trace("completeQuestStep: " + param1);
         var _loc2_:int = int(QuestEngine.getQuestData(param1).getStepList().length);
         var _loc5_:int = int(activeQuestList.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if((_loc4_ = activeQuestList[_loc6_].questID) == param1)
            {
               _loc3_ = activeQuestList[_loc6_].step;
               if(_loc3_ < _loc2_ - 1)
               {
                  activeQuestList[_loc6_].nextStep();
                  QueryManager.instance.reportDataModified(ACTIVEQUEST);
                  OverworldHUD.instance.territorymap.refresh();
                  return false;
               }
               completeQuest(param1);
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      public static function abandonQuest(param1:ActiveQuest) : Boolean
      {
         var _loc2_:int = int(activeQuestList.length - 1);
         while(_loc2_ >= 0)
         {
            if(param1 == activeQuestList[_loc2_])
            {
               activeQuestList.fixed = false;
               activeQuestList.splice(_loc2_,1);
               activeQuestList.fixed = true;
               QueryManager.instance.reportDataModified(ACTIVEQUEST);
               return true;
            }
            _loc2_--;
         }
         return false;
      }
      
      public static function roomHasActiveQuest(param1:int, param2:int) : Boolean
      {
         var _loc4_:ActiveQuest = null;
         var _loc3_:int = int(activeQuestList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if((_loc4_ = activeQuestList[_loc5_]).getMarkedNode() == param1 && _loc4_.getMarkedRoom() == param2)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function roomHasActiveQuestInn(param1:int, param2:int) : Boolean
      {
         var _loc4_:ActiveQuest = null;
         var _loc3_:int = int(activeQuestList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if((_loc4_ = activeQuestList[_loc5_]).getMarkedNode() == param1 && _loc4_.getMarkedRoom() >= 100 && _loc4_.getMarkedRoom() < 110)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function roomHasActiveQuestGamblingDen(param1:int, param2:int) : Boolean
      {
         var _loc4_:ActiveQuest = null;
         var _loc3_:int = int(activeQuestList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if((_loc4_ = activeQuestList[_loc5_]).getMarkedNode() == param1 && _loc4_.getMarkedRoom() >= 110 && _loc4_.getMarkedRoom() < 120)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function getXP() : int
      {
         return getPlayerStats(STAT_XP);
      }
      
      public static function getLevel() : int
      {
         var _loc1_:int = getPlayerStats(STAT_XP);
         var _loc2_:int = 0;
         while(_loc2_ < 99)
         {
            if(expArray[_loc2_] > _loc1_)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 99;
      }
      
      public static function getXPtoLevel() : int
      {
         return expArray[getLevel()] - getPlayerStats(STAT_XP);
      }
      
      public static function getXPLevelThreshhold(param1:int) : int
      {
         return expArray[param1];
      }
      
      public static function changeXP(param1:int) : Boolean
      {
         var _loc6_:int = 0;
         var _loc2_:int = getLevel();
         var _loc3_:int = changeStat(9,param1);
         if(_loc3_ < 0)
         {
            setStat(9,0);
         }
         var _loc4_:int = getLevel();
         if(!consoleEnabled && _loc4_ > levelCap)
         {
            QueryManager.instance.reportHack("changeXP levelcap");
            return false;
         }
         var _loc5_:int = _loc4_ - _loc2_;
         if(!consoleEnabled && _loc5_ >= 5)
         {
            QueryManager.instance.reportHack("changeXP many levels");
            return false;
         }
         if(_loc5_ > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               trace("level up!");
               levelUp();
               _loc6_++;
            }
            QueryManager.instance.saveModifiedCharData();
            OverworldHUD.instance.updateHUD();
            NetworkManager.instance.globalAnnouncement("",LangManager.getString(863,[getChatDisplayCharname(),getLevel()]));
            return true;
         }
         OverworldHUD.instance.updateHUD();
         return false;
      }
      
      public static function levelUp() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         changeStat(STAT_SKILLPOINTS,1);
         changeStat(STAT_STATPOINTS,3);
         setStat(STAT_LEVEL,getLevel());
         if(autoAssignStats)
         {
            _loc1_ = new Array(STAT_MAXHP,STAT_MAXCHI,STAT_ATTACK,STAT_DEFENSE,STAT_SPEED,STAT_MAXAP);
            _loc2_ = getLevel() % _loc1_.length;
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               if(_loc2_ + _loc4_ >= _loc1_.length)
               {
                  _loc3_ = _loc1_[_loc2_ + _loc4_] - _loc1_.length;
               }
               else
               {
                  _loc3_ = int(_loc1_[_loc2_ + _loc4_]);
               }
               if(_loc3_ == STAT_MAXHP)
               {
                  changeStat(_loc3_,5);
               }
               else if(_loc3_ == STAT_MAXCHI)
               {
                  changeStat(_loc3_,5);
               }
               else if(_loc3_ == STAT_MAXAP)
               {
                  changeStat(_loc3_,1);
               }
               else
               {
                  changeStat(_loc3_,1);
               }
               trace("auto stat increase for " + _loc3_);
               changeStat(STAT_STATPOINTS,-1);
               _loc4_++;
            }
         }
         fullHealth();
         setStat(STAT_AP,getPlayerStats(STAT_MAXAP));
         setStat(STAT_DUELTOKENS,MAXDUELTOKENS);
         QueryManager.instance.reportDataModified(PLAYERLEVEL);
         OverworldHUD.instance.updateHUD();
      }
      
      public static function fullHealth() : *
      {
         setStat(STAT_HP,getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP));
         setStat(STAT_CHI,getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI));
         OverworldHUD.instance.updateHUD();
         player.setHP(getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP));
         player.setChi(getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI));
      }
      
      public static function partialHealth() : *
      {
         var _loc1_:int = getStat(STAT_MAXHP) + findBonusStat(STAT_MAXHP);
         var _loc2_:int = _loc1_ * 0.75;
         if(_loc2_ > _loc1_)
         {
            _loc2_ = _loc1_;
         }
         setStat(STAT_HP,_loc2_);
         var _loc3_:int = getStat(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI);
         var _loc4_:int;
         if((_loc4_ = _loc3_ * 0.5) > _loc3_)
         {
            _loc4_ = _loc3_;
         }
         setStat(STAT_CHI,_loc4_);
         OverworldHUD.instance.updateHUD();
      }
      
      public static function saveHealthAfterBattle() : *
      {
         var _loc1_:int = getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP);
         var _loc2_:int = getPlayer().getHP() + _loc1_ / 10 + findBonusStat(STAT_HPREGEN);
         if(_loc2_ > _loc1_)
         {
            _loc2_ = _loc1_;
         }
         setStat(STAT_HP,_loc2_);
         var _loc3_:int = getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI);
         var _loc4_:int;
         if((_loc4_ = getPlayer().getChi() + _loc3_ / 10 + findBonusStat(STAT_CHIREGEN)) > _loc3_)
         {
            _loc4_ = _loc3_;
         }
         setStat(STAT_CHI,_loc4_);
      }
      
      public static function saveHealthAfterBattleNoRegen() : *
      {
         var _loc1_:int = getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP);
         var _loc2_:int = getPlayer().getHP();
         if(_loc2_ > _loc1_)
         {
            _loc2_ = _loc1_;
         }
         setStat(STAT_HP,_loc2_);
         var _loc3_:int = getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI);
         var _loc4_:int;
         if((_loc4_ = getPlayer().getChi()) > _loc3_)
         {
            _loc4_ = _loc3_;
         }
         setStat(STAT_CHI,_loc4_);
      }
      
      public static function createPlayer() : MCSPlayer
      {
         if(player == null)
         {
            player = new MCSPlayer();
            player.initMCS(equipment[EQ_ARMOR],equipment[EQ_GLOVES],equipment[EQ_HAIR],equipment[EQ_HAT],equipment[EQ_HEAD],equipment[EQ_MASK],equipment[EQ_NECK],equipment[EQ_PANTS],equipment[EQ_SHOES],equipment[EQ_WEAPON],equipment[EQ_SCABBARD].itemID);
            player.isFriendly = true;
         }
         return player;
      }
      
      public static function createPlayerBust() : MCSBust
      {
         if(bust == null)
         {
            bust = new MCSBust();
            if(equipment[0] == null)
            {
               bust.initMCS(new Item(0),new Item(0),new Item(0),new Item(0),new Item(0),new Item(0));
            }
            else
            {
               bust.initMCS(equipment[EQ_ARMOR],equipment[EQ_HAIR],equipment[EQ_HAT],equipment[EQ_HEAD],equipment[EQ_MASK],equipment[EQ_NECK]);
            }
         }
         return bust;
      }
      
      public static function refreshMCS() : *
      {
         if(getPlayerMCS() != null)
         {
            getPlayerMCS().initMCS(equipment[EQ_ARMOR],equipment[EQ_GLOVES],equipment[EQ_HAIR],equipment[EQ_HAT],equipment[EQ_HEAD],equipment[EQ_MASK],equipment[EQ_NECK],equipment[EQ_PANTS],equipment[EQ_SHOES],equipment[EQ_WEAPON],equipment[EQ_SCABBARD].itemID);
         }
         if(getPlayerBust() != null)
         {
            getPlayerBust().initMCS(equipment[EQ_ARMOR],equipment[EQ_HAIR],equipment[EQ_HAT],equipment[EQ_HEAD],equipment[EQ_MASK],equipment[EQ_NECK]);
         }
      }
      
      public static function getPlayer() : MCSPlayer
      {
         return player;
      }
      
      public static function getPlayerMCS() : MCSCharacter
      {
         if(player == null)
         {
            createPlayer();
         }
         return player.mcs;
      }
      
      public static function getPlayerBust() : MCSBust
      {
         if(bust == null)
         {
            createPlayerBust();
         }
         return bust;
      }
      
      public static function getLocation() : int
      {
         return getPlayerStats(STAT_LOCATION);
      }
      
      public static function initPlayer() : *
      {
         if(equipment[EQ_WEAPON].itemID == 0)
         {
            equipItem(EQ_WEAPON,new Item(13002,1));
         }
         player.initPlayer(0,getPlayerStats(STAT_HP),getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP),getPlayerStats(STAT_CHI),getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI),getPlayerStats(STAT_DEFENSE) + findBonusStat(STAT_DEFENSE),getBaseReload(),getMinDamage(),getDamageRange(),getBaseSlashLength(),getSlashUsage(),getStat(1000),getStat(1001),getStat(1002),getLevel());
         player.initAttackStats(getPlayerStats(STAT_ATTACK) + findBonusStat(STAT_ATTACK),getPlayerStats(STAT_FIREATK) + findBonusStat(STAT_FIREATK),getPlayerStats(STAT_WINDATK) + findBonusStat(STAT_WINDATK),getPlayerStats(STAT_WATERATK) + findBonusStat(STAT_WATERATK),getPlayerStats(STAT_EARTHATK) + findBonusStat(STAT_EARTHATK),findBonusStat(STAT_CRITICALDMG),findBonusStat(STAT_PIERCINGDMG));
         player.initElementDefenseStats(getPlayerStats(STAT_WATERATK) + findBonusStat(STAT_FIREDEF),getPlayerStats(STAT_EARTHATK) + findBonusStat(STAT_WINDDEF),getPlayerStats(STAT_WINDATK) + findBonusStat(STAT_WATERDEF),getPlayerStats(STAT_FIREATK) + findBonusStat(STAT_EARTHDEF));
      }
      
      internal static function getBaseReload() : int
      {
         return 48 + (getPlayerStats(STAT_SPEED) + findBonusStat(STAT_SPEED)) * 6;
      }
      
      internal static function getSkillCooldownModifier() : Number
      {
         var _loc1_:int = getPlayerStats(STAT_SPEED) + findBonusStat(STAT_SPEED);
         if(hasBuff(BUFF_SPEED))
         {
            _loc1_ *= 1.5;
         }
         return getSkillCooldownModifierVal(_loc1_);
      }
      
      internal static function getSkillCooldownModifierVal(param1:int) : Number
      {
         if(param1 > 300)
         {
            param1 = 300;
         }
         return 1 - param1 / 300 * 0.5;
      }
      
      internal static function getMinDamage() : int
      {
         var _loc1_:int = 0;
         if(equipment[EQ_WEAPON].itemID == 0)
         {
            return int(getPlayerStats(STAT_ATTACK) + findBonusStat(STAT_ATTACK));
         }
         var _loc2_:XMLItem = QuestEngine.getItemData(equipment[EQ_WEAPON].itemID);
         if(_loc2_ == null || equipment[EQ_WEAPON].isBroken())
         {
            if(_loc2_ == null)
            {
               trace("StatsManager.getMinDamage() - Item: " + equipment[EQ_WEAPON].itemID + " not found");
            }
            _loc1_ = getPlayerStats(STAT_ATTACK) + findBonusStat(STAT_ATTACK) + 1;
         }
         else
         {
            _loc1_ = getPlayerStats(STAT_ATTACK) + findBonusStat(STAT_ATTACK) + _loc2_.mindamage;
         }
         if(superDamage)
         {
            return 1000;
         }
         return _loc1_;
      }
      
      internal static function getDamageRange() : int
      {
         if(equipment[EQ_WEAPON].itemID == 0 || equipment[EQ_WEAPON].isBroken())
         {
            return 0;
         }
         var _loc1_:XMLItem = QuestEngine.getItemData(equipment[EQ_WEAPON].itemID);
         if(_loc1_ == null)
         {
            trace("StatsManager.getDamageRange() - Item: " + equipment[EQ_WEAPON].itemID + " not found");
            return 0;
         }
         return _loc1_.maxdamage - _loc1_.mindamage;
      }
      
      internal static function getBaseSlashLength() : int
      {
         var _loc1_:int = getPlayerStats(STAT_SPEED) + findBonusStat(STAT_SPEED);
         if(hasBuff(BUFF_SPEED))
         {
            _loc1_ *= 1.5;
         }
         return getBaseSlashLengthVal(_loc1_);
      }
      
      internal static function getBaseSlashLengthVal(param1:int) : int
      {
         var _loc2_:int = 90 + getPlayerStats(STAT_DAN) * 5;
         return int(120 + Math.floor(_loc2_ * param1 / (20 + param1)));
      }
      
      internal static function getSlashUsage() : int
      {
         var _loc1_:XMLItem = QuestEngine.getItemData(equipment[EQ_WEAPON].itemID);
         if(_loc1_ == null || _loc1_.slashusage < 48)
         {
            trace("StatsManager.getSlashUsage() - Item: " + equipment[EQ_WEAPON].itemID + " not found");
            return 48;
         }
         return _loc1_.slashusage;
      }
      
      public static function findBonusStat(param1:int, param2:Boolean = false) : int
      {
         var _loc5_:XMLItem = null;
         var _loc6_:Item = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         if(StatsManager.equipment == null || StatsManager.equipment.length == 0)
         {
            return 0;
         }
         var _loc8_:* = 0;
         while(_loc8_ < 13)
         {
            if(_loc8_ != EQ_HEAD && _loc8_ != EQ_NECK && _loc8_ != EQ_SCABBARD && _loc8_ != EQ_HAIR && !(param2 && _loc8_ == EQ_WEAPON))
            {
               if((_loc6_ = StatsManager.equipment[_loc8_]) != null)
               {
                  _loc4_ = _loc6_.itemID;
                  if((_loc5_ = QuestEngine.getItemData(_loc4_)) != null)
                  {
                     if(param1 == STAT_DEFENSE)
                     {
                        _loc3_ += int(_loc5_.defense);
                     }
                     _loc7_ = 0;
                     while(_loc7_ < _loc5_.modifierXML.length())
                     {
                        if(_loc5_.modifierXML[_loc7_].id == param1)
                        {
                           _loc3_ += int(_loc5_.modifierXML[_loc7_].value);
                        }
                        _loc7_++;
                     }
                     _loc7_ = 0;
                     while(_loc7_ < _loc6_.modifiers.length)
                     {
                        if(_loc6_.modifiers[_loc7_].modifierID == param1)
                        {
                           _loc3_ += _loc6_.modifiers[_loc7_].value;
                        }
                        _loc7_++;
                     }
                  }
               }
            }
            _loc8_++;
         }
         if(param1 == STAT_MAXHP && _loc3_ + getPlayerStats(STAT_MAXHP) <= 0)
         {
            return -getPlayerStats(STAT_MAXHP) + 1;
         }
         return _loc3_;
      }
      
      public static function findWeight() : int
      {
         var _loc2_:XMLItem = null;
         var _loc3_:Item = null;
         var _loc4_:int = 0;
         var _loc1_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < inventory.length)
         {
            if(inventory[_loc4_].getQuantity() > 0)
            {
               _loc2_ = QuestEngine.getItemData(inventory[_loc4_].itemID);
               if(_loc2_ != null)
               {
                  _loc1_ += _loc2_.weight * inventory[_loc4_].getQuantity();
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 13)
         {
            if(_loc4_ != EQ_HEAD && _loc4_ != EQ_NECK && _loc4_ != EQ_SCABBARD)
            {
               _loc3_ = StatsManager.equipment[_loc4_];
               if(_loc3_ != null)
               {
                  _loc2_ = QuestEngine.getItemData(_loc3_.itemID);
                  if(_loc2_ != null)
                  {
                     _loc1_ += _loc2_.weight;
                  }
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < questItems.length)
         {
            if(questItems[_loc4_].getQuantity() > 0)
            {
               _loc2_ = QuestEngine.getItemData(questItems[_loc4_].itemID);
               if(_loc2_ != null)
               {
                  _loc1_ += _loc2_.weight * questItems[_loc4_].getQuantity();
               }
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public static function findBonusStatFrom(param1:int, param2:Vector.<Item>) : int
      {
         var _loc5_:Item = null;
         var _loc6_:XMLItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         while(_loc8_ < 13)
         {
            if(_loc8_ != EQ_HEAD && _loc8_ != EQ_NECK && _loc8_ != EQ_SCABBARD)
            {
               if((_loc5_ = param2[_loc8_]) != null)
               {
                  _loc4_ = _loc5_.itemID;
                  if((_loc6_ = QuestEngine.getItemData(_loc4_)) != null)
                  {
                     if(param1 == STAT_DEFENSE)
                     {
                        _loc3_ += int(_loc6_.defense);
                     }
                     _loc7_ = 0;
                     while(_loc7_ < _loc6_.modifierXML.length())
                     {
                        if(_loc6_.modifierXML[_loc7_].id == param1)
                        {
                           _loc3_ += int(_loc6_.modifierXML[_loc7_].value);
                        }
                        _loc7_++;
                     }
                     _loc7_ = 0;
                     while(_loc7_ < _loc5_.modifiers.length)
                     {
                        if(_loc5_.modifiers[_loc7_].modifierID == param1)
                        {
                           _loc3_ += _loc5_.modifiers[_loc7_].value;
                        }
                        _loc7_++;
                     }
                  }
               }
            }
            _loc8_++;
         }
         return _loc3_;
      }
      
      public static function checkSetStat() : *
      {
         var _loc4_:Boolean = false;
         var _loc6_:XMLItem = null;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = new Array(new Array(),new Array());
         var _loc5_:* = 0;
         while(_loc5_ < 13)
         {
            _loc4_ = true;
            if(_loc5_ != 2 && _loc5_ != 4 && _loc5_ != 6 && _loc5_ != 10)
            {
               _loc2_ = int(StatsManager.equipment[_loc5_].itemID);
               if(_loc6_ = QuestEngine.getItemData(_loc2_))
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.modifierXML.length())
                  {
                     if(_loc6_.modifierXML[_loc7_].id > 100 && _loc6_.modifierXML[_loc7_].id < 1000)
                     {
                        if(_loc3_.length > 0)
                        {
                           _loc8_ = 0;
                           while(_loc8_ < _loc3_[0].length)
                           {
                              if(int(_loc6_.modifierXML[_loc7_].id) == _loc3_[0][_loc8_])
                              {
                                 _loc3_[1][_loc8_] += 1;
                                 _loc4_ = false;
                              }
                              _loc8_++;
                           }
                        }
                        if(_loc4_)
                        {
                           _loc3_[0].push(int(_loc6_.modifierXML[_loc7_].id));
                           _loc3_[1].push(1);
                        }
                     }
                     _loc7_++;
                  }
               }
            }
            _loc5_++;
         }
      }
      
      public static function unAssignStatPoints() : *
      {
         setPlayerStats(STAT_MAXHP,10);
         var _loc1_:int = getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP);
         setPlayerStats(STAT_HP,_loc1_);
         setPlayerStats(STAT_MAXCHI,10);
         var _loc2_:int = getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI);
         setPlayerStats(STAT_CHI,_loc2_);
         setPlayerStats(STAT_ATTACK,1);
         setPlayerStats(STAT_DEFENSE,1);
         setPlayerStats(STAT_SPEED,1);
         var _loc3_:int = getPlayerStats(STAT_AP);
         if(_loc3_ > 30)
         {
            _loc3_ = 30;
         }
         setPlayerStats(STAT_AP,_loc3_);
         setPlayerStats(STAT_MAXAP,30);
         setPlayerStats(STAT_STATPOINTS,(getLevel() - 1) * 3);
         QueryManager.instance.reportDataModified(PLAYERSTAT);
         QueryManager.instance.saveModifiedCharData();
      }
      
      public static function unAssignSkillPoints() : *
      {
         skillStats.fixed = false;
         skillStats.length = 0;
         skillStats.push(new IntStat(1000,1));
         skillStats.push(new IntStat(1001,1));
         skillStats.push(new IntStat(1002,1));
         skillStats.push(new IntStat(1003,1));
         skillStats.push(new IntStat(1042,1));
         skillStats.push(new IntStat(1049,1));
         skillStats.push(new IntStat(1050,1));
         skillStats.fixed = true;
         skillSlots.fixed = false;
         skillSlots = new Vector.<IntStat>(8);
         skillSlots[0] = new IntStat(1003,1);
         skillSlots.fixed = true;
         setPlayerStats(STAT_SKILLPOINTS,getLevel() - 1 + getPlayerStats(STAT_DAN) * (levelCap - 1));
         QueryManager.instance.reportDataModified(SKILL);
         QueryManager.instance.reportDataModified(SKILLSLOT);
         QueryManager.instance.reportDataModified(PLAYERSTAT);
         QueryManager.instance.saveModifiedCharData();
         OverworldHUD.instance.skillUI.unAssignSkillPoints();
      }
      
      public static function unequipAll() : *
      {
         var _loc1_:Vector.<Item> = new Vector.<Item>();
         _loc1_.push(equipment[EQ_HAT]);
         _loc1_.push(equipment[EQ_ARMOR]);
         _loc1_.push(equipment[EQ_MASK]);
         _loc1_.push(equipment[EQ_GLOVES]);
         _loc1_.push(equipment[EQ_WEAPON]);
         _loc1_.push(equipment[EQ_PANTS]);
         _loc1_.push(equipment[EQ_SHOES]);
         _loc1_.push(equipment[EQ_ACCESSORY1]);
         _loc1_.push(equipment[EQ_ACCESSORY2]);
         addItemsToInventory(_loc1_);
         removeEquipment(EQ_HAT);
         removeEquipment(EQ_ARMOR);
         removeEquipment(EQ_MASK);
         removeEquipment(EQ_GLOVES);
         removeEquipment(EQ_WEAPON);
         removeEquipment(EQ_PANTS);
         removeEquipment(EQ_SHOES);
         removeEquipment(EQ_ACCESSORY1);
         removeEquipment(EQ_ACCESSORY2);
         QueryManager.instance.reportDataModified(ITEM);
         equipItem(EQ_ARMOR,new Item(4017,1));
         equipItem(EQ_PANTS,new Item(11017,1));
         equipItem(EQ_SHOES,new Item(12017,1));
         equipItem(EQ_WEAPON,new Item(0,1));
         equipItem(EQ_SCABBARD,new Item(13100,1));
         QueryManager.instance.reportDataModified(EQUIPMENT);
      }
      
      public static function doRebirth() : *
      {
         var _loc1_:ActiveQuest = null;
         didRebirth = true;
         unequipAll();
         setStat(STAT_XP,0);
         if(getPlayerStats(STAT_DAN) == 8)
         {
            changeStat(STAT_HGOLD,20);
         }
         else
         {
            changeStat(STAT_HGOLD,5);
         }
         if(getPlayerStats(STAT_DAN) < 9)
         {
            changeStat(STAT_DAN,1);
         }
         QueryManager.instance.reportDataModified(PLAYERDAN);
         NetworkManager.instance.globalAnnouncement("",LangManager.getString(864,[getChatDisplayCharname(),(getPlayerStats(STAT_DAN) + 1).toString()]));
         skillSlots.fixed = false;
         skillSlots = new Vector.<IntStat>(8);
         skillSlots[0] = new IntStat(1003,1);
         skillSlots.fixed = true;
         QueryManager.instance.reportDataModified(SKILLSLOT);
         var _loc2_:int = int(activeQuestList.length - 1);
         while(_loc2_ >= 0)
         {
            _loc1_ = activeQuestList[_loc2_];
            if(_loc1_.isProcGenDailyQuest)
            {
               activeQuestList.splice(_loc2_,1);
            }
            _loc2_--;
         }
         QueryManager.instance.reportDataModified(ACTIVEQUEST);
         unAssignStatPoints();
         OverworldHUD.getInstance().screenTransition.setTeleportTarget(8382465,0,200);
         OverworldHUD.getInstance().screenTransition.startClose(ScreenTransition.ACTION_TELEPORTDOWNED);
      }
      
      public static function leaveClan() : *
      {
         setStat(STAT_SIDE,0);
         setStat(STAT_WARMOVESMADE,0);
         setStat(STAT_WARCOINSDONATED,0);
         QueryManager.instance.delWarSentry(-1,StatsManager.id);
         QueryManager.instance.reportDataModified(PLAYERSTAT);
         QueryManager.instance.saveModifiedCharData();
         OverworldHUD.instance.leaveClan();
      }
      
      public static function isFemale() : Boolean
      {
         return getPlayerStats(STAT_ISFEMALE) == 1;
      }
      
      public static function changeSex() : *
      {
         var _loc1_:int = getPlayerStats(STAT_ISFEMALE);
         if(_loc1_ == 1)
         {
            _loc1_ = 0;
         }
         else
         {
            _loc1_ = 1;
         }
         setPlayerStats(STAT_ISFEMALE,_loc1_);
         if(_loc1_ == 0)
         {
            equipItem(EQ_HEAD,new Item(8006,1));
            equipItem(EQ_NECK,new Item(10000,1));
            if(equipment[EQ_ARMOR].itemID == 0 || equipment[EQ_ARMOR].itemID == 4001 || equipment[EQ_ARMOR].itemID == 4000)
            {
               equipItem(EQ_ARMOR,new Item(4000,1));
            }
            if(equipment[EQ_PANTS].itemID == 0 || equipment[EQ_PANTS].itemID == 11001 || equipment[EQ_PANTS].itemID == 11000)
            {
               equipItem(EQ_PANTS,new Item(11000,1));
            }
         }
         else
         {
            equipItem(EQ_HEAD,new Item(8500,1));
            equipItem(EQ_NECK,new Item(10001,1));
            if(equipment[EQ_ARMOR].itemID == 0 || equipment[EQ_ARMOR].itemID == 4001 || equipment[EQ_ARMOR].itemID == 4000)
            {
               equipItem(EQ_ARMOR,new Item(4001,1));
            }
            if(equipment[EQ_PANTS].itemID == 0 || equipment[EQ_PANTS].itemID == 11001 || equipment[EQ_PANTS].itemID == 11000)
            {
               equipItem(EQ_PANTS,new Item(11001,1));
            }
         }
         QueryManager.instance.reportDataModified(PLAYERSTAT);
         QueryManager.instance.reportDataModified(EQUIPMENT);
         QueryManager.instance.saveModifiedCharData();
      }
      
      public static function getSkillSlotCount() : int
      {
         return 3 + getStat(1008);
      }
      
      public static function getCarryingWeight() : int
      {
         return 100 + getStat(1009) * 20;
      }
      
      internal static function setNextAPUpdate(param1:int, param2:int) : *
      {
         nextAPUpdate = param1 + param2;
      }
      
      internal static function setNextDTUpdate(param1:int, param2:int) : *
      {
         nextDTUpdate = param1 + param2;
      }
      
      public static function checkAP(param1:int) : Boolean
      {
         if(unlimitedAP)
         {
            return true;
         }
         var _loc2_:int = getPlayerStats(STAT_AP);
         if(param1 <= _loc2_)
         {
            changeAP(-param1);
            return true;
         }
         return false;
      }
      
      public static function getAP() : int
      {
         return getPlayerStats(STAT_AP);
      }
      
      internal static function changeAP(param1:int) : int
      {
         var _loc2_:int = changeStat(13,param1);
         var _loc3_:int = getPlayerStats(STAT_MAXAP);
         if(_loc2_ > _loc3_)
         {
            setStat(13,_loc3_);
            OverworldHUD.instance.updateHUD();
            InventoryUI.instance.updateAP();
            return _loc3_;
         }
         if(_loc2_ < 0)
         {
            setStat(13,0);
            OverworldHUD.instance.updateHUD();
            InventoryUI.instance.updateAP();
            return 0;
         }
         if(nextAPUpdate == -1)
         {
            serverTimeVariable = QueryManager.instance.getServerTime();
            setNextAPUpdate(serverTimeVariable,APINTERVAL);
         }
         OverworldHUD.instance.updateHUD();
         InventoryUI.instance.updateAP();
         return _loc2_;
      }
      
      public static function addMaxAP(param1:int) : *
      {
         changeStat(STAT_MAXAP,param1);
         if(nextAPUpdate == -1)
         {
            setNextAPUpdate(serverTimeVariable,APINTERVAL);
         }
         OverworldHUD.instance.updateHUD();
      }
      
      public static function changeDT(param1:int) : *
      {
         var _loc2_:int = changeStat(STAT_DUELTOKENS,param1);
         var _loc3_:int = MAXDUELTOKENS;
         if(_loc2_ > _loc3_)
         {
            setStat(STAT_DUELTOKENS,_loc3_);
            OverworldHUD.instance.updateHUD();
            return _loc3_;
         }
         if(_loc2_ < 0)
         {
            setStat(STAT_DUELTOKENS,0);
            OverworldHUD.instance.updateHUD();
            return 0;
         }
         if(nextDTUpdate == -1)
         {
            serverTimeVariable = QueryManager.instance.getServerTime();
            setNextDTUpdate(serverTimeVariable,DTINTERVAL);
         }
         OverworldHUD.instance.updateHUD();
         return _loc2_;
      }
      
      public static function addItemsToInventory(param1:Vector.<Item>, param2:Boolean = false) : *
      {
         var _loc4_:Item = null;
         var _loc3_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1[_loc5_];
            if(param2 && _loc4_.getShopItemType() == "rare")
            {
               NetworkManager.instance.itemAnnouncement(_loc4_);
            }
            if(_loc4_ != null && _loc4_.itemID != 0 && _loc4_.itemID != 20059)
            {
               addItemToInventory(_loc4_);
            }
            _loc5_++;
         }
      }
      
      public static function addToInventory(param1:int) : int
      {
         if(param1 >= 2000 && param1 < 30000)
         {
            return changeStat(param1,1);
         }
         trace("StatsManager.addToInventory: id out of range");
         return 0;
      }
      
      public static function addItemToInventory(param1:Item) : *
      {
         if(param1.isQuestItem())
         {
            addSpecialItemToQuestItems(param1);
         }
         else
         {
            addSpecialItemToInventory(param1);
         }
      }
      
      private static function addSpecialItemToInventory(param1:Item) : Item
      {
         inventory.fixed = false;
         if(param1.canStack())
         {
            changeStat(param1.itemID,param1.getQuantity());
         }
         else
         {
            inventory.push(param1);
         }
         inventory.fixed = true;
         QueryManager.instance.reportDataModified(ITEM);
         return param1;
      }
      
      private static function addSpecialItemToQuestItems(param1:Item) : Item
      {
         questItems.fixed = false;
         if(param1.canStack())
         {
            changeStat(param1.itemID,param1.getQuantity());
         }
         else
         {
            questItems.push(param1);
         }
         questItems.fixed = true;
         QueryManager.instance.reportDataModified(QUESTITEM);
         return param1;
      }
      
      public static function removeItemFromInventory(param1:Item) : Boolean
      {
         if(param1.isQuestItem())
         {
            return removeSpecialItemFromQuestItems(param1);
         }
         return removeSpecialItemFromInventory(param1);
      }
      
      private static function removeSpecialItemFromInventory(param1:Item) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < inventory.length)
         {
            if(inventory[_loc3_].equals(param1))
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            param1 = inventory[_loc3_];
            if(param1.getQuantity() > 1)
            {
               param1.changeQuantity(-1);
            }
            else
            {
               inventory.fixed = false;
               inventory.splice(_loc3_,1);
               inventory.fixed = true;
            }
            QueryManager.instance.reportDataModified(ITEM);
         }
         return _loc2_;
      }
      
      private static function removeSpecialItemFromQuestItems(param1:Item) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < questItems.length)
         {
            if(questItems[_loc3_].equals(param1))
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            param1 = questItems[_loc3_];
            if(param1.getQuantity() > 1)
            {
               param1.changeQuantity(-1);
            }
            else
            {
               questItems.fixed = false;
               questItems.splice(_loc3_,1);
               questItems.fixed = true;
            }
            QueryManager.instance.reportDataModified(QUESTITEM);
         }
         return _loc2_;
      }
      
      public static function addItemToStash(param1:Item) : Item
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         stash.fixed = false;
         if(!param1.canStack())
         {
            stash.push(param1);
         }
         else
         {
            _loc2_ = false;
            _loc3_ = 0;
            while(_loc3_ < stash.length)
            {
               if(stash[_loc3_].itemID == param1.itemID)
               {
                  _loc2_ = true;
                  stash[_loc3_].changeQuantity(1);
                  break;
               }
               _loc3_++;
            }
            if(!_loc2_)
            {
               stash.push(new Item(param1.itemID));
            }
         }
         stash.fixed = true;
         QueryManager.instance.reportDataModified(STASH);
         return param1;
      }
      
      public static function removeItemFromStash(param1:Item) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < stash.length)
         {
            if(stash[_loc3_].equals(param1))
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            param1 = stash[_loc3_];
            if(param1.getQuantity() > 1)
            {
               param1.changeQuantity(-1);
            }
            else
            {
               stash.fixed = false;
               stash.splice(_loc3_,1);
               stash.fixed = true;
            }
            QueryManager.instance.reportDataModified(STASH);
         }
         return _loc2_;
      }
      
      public static function addGeneratedItemToInventory(param1:int, param2:int) : Item
      {
         var _loc3_:Item = ItemGenerator.instance.generateItem(param1,param2);
         inventory.fixed = false;
         inventory.push(_loc3_);
         inventory.fixed = true;
         QueryManager.instance.reportDataModified(ITEM);
         return _loc3_;
      }
      
      public static function updateWeaponUse(param1:int = 1) : *
      {
         equipment[EQ_WEAPON].gotUsed(param1);
         QueryManager.instance.reportDataModified(EQUIPMENT);
         if(equipment[EQ_WEAPON].isBroken())
         {
            trace("weapon broken");
         }
      }
      
      public static function repairEquippedWeapon(param1:int) : *
      {
         equipment[EQ_WEAPON].repair(param1);
         QueryManager.instance.reportDataModified(EQUIPMENT);
      }
      
      public static function breakEquippedWeapon() : *
      {
         equipment[EQ_WEAPON].breakWeapon();
         QueryManager.instance.reportDataModified(EQUIPMENT);
      }
      
      public static function getGold() : int
      {
         return getPlayerStats(STAT_GOLD);
      }
      
      internal static function getMaxCoins() : int
      {
         switch(getStat(1011))
         {
            case 0:
               return 1000;
            case 1:
               return 2000;
            case 2:
               return 4000;
            case 3:
               return 6000;
            case 4:
               return 8000;
            case 5:
               return 10000;
            default:
               return 1000;
         }
      }
      
      public static function isCoinPurseFull() : Boolean
      {
         return getPlayerStats(STAT_GOLD) >= getMaxCoins();
      }
      
      public static function changeGold(param1:int) : int
      {
         var _loc2_:int = getMaxCoins();
         var _loc3_:int = changeStat(11,param1);
         if(_loc3_ > _loc2_)
         {
            _loc3_ = setStat(11,_loc2_);
         }
         return _loc3_;
      }
      
      public static function getHeavenlyGold() : int
      {
         var _loc1_:int = getPlayerStats(STAT_HGOLD);
         if(usePlayerIO)
         {
            _loc1_ += QueryManagerPIO.instance.getPayVaultCoins();
         }
         return _loc1_;
      }
      
      public static function addHeavenlyGold(param1:int) : *
      {
         changeStat(STAT_HGOLD,param1);
      }
      
      private static function changeHeavenlyGold(param1:int, param2:Function, param3:Function) : *
      {
         var currentHGold:* = undefined;
         var deductgold:int = 0;
         var num:int = param1;
         var callbackSuccess:Function = param2;
         var callbackError:Function = param3;
         if(usePlayerIO)
         {
            currentHGold = getPlayerStats(STAT_HGOLD);
            if(num >= 0 || currentHGold >= -num)
            {
               changeStat(STAT_HGOLD,num);
               callbackSuccess();
            }
            else
            {
               deductgold = -num - currentHGold;
               QueryManagerPIO.instance.debitPayVaultCoins(deductgold,function():*
               {
                  setStat(STAT_HGOLD,0);
                  callbackSuccess();
               },callbackError);
            }
         }
         else
         {
            changeStat(STAT_HGOLD,num);
            callbackSuccess();
         }
      }
      
      public static function spendHeavenlyGold(param1:int, param2:Function, param3:Function) : *
      {
         if(!NetworkManager.instance.isGlobalPIOConnected())
         {
            param3();
            return;
         }
         if(getHeavenlyGold() >= param1)
         {
            changeHeavenlyGold(-param1,param2,param3);
            changeStat(STAT_CHIKAKOLOVE,param1);
            if(OverworldHUD.instance.interactUI.visible)
            {
               OverworldHUD.instance.interactUI.chikako.updateBar();
            }
         }
         else
         {
            param3();
         }
      }
      
      public static function increaseHP(param1:int) : *
      {
         setPlayerStats(STAT_HP,getPlayerStats(STAT_HP) + param1);
         var _loc2_:int = getPlayerStats(STAT_HP);
         var _loc3_:int = getPlayerStats(STAT_MAXHP) + findBonusStat(STAT_MAXHP);
         if(_loc2_ > _loc3_)
         {
            setPlayerStats(STAT_HP,_loc3_);
         }
         QueryManager.instance.reportDataModified(PLAYERSTAT);
         OverworldHUD.instance.updateHUD();
      }
      
      public static function increaseChi(param1:int) : *
      {
         setPlayerStats(STAT_CHI,getPlayerStats(STAT_CHI) + param1);
         var _loc2_:int = getPlayerStats(STAT_CHI);
         var _loc3_:int = getPlayerStats(STAT_MAXCHI) + findBonusStat(STAT_MAXCHI);
         if(_loc2_ > _loc3_)
         {
            setPlayerStats(STAT_CHI,_loc3_);
         }
         QueryManager.instance.reportDataModified(PLAYERSTAT);
         OverworldHUD.instance.updateHUD();
      }
      
      public static function getItemQty(param1:int) : int
      {
         if(param1 >= 2000 && param1 < 30000)
         {
            return getStat(param1);
         }
         trace("StatsManager.getItemQty: id out of range");
         return 0;
      }
      
      public static function changeItemQty(param1:int, param2:int) : int
      {
         if(param1 >= 2000 && param1 < 30000)
         {
            return changeStat(param1,param2);
         }
         trace("StatsManager.changeItemQty: id out of range");
         return 0;
      }
      
      public static function setItemQty(param1:int, param2:int) : *
      {
         if(param1 >= 2000 && param1 < 30000)
         {
            return setStat(param1,param2);
         }
         trace("StatsManager.setItemQty: id out of range");
         return 0;
      }
      
      public static function getReputation(param1:int) : int
      {
         return 100;
      }
      
      public static function getSide() : int
      {
         return getStat(STAT_SIDE);
      }
      
      public static function initCustomClan(param1:String, param2:int, param3:int, param4:int, param5:String, param6:String, param7:int) : *
      {
         customClanName = param1;
         customClanColor = param2;
         customClanLogoId = param3;
         customClanLogoColor = param4;
         customClanAcronym = param5;
         customClanFounder = param6;
         customClanOwned = param7;
      }
      
      public static function isCustomClanFounder() : Boolean
      {
         return charname == customClanFounder;
      }
      
      public static function getCustomClanName() : String
      {
         return customClanName;
      }
      
      public static function getCustomClanColor() : int
      {
         return customClanColor;
      }
      
      public static function getCustomClanAcronym() : String
      {
         return customClanAcronym;
      }
      
      public static function getCustomClanTextColor() : String
      {
         var _loc1_:String = getCustomClanColor().toString(16);
         while(_loc1_.length < 6)
         {
            _loc1_ = "0" + _loc1_;
         }
         return "#" + _loc1_;
      }
      
      public static function getCustomClanLogoId() : int
      {
         return customClanLogoId;
      }
      
      public static function getCustomClanLogoColor() : int
      {
         return customClanLogoColor;
      }
      
      public static function getCustomClanOwned() : int
      {
         return customClanOwned;
      }
      
      public static function getEnemyCustomClanColor() : int
      {
         return 3355443;
      }
      
      public static function getEnemyCustomClanTextColor() : String
      {
         return "#666666";
      }
      
      public static function isCustomClan(param1:int) : Boolean
      {
         return param1 >= 7;
      }
      
      public static function hasKey() : Boolean
      {
         return key > 0;
      }
      
      public static function addKey() : *
      {
         ++key;
      }
      
      public static function removeKey() : *
      {
         --key;
      }
      
      public static function removeAllKey() : *
      {
         key = 0;
      }
      
      public static function hasLever() : Boolean
      {
         return lever == 2;
      }
      
      public static function addLever() : *
      {
         ++lever;
      }
      
      public static function removeAllLever() : *
      {
         lever = 0;
      }
      
      public static function setBigMapShowing(param1:Boolean) : *
      {
         bigMapShowing = param1;
      }
      
      public static function getBigMapShowing() : Boolean
      {
         return bigMapShowing;
      }
      
      public static function setChatShowing(param1:Boolean) : *
      {
         chatShowing = param1;
      }
      
      public static function getChatShowing() : Boolean
      {
         return chatShowing;
      }
      
      internal static function getStatType(param1:int) : int
      {
         if(param1 < 50)
         {
            return PLAYERSTAT;
         }
         if(param1 < 70)
         {
            return EQUIPMENT;
         }
         if(param1 < 1000)
         {
            return PLAYERSTAT;
         }
         if(param1 < 2000)
         {
            return SKILL;
         }
         if(param1 < 20000)
         {
            return ITEM;
         }
         if(param1 < 30000)
         {
            return QUESTITEM;
         }
         if(param1 < 40000)
         {
            return INTSTAT;
         }
         if(param1 < 50000)
         {
            return BOOLEANSTAT;
         }
         if(param1 < 60000)
         {
            return GLOBALVAR;
         }
         return ACHIEVEMENTSTAT;
      }
      
      internal static function findSkillStat(param1:int) : IntStat
      {
         var _loc3_:IntStat = null;
         var _loc2_:int = int(skillStats.length);
         var _loc4_:int = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = skillStats[_loc4_];
            if(_loc3_.getId() == param1)
            {
               return _loc3_;
            }
            _loc4_--;
         }
         return null;
      }
      
      internal static function removeSkillStat(param1:IntStat) : *
      {
         var _loc2_:int = int(skillStats.length);
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            if(param1 == skillStats[_loc3_])
            {
               skillStats.fixed = false;
               skillStats.splice(_loc3_,1);
               skillStats.fixed = true;
               return;
            }
            _loc3_--;
         }
      }
      
      internal static function findInventoryItem(param1:int) : Item
      {
         var _loc3_:Item = null;
         var _loc2_:int = int(inventory.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = inventory[_loc4_];
            if(_loc3_.getItemID() == param1 && _loc3_.getModifierCount() == 0 && _loc3_.uses == 0)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public static function countItemType(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Item = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         if(param1 < 20000)
         {
            _loc3_ = int(inventory.length);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               if((_loc4_ = inventory[_loc5_]).getItemID() == param1)
               {
                  _loc2_ += _loc4_.getQuantity();
               }
               _loc5_++;
            }
         }
         else
         {
            _loc3_ = int(questItems.length);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               if((_loc4_ = questItems[_loc5_]).getItemID() == param1)
               {
                  _loc2_ += _loc4_.getQuantity();
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      internal static function findSpecialInventoryItem(param1:Item) : Item
      {
         var _loc2_:int = int(inventory.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(inventory[_loc3_].equals(param1))
            {
               return inventory[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      internal static function findSpecialQuestItem(param1:Item) : Item
      {
         var _loc2_:int = int(questItems.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(questItems[_loc3_].equals(param1))
            {
               return questItems[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      private static function spliceOutInventoryItem(param1:Item) : *
      {
         var _loc2_:int = int(inventory.length);
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            if(param1 == inventory[_loc3_])
            {
               inventory.fixed = false;
               inventory.splice(_loc3_,1);
               inventory.fixed = true;
               QueryManager.instance.reportDataModified(ITEM);
               return;
            }
            _loc3_--;
         }
      }
      
      internal static function findQuestItem(param1:int) : Item
      {
         var _loc3_:Item = null;
         var _loc2_:int = int(questItems.length);
         var _loc4_:int = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = questItems[_loc4_];
            if(_loc3_.getItemID() == param1)
            {
               return _loc3_;
            }
            _loc4_--;
         }
         return null;
      }
      
      private static function spliceOutQuestItem(param1:Item) : *
      {
         var _loc2_:int = int(questItems.length);
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            if(param1 == questItems[_loc3_])
            {
               questItems.fixed = false;
               questItems.splice(_loc3_,1);
               questItems.fixed = true;
               return;
            }
            _loc3_--;
         }
      }
      
      internal static function findIntStat(param1:int) : ObfusIntStat
      {
         var _loc3_:ObfusIntStat = null;
         var _loc2_:int = int(intStats.length);
         var _loc4_:int = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = intStats[_loc4_];
            if(_loc3_.getId() == param1)
            {
               return _loc3_;
            }
            _loc4_--;
         }
         return null;
      }
      
      internal static function removeIntStat(param1:ObfusIntStat) : *
      {
         var _loc2_:int = int(intStats.length);
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            if(param1 == intStats[_loc3_])
            {
               intStats.fixed = false;
               intStats.splice(_loc3_,1);
               intStats.fixed = true;
               return;
            }
            _loc3_--;
         }
      }
      
      internal static function findBooleanStat(param1:int) : BooleanStat
      {
         var _loc3_:BooleanStat = null;
         var _loc2_:int = int(booleanStats.length);
         var _loc4_:int = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = booleanStats[_loc4_];
            if(_loc3_.getId() == param1)
            {
               return _loc3_;
            }
            _loc4_--;
         }
         return null;
      }
      
      internal static function removeBooleanStat(param1:BooleanStat) : *
      {
         var _loc2_:int = int(booleanStats.length);
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            if(param1 == booleanStats[_loc3_])
            {
               booleanStats.fixed = false;
               booleanStats.splice(_loc3_,1);
               booleanStats.fixed = true;
               return;
            }
            _loc3_--;
         }
      }
      
      internal static function findAchievementStat(param1:int) : ObfusIntStat
      {
         var _loc3_:ObfusIntStat = null;
         var _loc2_:int = int(achievementStats.length);
         var _loc4_:int = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = achievementStats[_loc4_];
            if(_loc3_.getId() == param1)
            {
               return _loc3_;
            }
            _loc4_--;
         }
         return null;
      }
      
      internal static function removeAchievementStat(param1:ObfusIntStat) : *
      {
         var _loc2_:int = int(achievementStats.length);
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            if(param1 == achievementStats[_loc3_])
            {
               achievementStats.fixed = false;
               achievementStats.splice(_loc3_,1);
               achievementStats.fixed = true;
               return;
            }
            _loc3_--;
         }
      }
      
      public static function equipItem(param1:int, param2:Item) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param2.itemID < 20000 && param2.itemID > 2999)
         {
            QueryManager.instance.reportDataModified(EQUIPMENT);
            equipment[param1] = param2;
            if(param1 == 9)
            {
               equipment[10] = new Item(param2.itemID,1);
               setEquipment(10,param2.itemID,_loc3_,_loc4_);
            }
            _loc3_ = int(param2.getPrimaryColor());
            _loc4_ = param2.getSecondaryColor();
            setEquipment(param1,param2.itemID,_loc3_,_loc4_);
         }
         else
         {
            trace("not an equippable item");
         }
      }
      
      public static function removeEquipment(param1:int) : *
      {
         if(param1 == EQ_ARMOR && isFemale())
         {
            setEquipment(EQ_ARMOR,4001);
            equipment[EQ_ARMOR] = new Item(4001);
            setEquipment(EQ_NECK,10001);
            equipment[EQ_NECK] = new Item(10001);
         }
         else if(param1 == EQ_PANTS && isFemale())
         {
            setEquipment(EQ_PANTS,11001);
            equipment[EQ_PANTS] = new Item(11001);
         }
         else
         {
            setEquipment(param1,0);
            equipment[param1] = new Item(0);
            if(param1 == 9)
            {
               equipment[10] = new Item(0);
            }
         }
         QueryManager.instance.reportDataModified(EQUIPMENT);
      }
      
      public static function setEquipment(param1:int, param2:int, param3:int = 1, param4:int = 1) : *
      {
         var _loc5_:MCSCharacter = OverworldHUD.instance.inventoryUI.getInventoryPlayerImage();
         switch(param1)
         {
            case EQ_ARMOR:
               getPlayerMCS().setArmor(param2,param3,param4);
               _loc5_.setArmor(param2,param3,param4);
               getPlayerBust().setArmor(param2,param3,param4);
               break;
            case EQ_GLOVES:
               getPlayerMCS().setGloves(param2);
               _loc5_.setGloves(param2);
               break;
            case EQ_HAIR:
               getPlayerMCS().setHair(param2);
               _loc5_.setHair(param2);
               getPlayerBust().setHair(param2);
               break;
            case EQ_HAT:
               if(param2 == 7049)
               {
                  getPlayerMCS().setHat(0);
                  _loc5_.setHat(0);
                  getPlayerBust().setHat(0);
               }
               else
               {
                  getPlayerMCS().setHat(param2,param3,param4);
                  _loc5_.setHat(param2,param3,param4);
                  getPlayerBust().setHat(param2,param3,param4);
               }
               if(param2 == 0 || param2 == 7049)
               {
                  player.mcs.removeHat();
                  _loc5_.removeHat();
                  bust.setHair(equipment[EQ_HAIR].itemID);
               }
               else
               {
                  player.mcs.wearHat();
                  _loc5_.wearHat();
                  bust.setHair(6000);
               }
               break;
            case EQ_HEAD:
               getPlayerMCS().setHead(param2);
               _loc5_.setHead(param2);
               getPlayerBust().setHead(param2);
               break;
            case EQ_MASK:
               getPlayerMCS().setMask(param2,param3,param4);
               _loc5_.setMask(param2,param3,param4);
               getPlayerBust().setMask(param2,param3,param4);
               break;
            case EQ_NECK:
               getPlayerMCS().setNeck(param2);
               _loc5_.setNeck(param2);
               getPlayerBust().setNeck(param2);
               break;
            case EQ_PANTS:
               getPlayerMCS().setPants(param2,param3,param4);
               _loc5_.setPants(param2,param3,param4);
               break;
            case EQ_SHOES:
               getPlayerMCS().setShoes(param2);
               _loc5_.setShoes(param2);
               break;
            case EQ_WEAPON:
               getPlayerMCS().setWeapon(param2);
               _loc5_.setWeapon(param2);
               getPlayerMCS().setProp(param2);
               _loc5_.setProp(param2);
               break;
            case EQ_ACCESSORY1:
               getPlayerMCS().setProp2(param2);
               _loc5_.setProp2(param2);
         }
      }
      
      public static function setStat(param1:int, param2:int) : *
      {
         var _loc4_:IntStat = null;
         var _loc5_:Item = null;
         var _loc6_:Item = null;
         var _loc7_:ObfusIntStat = null;
         var _loc8_:ObfusIntStat = null;
         var _loc9_:BooleanStat = null;
         var _loc10_:XMLNpc = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc3_:* = getStatType(param1);
         QueryManager.instance.reportDataModified(_loc3_);
         switch(_loc3_)
         {
            case PLAYERSTAT:
               if(param1 == 91 || param1 == 92)
               {
                  if(param2 == -1)
                  {
                     QuestGenerator.instance.removeCurrentNPCQuestItem(param1 == 92);
                  }
                  else if(param2 == 1)
                  {
                     QuestGenerator.instance.addQuest(param1 == 92);
                  }
                  else if(param2 == 0)
                  {
                     QuestGenerator.instance.removeMarkedNode();
                  }
                  else if(param2 == 2)
                  {
                     QuestGenerator.instance.completeQuest(param1 == 92);
                  }
                  return;
               }
               if(param1 == 99)
               {
                  fullHealth();
                  return;
               }
               if(param1 == 100)
               {
                  if(param2 == 0)
                  {
                     autoSlash = false;
                  }
                  else
                  {
                     autoSlash = true;
                  }
                  return;
               }
               if(param1 == 102)
               {
                  OverworldHUD.instance.screenTransition.startClose(ScreenTransition.ACTION_TELEPORT);
                  return;
               }
               if(param1 == 107)
               {
                  OverworldHUD.instance.screenTransition.startClose(ScreenTransition.ACTION_NOTHINGCLOSE);
                  return;
               }
               if(param1 == 108)
               {
                  player.setPosition(param2,StageManager.getGroundY());
                  return;
               }
               if(param1 == 109)
               {
                  if(param2 == 0)
                  {
                     player.getMCS().setPose(MCSActor.SIT,0);
                  }
                  else if(param2 == 1)
                  {
                     player.getMCS().setPose(MCSActor.IDLE_BALANCED,0);
                  }
                  return;
               }
               if(param1 == 110)
               {
                  addActiveQuests(param2,true);
                  return;
               }
               if(param1 == 111)
               {
                  SoundManager.instance.playMusic(param2);
                  return;
               }
               if(param1 == 112)
               {
                  if(param2 == 0)
                  {
                     SoundManager.instance.playGoodKoto();
                  }
                  else if(param2 == 1)
                  {
                     SoundManager.instance.playDie();
                  }
                  else if(param2 == 2)
                  {
                     SoundManager.instance.playHit();
                  }
                  else if(param2 == 3)
                  {
                     SoundManager.instance.playDeflect();
                  }
                  return;
               }
               if(param1 == 113)
               {
                  OverworldHUD.instance.screenTransition.teleportTarget = param2;
                  OverworldHUD.instance.screenTransition.teleportXPos = 150;
                  OverworldHUD.instance.screenTransition.teleportRoom = 0;
                  return;
               }
               if(param1 == 114)
               {
                  OverworldHUD.instance.screenTransition.teleportRoom = param2;
                  return;
               }
               if(param1 == 115)
               {
                  OverworldHUD.instance.screenTransition.teleportXPos = param2;
                  return;
               }
               if(param1 == 116)
               {
                  StageManager.keepPlayerInView();
                  return;
               }
               if(param1 == 118)
               {
                  if((_loc10_ = QuestEngine.getNPCData(param2)) != null)
                  {
                     QuestEngine.putInDuelistHolder(param2,_loc10_.getMCSString(),_loc10_.lvl);
                     if((_loc11_ = Math.random() * 8) == 0)
                     {
                        _loc12_ = LangManager.getString(472);
                     }
                     else if(_loc11_ == 1)
                     {
                        _loc12_ = LangManager.getString(473);
                     }
                     else if(_loc11_ == 2)
                     {
                        _loc12_ = LangManager.getString(474);
                     }
                     else if(_loc11_ == 3)
                     {
                        _loc12_ = LangManager.getString(475);
                     }
                     else if(_loc11_ == 4)
                     {
                        _loc12_ = LangManager.getString(476);
                     }
                     else if(_loc11_ == 5)
                     {
                        _loc12_ = LangManager.getString(477);
                     }
                     else if(_loc11_ == 6)
                     {
                        _loc12_ = LangManager.getString(478);
                     }
                     else if(_loc11_ == 7)
                     {
                        _loc12_ = LangManager.getString(479);
                     }
                     DuelModeUI.instance.setOpponentTaunt(_loc12_);
                  }
                  return;
               }
               if(param1 == 119)
               {
                  OverworldHUD.instance.lootDialog.notifyDontRefreshAfter();
                  return;
               }
               if(param1 == 120)
               {
                  Overworld.doWhiteIn = true;
                  return;
               }
               if(param1 == 121)
               {
                  if(param2 == 0)
                  {
                     player.getMCS().faceLeft();
                  }
                  else
                  {
                     player.getMCS().faceRight();
                  }
                  return;
               }
               if(param1 == 126)
               {
                  StageManager.startShake(param2);
                  return;
               }
               if(param1 == 127)
               {
                  if(param2 == 0)
                  {
                     player.getMCS().visible = false;
                  }
                  else
                  {
                     player.getMCS().visible = true;
                  }
                  return;
               }
               if(param1 == 128)
               {
                  StageManager.gotoRoom(OverworldHUD.instance.screenTransition.teleportRoom,OverworldHUD.instance.screenTransition.teleportXPos,OverworldHUD.instance.screenTransition.teleportTarget);
                  OverworldHUD.instance.initForCutscene(true);
                  return;
               }
               if(param1 == 129)
               {
                  OverworldHUD.instance.payUI.show();
                  return;
               }
               if(param1 == 130)
               {
                  OverworldHUD.instance.questDialogueUI.darkBlurBust(param2);
                  return;
               }
               if(param1 == 39)
               {
                  param2 = QueryManager.instance.getServerTime() + param2;
               }
               setPlayerStats(param1,param2);
               if(param1 == STAT_MARKEDNODE)
               {
                  if(param2 == -1)
                  {
                     OverworldHUD.instance.setActiveQuestText("");
                  }
                  else
                  {
                     activeQuestList[param2].displayQuestTitleInNodeUI();
                  }
               }
               else if(param1 == STAT_LOCATION || param1 == STAT_LOCATION_ROOM)
               {
                  QueryManager.instance.reportDataModified(LOCATION);
                  QueryManager.instance.reportDataModified(PLAYERSTAT);
                  QueryManager.instance.saveModifiedCharData();
               }
               else if(param1 == STAT_SIDE)
               {
                  QueryManager.instance.reportDataModified(PLAYERSIDE);
                  QueryManager.instance.saveModifiedCharData();
               }
               else
               {
                  QueryManager.instance.reportDataModified(PLAYERSTAT);
               }
               break;
            case EQUIPMENT:
               trace("setStat does not manipulate Equipment");
               return 0;
            case SKILL:
               _loc4_ = findSkillStat(param1);
               if(param2 == 0)
               {
                  if(skillStats != null)
                  {
                     removeSkillStat(_loc4_);
                  }
               }
               else if(_loc4_ != null)
               {
                  _loc4_.setValue(param2);
               }
               else
               {
                  skillStats.fixed = false;
                  skillStats.push(new IntStat(param1,param2));
                  skillStats.fixed = true;
               }
               QueryManager.instance.reportDataModified(SKILL);
               break;
            case ITEM:
               _loc5_ = findInventoryItem(param1);
               if(param2 == 0)
               {
                  if(_loc5_ != null)
                  {
                     spliceOutInventoryItem(_loc5_);
                  }
               }
               else if(_loc5_ != null)
               {
                  _loc5_.setQuantity(param2);
               }
               else
               {
                  inventory.fixed = false;
                  inventory.push(new Item(param1,param2));
                  inventory.fixed = true;
               }
               QueryManager.instance.reportDataModified(ITEM);
               break;
            case QUESTITEM:
               _loc6_ = findQuestItem(param1);
               if(param2 == 0)
               {
                  if(_loc6_ != null)
                  {
                     spliceOutQuestItem(_loc6_);
                  }
               }
               else if(_loc6_ != null)
               {
                  _loc6_.setQuantity(param2);
               }
               else
               {
                  questItems.fixed = false;
                  questItems.push(new Item(param1,param2));
                  questItems.fixed = true;
               }
               QueryManager.instance.reportDataModified(QUESTITEM);
               break;
            case INTSTAT:
               if(param1 == 30017)
               {
                  TutorialUI.instance.setState(param2);
               }
               _loc7_ = findIntStat(param1);
               if(param2 == 0)
               {
                  if(_loc7_ != null)
                  {
                     removeIntStat(_loc7_);
                  }
               }
               else if(_loc7_ != null)
               {
                  _loc7_.setValue(param2);
               }
               else
               {
                  intStats.fixed = false;
                  intStats.push(new ObfusIntStat(param1,param2));
                  intStats.fixed = true;
               }
               QueryManager.instance.reportDataModified(INTSTAT);
               break;
            case ACHIEVEMENTSTAT:
               _loc8_ = findAchievementStat(param1);
               if(param2 == 0)
               {
                  if(_loc8_ != null)
                  {
                     removeAchievementStat(_loc8_);
                  }
               }
               else if(_loc8_ != null)
               {
                  _loc8_.setValue(param2);
               }
               else
               {
                  achievementStats.fixed = false;
                  achievementStats.push(new ObfusIntStat(param1,param2));
                  achievementStats.fixed = true;
               }
               QueryManager.instance.reportDataModified(ACHIEVEMENTSTAT);
               break;
            case BOOLEANSTAT:
               _loc9_ = findBooleanStat(param1);
               if(param2 == 0)
               {
                  if(_loc9_ != null)
                  {
                     removeBooleanStat(_loc9_);
                  }
               }
               else if(_loc9_ == null)
               {
                  booleanStats.fixed = false;
                  booleanStats.push(new BooleanStat(param1,true));
                  booleanStats.fixed = true;
               }
               QueryManager.instance.reportDataModified(BOOLEANSTAT);
               break;
            case GLOBALVAR:
               trace("cannot setStat() for GLOBALVAR");
         }
      }
      
      public static function changeStat(param1:int, param2:int) : int
      {
         var _loc4_:IntStat = null;
         var _loc5_:Item = null;
         var _loc6_:Item = null;
         var _loc7_:ObfusIntStat = null;
         var _loc8_:ObfusIntStat = null;
         var _loc9_:BooleanStat = null;
         var _loc3_:* = getStatType(param1);
         QueryManager.instance.reportDataModified(_loc3_);
         switch(_loc3_)
         {
            case PLAYERSTAT:
               if(param1 == STAT_LOCATION)
               {
                  setPlayerStats(param1,param2);
                  QueryManager.instance.reportDataModified(LOCATION);
                  QueryManager.instance.saveModifiedCharData();
               }
               else
               {
                  if(param1 == 91 || param1 == 92)
                  {
                     if(param2 == -1)
                     {
                        QuestGenerator.instance.removeCurrentNPCQuestItem(param1 == 92);
                     }
                     else if(param2 == 1)
                     {
                        QuestGenerator.instance.addQuest(param1 == 92);
                     }
                     else if(param2 == 0)
                     {
                        QuestGenerator.instance.removeMarkedNode();
                     }
                     else if(param2 == 2)
                     {
                        QuestGenerator.instance.completeQuest(param1 == 92);
                     }
                     return 0;
                  }
                  setPlayerStats(param1,getPlayerStats(param1) + param2);
                  QueryManager.instance.reportDataModified(PLAYERSTAT);
               }
               return getPlayerStats(param1);
            case EQUIPMENT:
               trace("setStat does not manipulate Equipment");
               return 0;
            case SKILL:
               QueryManager.instance.reportDataModified(SKILL);
               if((_loc4_ = findSkillStat(param1)) != null)
               {
                  _loc4_.changeValue(param2);
                  if(_loc4_.getValue() == 0)
                  {
                     removeSkillStat(_loc4_);
                     return 0;
                  }
                  return _loc4_.getValue();
               }
               if(param2 != 0)
               {
                  skillStats.fixed = false;
                  skillStats.push(new IntStat(param1,param2));
                  skillStats.fixed = true;
                  return param2;
               }
               break;
            case ITEM:
               QueryManager.instance.reportDataModified(ITEM);
               if((_loc5_ = findInventoryItem(param1)) != null)
               {
                  _loc5_.changeQuantity(param2);
                  if(_loc5_.getQuantity() <= 0)
                  {
                     spliceOutInventoryItem(_loc5_);
                     return 0;
                  }
                  return _loc5_.getQuantity();
               }
               if(param2 > 0)
               {
                  inventory.fixed = false;
                  inventory.push(new Item(param1,param2));
                  inventory.fixed = true;
                  return param2;
               }
               break;
            case QUESTITEM:
               QueryManager.instance.reportDataModified(QUESTITEM);
               if((_loc6_ = findQuestItem(param1)) != null)
               {
                  _loc6_.changeQuantity(param2);
                  if(_loc6_.getQuantity() <= 0)
                  {
                     spliceOutQuestItem(_loc6_);
                     return 0;
                  }
                  return _loc6_.getQuantity();
               }
               if(param2 > 0)
               {
                  questItems.fixed = false;
                  questItems.push(new Item(param1,param2));
                  questItems.fixed = true;
                  return param2;
               }
               break;
            case INTSTAT:
               QueryManager.instance.reportDataModified(INTSTAT);
               if((_loc7_ = findIntStat(param1)) != null)
               {
                  if(param1 == 30018)
                  {
                     _loc7_.setValue(QueryManager.instance.getServerTime() + param2);
                  }
                  else
                  {
                     _loc7_.changeValue(param2);
                  }
                  if(_loc7_.getValue() == 0)
                  {
                     removeIntStat(_loc7_);
                     return 0;
                  }
                  return _loc7_.getValue();
               }
               if(param2 != 0)
               {
                  intStats.fixed = false;
                  intStats.push(new ObfusIntStat(param1,param2));
                  intStats.fixed = true;
                  return param2;
               }
               break;
            case ACHIEVEMENTSTAT:
               QueryManager.instance.reportDataModified(ACHIEVEMENTSTAT);
               if((_loc8_ = findAchievementStat(param1)) != null)
               {
                  _loc8_.changeValue(param2);
                  if(_loc8_.getValue() == 0)
                  {
                     removeAchievementStat(_loc8_);
                     return 0;
                  }
                  return _loc8_.getValue();
               }
               if(param2 != 0)
               {
                  achievementStats.fixed = false;
                  achievementStats.push(new ObfusIntStat(param1,param2));
                  achievementStats.fixed = true;
                  return param2;
               }
               break;
            case BOOLEANSTAT:
               QueryManager.instance.reportDataModified(BOOLEANSTAT);
               _loc9_ = findBooleanStat(param1);
               if(param2 == 0)
               {
                  if(_loc9_ != null)
                  {
                     removeBooleanStat(_loc9_);
                  }
               }
               else if(_loc9_ == null)
               {
                  booleanStats.fixed = false;
                  booleanStats.push(new BooleanStat(param1,true));
                  booleanStats.fixed = true;
               }
               return param2;
            case GLOBALVAR:
               if(param1 == 50007)
               {
                  QueryManager.instance.updateTownProsperity(param2);
               }
               else
               {
                  QueryManager.instance.updateGlobalVar(param1,param2);
               }
               return 0;
         }
         if(param2 != 0)
         {
            trace("StatManager.changeStat error");
         }
         return 0;
      }
      
      public static function getStat(param1:int) : int
      {
         var _loc2_:IntStat = null;
         var _loc3_:Item = null;
         var _loc4_:Item = null;
         var _loc5_:ObfusIntStat = null;
         var _loc6_:ObfusIntStat = null;
         var _loc7_:BooleanStat = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         switch(getStatType(param1))
         {
            case PLAYERSTAT:
               if(param1 == 10)
               {
                  return getLevel();
               }
               if(param1 == 91 || param1 == 92)
               {
                  return QuestGenerator.instance.isReadyToTurnInQuest(param1 == 92);
               }
               if(param1 >= playerStats.length)
               {
                  return 0;
               }
               return getPlayerStats(param1);
               break;
            case EQUIPMENT:
               return equipment[param1 - 50].itemID;
            case SKILL:
               _loc2_ = findSkillStat(param1);
               if(_loc2_ != null)
               {
                  return _loc2_.getValue();
               }
               return 0;
               break;
            case ITEM:
               _loc3_ = findInventoryItem(param1);
               if(_loc3_ != null)
               {
                  return _loc3_.getQuantity();
               }
               return 0;
               break;
            case QUESTITEM:
               if((_loc4_ = findQuestItem(param1)) != null)
               {
                  return _loc4_.getQuantity();
               }
               return 0;
               break;
            case INTSTAT:
               if((_loc5_ = findIntStat(param1)) != null)
               {
                  return _loc5_.getValue();
               }
               return 0;
               break;
            case ACHIEVEMENTSTAT:
               if(param1 == 60001)
               {
                  return getWarRank();
               }
               if(param1 == 60022)
               {
                  _loc8_ = 0;
                  if(getStat(1005) > 0)
                  {
                     _loc8_++;
                  }
                  if(getStat(1006) > 0)
                  {
                     _loc8_++;
                  }
                  if(getStat(1042) > 0)
                  {
                     _loc8_++;
                  }
                  if(getStat(1043) > 0)
                  {
                     _loc8_++;
                  }
                  if(getStat(1044) > 0)
                  {
                     _loc8_++;
                  }
                  if(getStat(1045) > 0)
                  {
                     _loc8_++;
                  }
                  if(getStat(1046) > 0)
                  {
                     _loc8_++;
                  }
                  if(getStat(1047) > 0)
                  {
                     _loc8_++;
                  }
                  if(getStat(1048) > 0)
                  {
                     _loc8_++;
                  }
                  return _loc8_;
               }
               if(param1 == 60023)
               {
                  _loc9_ = 0;
                  if(getStat(1007) > 0)
                  {
                     _loc9_++;
                  }
                  if(getStat(1010) > 0)
                  {
                     _loc9_++;
                  }
                  if(getStat(1012) > 0)
                  {
                     _loc9_++;
                  }
                  if(getStat(1024) > 0)
                  {
                     _loc9_++;
                  }
                  if(getStat(1051) > 0)
                  {
                     _loc9_++;
                  }
                  if(getStat(1052) > 0)
                  {
                     _loc9_++;
                  }
                  if(getStat(1053) > 0)
                  {
                     _loc9_++;
                  }
                  if(getStat(1054) > 0)
                  {
                     _loc9_++;
                  }
                  if(getStat(1055) > 0)
                  {
                     _loc9_++;
                  }
                  return _loc9_;
               }
               if((_loc6_ = findAchievementStat(param1)) != null)
               {
                  return _loc6_.getValue();
               }
               return 0;
               break;
            case BOOLEANSTAT:
               if((_loc7_ = findBooleanStat(param1)) != null)
               {
                  if(_loc7_.getValue())
                  {
                     return 1;
                  }
                  return 0;
               }
               return 0;
               break;
            default:
               return 0;
         }
      }
      
      public static function upgradeMAXHP() : Boolean
      {
         changeStat(1,1);
         changeStat(18,-1);
         return true;
      }
      
      public static function upgradeHPREGEN() : Boolean
      {
         changeStat(2,1);
         changeStat(18,-1);
         return true;
      }
      
      public static function upgradeMAXCHI() : Boolean
      {
         changeStat(4,1);
         changeStat(18,-1);
         return true;
      }
      
      public static function upgradeCHIREGEN() : Boolean
      {
         changeStat(5,1);
         changeStat(18,-1);
         return true;
      }
      
      public static function upgradeATK() : Boolean
      {
         changeStat(6,1);
         changeStat(18,-1);
         return true;
      }
      
      public static function upgradeDEF() : Boolean
      {
         changeStat(7,1);
         changeStat(18,-1);
         return true;
      }
      
      public static function upgradeSPD() : Boolean
      {
         changeStat(8,1);
         changeStat(18,-1);
         return true;
      }
      
      public static function checkConditions(param1:XMLList) : Boolean
      {
         var _loc3_:String = null;
         var _loc6_:String = null;
         if(param1 == null)
         {
            return true;
         }
         if(param1.toString() == "1")
         {
            return true;
         }
         if(param1.toString() == "0")
         {
            return false;
         }
         var _loc2_:XMLList = param1.has;
         var _loc4_:int = _loc2_.length() - 1;
         while(_loc4_ >= 0)
         {
            if(_loc2_[_loc4_].comp.toString() == "")
            {
               _loc3_ = "gte";
            }
            else
            {
               _loc3_ = _loc2_[_loc4_].comp;
            }
            if(!checkCondition(_loc2_[_loc4_].id,_loc2_[_loc4_].qty,_loc3_))
            {
               return false;
            }
            _loc4_--;
         }
         var _loc5_:XMLList;
         _loc4_ = (_loc5_ = param1.completedquest).length() - 1;
         while(_loc4_ >= 0)
         {
            if((_loc6_ = _loc5_[_loc4_]).charAt(0) == "!")
            {
               _loc6_ = _loc6_.substr(1,_loc6_.length - 1);
               if(checkNotCompletedQuest(int(_loc6_)) == false)
               {
                  return false;
               }
            }
            else if(checkCompletedQuest(_loc5_[_loc4_]) == false)
            {
               return false;
            }
            _loc4_--;
         }
         var _loc7_:XMLList;
         if((_loc7_ = param1.activequest).length() == 0)
         {
            return true;
         }
         _loc4_ = _loc7_.length() - 1;
         while(_loc4_ >= 0)
         {
            if(checkActiveQuest(_loc7_[_loc4_]) == true)
            {
               return true;
            }
            _loc4_--;
         }
         return false;
      }
      
      public static function checkCondition(param1:int, param2:int, param3:String = "gte") : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(param3 == "rand")
         {
            return Math.random() * param1 <= param2;
         }
         if(param1 == STAT_LEVEL)
         {
            _loc4_ = getLevel();
         }
         else if(param1 >= 28 && param1 <= 31)
         {
            _loc4_ = getStat(param1);
         }
         else if(param1 == 30018)
         {
            if(getStat(30018) - QueryManager.instance.getServerTime() <= 0)
            {
               _loc4_ = 1;
            }
            else
            {
               _loc4_ = 0;
            }
         }
         else
         {
            if(param1 == 63)
            {
               _loc5_ = int(skillSlots.length);
               _loc6_ = false;
               _loc7_ = 0;
               while(_loc7_ < _loc5_)
               {
                  if(skillSlots[_loc7_] != null && skillSlots[_loc7_].getId() == param2)
                  {
                     _loc6_ = true;
                     break;
                  }
                  _loc7_++;
               }
               if(param3 == "eq")
               {
                  return _loc6_;
               }
               return !_loc6_;
            }
            if(param1 == 64)
            {
               if(param3 == "not")
               {
                  return !OverworldHUD.instance.playerPanelDisplay.isFriend;
               }
               return OverworldHUD.instance.playerPanelDisplay.isFriend;
            }
            if(param1 == 65)
            {
               return OverworldHUD.instance.playerPanelDisplay.facetoface;
            }
            _loc4_ = getStat(param1);
         }
         switch(param3)
         {
            case "eq":
               return _loc4_ == param2;
            case "gte":
               return _loc4_ >= param2;
            case "gt":
               return _loc4_ > param2;
            case "lt":
               return _loc4_ < param2;
            case "lte":
               return _loc4_ <= param2;
            case "not":
               return _loc4_ != param2;
            default:
               return false;
         }
      }
      
      public static function addCombo(param1:*) : *
      {
         combo += param1;
         if(combo > 999)
         {
            combo = 999;
         }
         BattleUI.instance.showCombo(combo);
      }
      
      public static function resetCombo() : *
      {
         combo = 0;
         BattleUI.instance.hideCombo();
      }
      
      public static function hasBuff(param1:int) : Boolean
      {
         if(param1 == BUFF_INJURED)
         {
            return getPlayerStats(STAT_BUFF2EXPIRY) > QueryManager.instance.getServerTime();
         }
         return getPlayerStats(STAT_BUFFTYPE) == param1 && getPlayerStats(STAT_BUFFEXPIRY) > QueryManager.instance.getServerTime();
      }
      
      public static function setBuff(param1:int, param2:int) : *
      {
         if(param1 == BUFF_INJURED)
         {
            setPlayerStats(STAT_BUFF2EXPIRY,QueryManager.instance.getServerTime() + param2);
         }
         else
         {
            if(hasBuff(BUFF_MODERATOR) && (param1 == BUFF_MUTE || param1 == BUFF_FULLMUTE))
            {
               return;
            }
            if((hasBuff(BUFF_MUTE) || hasBuff(BUFF_FULLMUTE) || hasBuff(BUFF_HELL) || hasBuff(BUFF_MODERATOR)) && param1 != BUFF_FULLMUTE && param1 != BUFF_HELL && param1 != BUFF_MODERATOR)
            {
               return;
            }
            setPlayerStats(STAT_BUFFTYPE,param1);
            setPlayerStats(STAT_BUFFEXPIRY,QueryManager.instance.getServerTime() + param2);
         }
         QueryManager.instance.reportDataModified(PLAYERSTAT);
         QueryManager.instance.saveModifiedCharData();
         StatsManager.setChatShowing(false);
      }
      
      public static function getPlayerLevelString() : String
      {
         return getLevel().toString();
      }
      
      public static function getPlayerDanString() : String
      {
         return getPlayerStats(STAT_DAN).toString();
      }
      
      public static function getLocationString() : String
      {
         return getPlayerStats(STAT_LOCATION).toString();
      }
      
      public static function getPlayerStatsString() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(playerStats.length);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc4_ == _loc2_ - 1)
            {
               _loc1_ += getPlayerStats(_loc4_).toString();
            }
            else
            {
               _loc1_ += getPlayerStats(_loc4_).toString() + "|";
            }
            _loc3_ += getPlayerStats(_loc4_);
            _loc4_++;
         }
         _loc3_ %= 54321;
         return _loc1_ + "|" + _loc3_.toString();
      }
      
      public static function parsePlayerStatsString(param1:String) : *
      {
         playerStats.fixed = false;
         playerStats = new Vector.<ObfuscatedObject>(playerStatsCount);
         populatePlayerStats(playerStats);
         var _loc2_:Array = param1.split("|");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length - 1)
         {
            setPlayerStats(_loc3_,_loc2_[_loc3_]);
            _loc3_++;
         }
         playerStats.fixed = true;
      }
      
      public static function getBattleStatsString() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(playerStats.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == STAT_HP || _loc3_ == STAT_MAXHP || _loc3_ == STAT_CHI || _loc3_ == STAT_MAXCHI || _loc3_ == STAT_ATTACK || _loc3_ == STAT_DEFENSE || _loc3_ == STAT_SPEED || _loc3_ == STAT_FIREATK || _loc3_ == STAT_WINDATK || _loc3_ == STAT_WATERATK || _loc3_ == STAT_EARTHATK || _loc3_ == STAT_BUFFTYPE || _loc3_ == STAT_BUFFEXPIRY || _loc3_ == STAT_BUFF2EXPIRY)
            {
               if(_loc3_ == STAT_BUFF2EXPIRY)
               {
                  _loc1_ += getPlayerStats(_loc3_).toString();
               }
               else
               {
                  _loc1_ += getPlayerStats(_loc3_).toString() + "|";
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function getEquipmentString() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(equipment.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += equipment[_loc3_].toStringNoQty();
            }
            else
            {
               _loc1_ += equipment[_loc3_].toStringNoQty() + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseEquipmentString(param1:String) : *
      {
         equipment.fixed = false;
         equipment.length = 0;
         var _loc2_:Array = param1.split("|");
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            equipment.push(Item.parseNoQty(_loc2_[_loc3_]));
            _loc3_++;
         }
         equipment.fixed = true;
      }
      
      public static function getSkillStatsString() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(skillStats.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += skillStats[_loc3_];
            }
            else
            {
               _loc1_ += skillStats[_loc3_] + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseSkillStatsString(param1:String) : *
      {
         var _loc2_:IntStat = null;
         skillStats.fixed = false;
         skillStats.length = 0;
         var _loc3_:Array = param1.split("|");
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = IntStat.parse(_loc3_[_loc4_]);
            if(_loc2_.getId() == SkillManager.SKILL_ROLL)
            {
               if(_loc2_.getValue() > 3)
               {
                  _loc2_.setValue(3);
               }
            }
            skillStats.push(_loc2_);
            _loc4_++;
         }
         skillStats.fixed = true;
      }
      
      public static function getSkillSlotsString() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(skillSlots.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(skillSlots[_loc3_] != null)
            {
               if(_loc3_ == _loc2_ - 1)
               {
                  _loc1_ += skillSlots[_loc3_];
               }
               else
               {
                  _loc1_ += skillSlots[_loc3_] + "|";
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseSkillSlotsString(param1:String) : *
      {
         skillSlots.fixed = false;
         skillSlots = new Vector.<IntStat>(8);
         var _loc2_:Array = param1.split("|");
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            skillSlots[_loc3_] = IntStat.parse(_loc2_[_loc3_]);
            _loc3_++;
         }
         skillSlots.fixed = true;
      }
      
      public static function getInventoryString() : String
      {
         if(inventory.length == 0)
         {
            return "-";
         }
         var _loc1_:String = "";
         var _loc2_:int = int(inventory.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += inventory[_loc3_];
            }
            else
            {
               _loc1_ += inventory[_loc3_] + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseInventoryString(param1:String) : *
      {
         if(param1 == "-")
         {
            inventory = new Vector.<Item>();
            return;
         }
         inventory.fixed = false;
         inventory.length = 0;
         var _loc2_:Array = param1.split("|");
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] != "")
            {
               inventory.push(Item.parse(_loc2_[_loc3_]));
            }
            _loc3_++;
         }
         inventory.fixed = true;
      }
      
      public static function getStashString() : String
      {
         if(stash.length == 0)
         {
            return "-";
         }
         var _loc1_:String = "";
         var _loc2_:int = int(stash.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += stash[_loc3_];
            }
            else
            {
               _loc1_ += stash[_loc3_] + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseStashString(param1:String) : *
      {
         if(param1 == "-")
         {
            stash = new Vector.<Item>();
            return;
         }
         stash.fixed = false;
         stash.length = 0;
         var _loc2_:Array = param1.split("|");
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] != "")
            {
               stash.push(Item.parse(_loc2_[_loc3_]));
            }
            _loc3_++;
         }
         stash.fixed = true;
      }
      
      public static function getOptionsString() : String
      {
         var _loc1_:* = "";
         if(SoundManager.instance.hasMusic)
         {
            _loc1_ += "1";
         }
         else
         {
            _loc1_ += "0";
         }
         if(SoundManager.instance.hasSound)
         {
            _loc1_ += "1";
         }
         else
         {
            _loc1_ += "0";
         }
         if(censored)
         {
            _loc1_ += "1";
         }
         else
         {
            _loc1_ += "0";
         }
         if(hasChatNotification)
         {
            _loc1_ += "1";
         }
         else
         {
            _loc1_ += "0";
         }
         if(recordDuels)
         {
            _loc1_ += "1";
         }
         else
         {
            _loc1_ += "0";
         }
         if(autoAssignStats)
         {
            _loc1_ += "1";
         }
         else
         {
            _loc1_ += "0";
         }
         if(showNinjaServant)
         {
            _loc1_ += "1";
         }
         else
         {
            _loc1_ += "0";
         }
         if(doFullScreen)
         {
            _loc1_ += "1";
         }
         else
         {
            _loc1_ += "0";
         }
         return _loc1_;
      }
      
      public static function parseOptionsString(param1:String) : *
      {
         if(param1.length == 7)
         {
            SoundManager.instance.hasMusic = param1.charAt(0) == "1";
            SoundManager.instance.hasSound = param1.charAt(1) == "1";
            censored = param1.charAt(2) == "1";
            hasChatNotification = param1.charAt(3) == "1";
            recordDuels = param1.charAt(4) == "1";
            autoAssignStats = param1.charAt(5) == "1";
            showNinjaServant = param1.charAt(6) == "1";
            doFullScreen = param1.charAt(7) == "1";
         }
         if(SoundManager.instance.hasMusic)
         {
            ResourceManager.loadMusicResource();
         }
         else
         {
            SoundManager.instance.stopMusic();
         }
         if(SoundManager.instance.hasSound)
         {
            ResourceManager.loadSoundResource();
         }
      }
      
      public static function parseGiftNotificationsString() : *
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc5_:Item = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:* = undefined;
         if(giftNotification == "")
         {
            return;
         }
         inventory.fixed = false;
         var _loc1_:Array = giftNotification.split("^");
         var _loc4_:Vector.<Item> = new Vector.<Item>();
         var _loc6_:* = 0;
         while(_loc6_ < _loc1_.length)
         {
            _loc2_ = _loc1_[_loc6_].split("$");
            _loc7_ = String(_loc2_[1]);
            _loc9_ = (_loc8_ = String(_loc2_[0])).split("|");
            _loc10_ = 0;
            while(_loc10_ < _loc9_.length)
            {
               _loc3_ = _loc9_[_loc10_].split(",");
               if(_loc3_[0] == "11")
               {
                  changeGold(_loc3_[1]);
                  OverworldHUD.instance.gotGiftDialog.addLootCoins(_loc3_[1]);
                  OverworldHUD.instance.gotGiftDialog.addGiver(_loc7_);
               }
               else if(_loc3_[0] == "12")
               {
                  addHeavenlyGold(_loc3_[1]);
                  OverworldHUD.instance.gotGiftDialog.addLootGold(_loc3_[1]);
                  OverworldHUD.instance.gotGiftDialog.addGiver(_loc7_);
               }
               else
               {
                  _loc5_ = Item.parseNoQty(_loc9_[_loc10_]);
                  _loc4_.push(_loc5_);
                  OverworldHUD.instance.gotGiftDialog.addLootItem(_loc5_);
                  OverworldHUD.instance.gotGiftDialog.addGiver(_loc7_);
               }
               _loc10_++;
            }
            _loc6_++;
         }
         OverworldHUD.instance.gotGiftDialog.storeGiftList(_loc4_);
         QueryManager.instance.saveModifiedCharData();
         if(GameEngine.isAdventureMode())
         {
            player.stopMoving();
         }
         OverworldHUD.instance.gotGiftDialog.show();
         giftNotification = "";
      }
      
      public static function getQuestItemsString() : String
      {
         if(questItems.length == 0)
         {
            return "-";
         }
         var _loc1_:String = "";
         var _loc2_:int = int(questItems.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += questItems[_loc3_];
            }
            else
            {
               _loc1_ += questItems[_loc3_] + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseQuestItemsString(param1:String) : *
      {
         var _loc3_:Item = null;
         if(param1 == "-")
         {
            questItems = new Vector.<Item>();
            return;
         }
         questItems.fixed = false;
         questItems.length = 0;
         var _loc2_:Array = param1.split("|");
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_] != "")
            {
               _loc3_ = Item.parse(_loc2_[_loc4_]);
               if(_loc3_.itemID >= 20000)
               {
                  questItems.push(_loc3_);
               }
            }
            _loc4_++;
         }
         questItems.fixed = true;
      }
      
      public static function getIntStatsString() : String
      {
         if(intStats.length == 0)
         {
            return "-";
         }
         var _loc1_:String = "";
         var _loc2_:int = int(intStats.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += intStats[_loc3_];
            }
            else
            {
               _loc1_ += intStats[_loc3_] + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseIntStatsString(param1:String) : *
      {
         if(param1 == "-")
         {
            intStats = new Vector.<ObfusIntStat>();
            return;
         }
         intStats.fixed = false;
         intStats.length = 0;
         var _loc2_:Array = param1.split("|");
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            intStats.push(ObfusIntStat.parse(_loc2_[_loc3_]));
            _loc3_++;
         }
         intStats.fixed = true;
      }
      
      public static function getBooleanStatsString() : String
      {
         if(booleanStats.length == 0)
         {
            return "-";
         }
         var _loc1_:String = "";
         var _loc2_:int = int(booleanStats.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += booleanStats[_loc3_];
            }
            else
            {
               _loc1_ += booleanStats[_loc3_] + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseBooleanStatsString(param1:String) : *
      {
         if(param1 == "-")
         {
            booleanStats = new Vector.<BooleanStat>();
            return;
         }
         booleanStats.fixed = false;
         booleanStats.length = 0;
         var _loc2_:Array = param1.split("|");
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            booleanStats.push(BooleanStat.parse(_loc2_[_loc3_]));
            _loc3_++;
         }
         booleanStats.fixed = true;
      }
      
      public static function getAchievementStatsString() : String
      {
         if(achievementStats.length == 0)
         {
            return "-";
         }
         var _loc1_:String = "";
         var _loc2_:int = int(achievementStats.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += achievementStats[_loc3_];
            }
            else
            {
               _loc1_ += achievementStats[_loc3_] + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseAchievementStatsString(param1:String) : *
      {
         if(param1 == "-")
         {
            achievementStats = new Vector.<ObfusIntStat>();
            return;
         }
         achievementStats.fixed = false;
         achievementStats.length = 0;
         var _loc2_:Array = param1.split("|");
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            achievementStats.push(ObfusIntStat.parse(_loc2_[_loc3_]));
            _loc3_++;
         }
         achievementStats.fixed = true;
      }
      
      public static function getActiveQuestString() : String
      {
         if(activeQuestList.length == 0)
         {
            return "-";
         }
         var _loc1_:String = "";
         var _loc2_:int = int(activeQuestList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += activeQuestList[_loc3_];
            }
            else
            {
               _loc1_ += activeQuestList[_loc3_] + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function setActiveQuestString(param1:String) : *
      {
         activeQuestStr = param1;
      }
      
      public static function parseActiveQuestString() : *
      {
         var _loc3_:ActiveQuest = null;
         var _loc1_:* = activeQuestStr;
         if(_loc1_ == "-")
         {
            activeQuestList = new Vector.<ActiveQuest>();
            return;
         }
         activeQuestList.fixed = false;
         activeQuestList.length = 0;
         var _loc2_:Array = _loc1_.split("|");
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = ActiveQuest.parse(_loc2_[_loc4_]);
            if(_loc3_ != null)
            {
               activeQuestList.push(_loc3_);
            }
            _loc4_++;
         }
         activeQuestList.fixed = true;
      }
      
      public static function getCompletedQuestString() : String
      {
         if(completedQuestList.length == 0)
         {
            return "-";
         }
         var _loc1_:String = "";
         var _loc2_:int = int(completedQuestList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ == _loc2_ - 1)
            {
               _loc1_ += completedQuestList[_loc3_].toString();
            }
            else
            {
               _loc1_ += completedQuestList[_loc3_].toString() + "|";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function parseCompletedQuestString(param1:String) : *
      {
         var _loc3_:CompletedQuest = null;
         if(param1 == "-")
         {
            completedQuestList = new Vector.<CompletedQuest>();
            return;
         }
         completedQuestList.fixed = false;
         completedQuestList.length = 0;
         var _loc2_:Array = param1.split("|");
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = CompletedQuest.parse(_loc2_[_loc4_]);
            if(_loc3_ != null)
            {
               completedQuestList.push(_loc3_);
            }
            _loc4_++;
         }
         completedQuestList.fixed = true;
      }
      
      public static function setTaunt(param1:String) : *
      {
         victoryTaunt = param1;
      }
      
      public static function getTaunt() : String
      {
         if(victoryTaunt != null)
         {
            victoryTaunt = victoryTaunt.split("&").join();
         }
         else
         {
            victoryTaunt = LangManager.getString(198);
         }
         return victoryTaunt;
      }
      
      public static function getFriendListString() : String
      {
         if(OverworldHUD.instance == null)
         {
            return "";
         }
         return OverworldHUD.instance.friendpanel.getFriendListStr();
      }
      
      public static function parseFriendListString(param1:String) : *
      {
         if(param1 == null || param1 == "" || param1 == "-")
         {
            friendList = "";
         }
         else
         {
            friendList = param1;
         }
         if(OverworldHUD.instance != null)
         {
            OverworldHUD.instance.friendpanel.init();
         }
      }
      
      public static function showKojuroAsPeddler() : Boolean
      {
         if(checkActiveQuest("20") && (checkActiveQuest("20,6") || checkActiveQuest("20,7") || checkActiveQuest("20,8")))
         {
            return false;
         }
         return !checkCompletedQuest(31);
      }
      
      public static function showChikakoAsNinja() : Boolean
      {
         return checkCompletedQuest(20);
      }
      
      public static function saveLocation(param1:int, param2:int = 0) : *
      {
         if(getPlayerStats(STAT_LOCATION) != param1)
         {
            setStat(STAT_LOCATION,param1);
            setStat(STAT_LOCATION_ROOM,param2);
         }
         else if(StageManager.getCurrentRoom() == param2 && getPlayerStats(STAT_LOCATION_ROOM) != param2)
         {
            setStat(STAT_LOCATION_ROOM,param2);
         }
      }
      
      public static function reportAchievementStat(param1:int, param2:int, param3:Boolean = false) : *
      {
         if(isKongregate)
         {
            Kongregate.instance.reportAchievementStat(param1,param2,param3);
         }
         var _loc4_:Array = QuestEngine.getAchievementCompletedArray();
         if(param3)
         {
            setStat(param1,param2);
         }
         else
         {
            changeStat(param1,param2);
         }
         QueryManager.instance.saveModifiedCharData();
         var _loc5_:Array = QuestEngine.getAchievementCompletedArray();
         var _loc6_:int;
         var _loc7_:int = (_loc6_ = int(_loc4_.length)) - 1;
         while(_loc7_ >= 0)
         {
            if(_loc4_[_loc7_] != _loc5_[_loc7_])
            {
               OverworldHUD.instance.showAchievementUnlocked(_loc7_);
               break;
            }
            _loc7_--;
         }
      }
      
      public static function getChatDisplayCharname() : String
      {
         var _loc1_:String = charname;
         var _loc2_:String = _loc1_.substr(0,1);
         var _loc3_:String = _loc1_.substr(1,_loc1_.length);
         return _loc2_.toUpperCase() + _loc3_;
      }
   }
}
