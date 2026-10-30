package
{
   import flash.errors.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.*;
   import flash.utils.Timer;
   
   public class QueryManagerBase
   {
      
      internal static var DATASLOTS:int = 20;
      
      public static var instance:QueryManagerBase;
       
      
      public var offlineMode:Boolean = false;
      
      public var loggedIn:Boolean = false;
      
      public var magicnum:int = 0;
      
      internal var username:String = "";
      
      internal var userid:String = "";
      
      internal var charstring:String = "";
      
      internal var lastUpdate:int = 0;
      
      internal var serverTime:int = 0;
      
      internal var serverDate:int = 0;
      
      internal var serverDateYesterday:int = 0;
      
      internal var serverTimerStarted:Boolean = false;
      
      internal var serverTimer:Timer;
      
      internal var dataModified:Vector.<Boolean>;
      
      internal var debug:Boolean = false;
      
      internal var server:String;
      
      internal var giveItemReceiver:String;
      
      internal var lastAPUpdate:int;
      
      internal var lastDTUpdate:int;
      
      internal var lastWarTurn:int;
      
      internal var hackReported:Boolean = false;
      
      internal var sessionID:int;
      
      public function QueryManagerBase()
      {
         this.serverTimer = new Timer(1000);
         this.dataModified = new Vector.<Boolean>(DATASLOTS);
         super();
      }
      
      internal function resetDataModified() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < DATASLOTS)
         {
            this.dataModified[_loc1_] = false;
            _loc1_++;
         }
      }
      
      internal function markAllDataModified() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < DATASLOTS)
         {
            this.dataModified[_loc1_] = true;
            _loc1_++;
         }
      }
      
      internal function reportDataModified(param1:int) : *
      {
         this.dataModified[param1] = true;
      }
      
      internal function saveLastUpdate(param1:String = "") : *
      {
         if(param1 != "")
         {
            this.lastUpdate = int(param1);
            this.serverTime = this.lastUpdate;
         }
         else
         {
            this.lastUpdate = this.serverTime;
            this.checkTimeSkip();
         }
         var _loc2_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         _loc2_.data.lastUpdate = this.lastUpdate;
         if(!this.serverTimerStarted)
         {
            this.serverTimerStarted = true;
            this.serverTimer.start();
            this.serverTimer.addEventListener(TimerEvent.TIMER,this.timerListener,false,0,true);
            this.serverDate = new Date(this.serverTime * 1000).getDate();
            this.serverDateYesterday = new Date(this.serverTime * 1000 - 24 * 60 * 60 * 1000).getDate();
         }
      }
      
      internal function timerListener(param1:TimerEvent) : void
      {
         this.serverTime += 1;
      }
      
      internal function checkTimeSkip() : *
      {
      }
      
      public function getServerTime() : int
      {
         if(this.serverTimerStarted)
         {
            return this.serverTime;
         }
         return 0;
      }
      
      public function getServerDate() : int
      {
         return this.serverDate;
      }
      
      public function getServerDateYesterday() : int
      {
         return this.serverDateYesterday;
      }
      
      public function login(param1:String, param2:String) : *
      {
         var _loc3_:URLRequest = null;
         var _loc4_:URLLoader = null;
         var _loc5_:URLVariables = null;
         this.username = param1;
         if(!this.offlineMode)
         {
            _loc3_ = new URLRequest(this.server + "login_internal.php");
            (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
            (_loc5_ = new URLVariables()).username = param1;
            _loc5_.password = param2;
            _loc5_.lang = LangManager.getLanguage();
            _loc5_.ver = StatsManager.clientVersion;
            if(StatsManager.impersonateUser)
            {
               _loc5_.impers = "onate";
            }
            if(this.debug)
            {
               _loc5_.debug = 1;
            }
            _loc3_.data = _loc5_;
            _loc3_.method = URLRequestMethod.POST;
            _loc4_.addEventListener(Event.COMPLETE,this.loginComplete,false,0,true);
            _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.loginIOError,false,0,true);
            _loc4_.load(_loc3_);
         }
         else
         {
            this.loggedIn = true;
            this.username = "Guest";
            this.charstring = "";
            TitleUI.instance.login.serverResponse(0);
            this.saveLastUpdate("1000000");
            NetworkManager.getInstance();
         }
      }
      
      public function checkExternalLogin() : *
      {
         var _loc1_:URLRequest = null;
         var _loc2_:URLLoader = null;
         var _loc3_:URLVariables = null;
         if(!this.offlineMode)
         {
            _loc1_ = new URLRequest(this.server + "login_external.php");
            _loc2_ = new URLLoader();
            _loc2_.dataFormat = URLLoaderDataFormat.VARIABLES;
            _loc3_ = new URLVariables();
            _loc3_.ver = StatsManager.clientVersion;
            _loc3_.lang = LangManager.getLanguage();
            if(this.debug)
            {
               _loc3_.debug = 1;
            }
            _loc1_.data = _loc3_;
            _loc1_.method = URLRequestMethod.POST;
            _loc2_.addEventListener(Event.COMPLETE,this.loginComplete,false,0,true);
            _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.loginIOError,false,0,true);
            _loc2_.load(_loc1_);
         }
      }
      
      public function hasFlashVars() : Boolean
      {
         if(!StatsManager.useFlashVarsLogin)
         {
            return false;
         }
         var _loc1_:Object = GameEngine.getLoaderInfo(StatsManager.mainTimeLine).parameters;
         return _loc1_.username;
      }
      
      public function checkFlashVarsLogin() : *
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLLoader = null;
         var _loc4_:URLVariables = null;
         var _loc1_:Object = GameEngine.getLoaderInfo(StatsManager.mainTimeLine).parameters;
         if(!_loc1_.username)
         {
            trace("no flash vars");
            TitleUI.instance.login.serverResponse(6);
            return;
         }
         if(_loc1_.facebookid)
         {
            StatsManager.facebookid = _loc1_.facebookid;
         }
         if(_loc1_.fbfriends)
         {
            StatsManager.facebookFriends = _loc1_.fbfriends;
         }
         if(!this.offlineMode)
         {
            _loc2_ = new URLRequest(this.server + "login_flashvars.php");
            _loc3_ = new URLLoader();
            _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
            (_loc4_ = new URLVariables()).username = _loc1_.username;
            _loc4_.userid = _loc1_.userid;
            _loc4_.ver = StatsManager.clientVersion;
            _loc4_.lang = LangManager.getLanguage();
            if(this.debug)
            {
               _loc4_.debug = 1;
            }
            _loc2_.data = _loc4_;
            _loc2_.method = URLRequestMethod.POST;
            _loc3_.addEventListener(Event.COMPLETE,this.loginComplete,false,0,true);
            _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.loginIOError,false,0,true);
            _loc3_.load(_loc2_);
         }
      }
      
      internal function loginComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("password ok");
               this.magicnum = _loc3_.magicnum;
               this.loggedIn = true;
               this.charstring = _loc3_.chars;
               if(_loc3_.username != null && _loc3_.username != "")
               {
                  this.username = _loc3_.username;
               }
               this.userid = _loc3_.id;
               TitleUI.instance.showMOTD(_loc3_.motd);
               if(StatsManager.useCirrus && !NetworkManager.getInstance().connected)
               {
                  NetworkManager.getInstance();
               }
               else
               {
                  TitleUI.instance.login.serverResponse(0);
               }
               break;
            case "1":
               trace("login error a");
               if(StatsManager.useExternalLogin || StatsManager.useFlashVarsLogin)
               {
                  TitleUI.instance.login.serverResponse(5);
               }
               else
               {
                  TitleUI.instance.login.serverResponse(1);
               }
               break;
            case "2":
               trace("user not verified");
               if(StatsManager.useExternalLogin || StatsManager.useFlashVarsLogin)
               {
                  return;
               }
               TitleUI.instance.login.serverResponse(2);
               break;
            case "4":
               trace("update game client");
               TitleUI.instance.login.serverResponse(4);
               break;
            case "5":
               trace("flash vars error");
               TitleUI.instance.login.serverResponse(5);
         }
      }
      
      internal function loginIOError(param1:IOErrorEvent) : void
      {
         trace("login IO error");
         if(!TitleUI.instance.login.visible)
         {
            TitleUI.instance.switchToLogin();
         }
         TitleUI.instance.login.serverResponse(3);
      }
      
      public function logout() : *
      {
         var _loc1_:URLRequest = null;
         var _loc2_:URLLoader = null;
         var _loc3_:URLVariables = null;
         if(!this.offlineMode)
         {
            _loc1_ = new URLRequest(this.server + "logout.php");
            _loc2_ = new URLLoader();
            _loc2_.dataFormat = URLLoaderDataFormat.VARIABLES;
            _loc3_ = new URLVariables();
            _loc3_.charname = StatsManager.charname;
            _loc1_.data = _loc3_;
            _loc1_.method = URLRequestMethod.POST;
            _loc2_.load(_loc1_);
         }
         this.clearAutoLogin();
         this.loggedIn = false;
      }
      
      public function registerUser(param1:String, param2:String, param3:String, param4:String = "") : *
      {
         var _loc5_:URLRequest = new URLRequest(this.server + "registeruser.php");
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc7_:URLVariables;
         (_loc7_ = new URLVariables()).username = param1;
         _loc7_.password = param2;
         _loc7_.email = param3;
         _loc7_.facebookid = param4;
         if(this.debug)
         {
            _loc7_.debug = 1;
         }
         _loc5_.data = _loc7_;
         _loc5_.method = URLRequestMethod.POST;
         _loc6_.addEventListener(Event.COMPLETE,this.registerComplete,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.registerIOError,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      internal function registerComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         switch(_loc3_.status)
         {
            case "0":
               trace("register ok");
               TitleUI.instance.register.serverResponse(0);
               break;
            case "1":
               trace("username exists");
               TitleUI.instance.register.serverResponse(1);
               break;
            case "2":
               trace("email exists");
               TitleUI.instance.register.serverResponse(2);
               break;
            case "3":
               trace("facebookid exists");
               TitleUI.instance.register.serverResponse(3);
               break;
            case "4":
               trace("sql error");
               TitleUI.instance.register.serverResponse(4);
         }
      }
      
      internal function registerIOError(param1:IOErrorEvent) : void
      {
         trace("register IO error");
         TitleUI.instance.register.serverResponse(5);
      }
      
      public function getEmail(param1:String) : *
      {
         var _loc2_:URLRequest = new URLRequest(this.server + "getemail.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).id = param1;
         if(this.debug)
         {
            _loc4_.debug = 1;
         }
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.getEmailComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.getEmailIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function getEmailComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         switch(_loc3_.status)
         {
            case "0":
               trace("get email ok");
               TitleUI.instance.edit.gotEmail(_loc3_.email);
               break;
            case "1":
               trace("username does not exist");
               TitleUI.instance.edit.back(null);
         }
      }
      
      internal function getEmailIOError(param1:IOErrorEvent) : void
      {
         trace("get email IO error");
         TitleUI.instance.edit.back(null);
      }
      
      public function editUser(param1:String, param2:String, param3:String) : *
      {
         var _loc4_:URLRequest = new URLRequest(this.server + "edituser.php");
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc6_:URLVariables;
         (_loc6_ = new URLVariables()).username = param1;
         _loc6_.password = param2;
         _loc6_.email = param3;
         _loc6_.debug = 1;
         _loc4_.data = _loc6_;
         _loc4_.method = URLRequestMethod.POST;
         _loc5_.addEventListener(Event.COMPLETE,this.editUserComplete,false,0,true);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.editUserIOError,false,0,true);
         _loc5_.load(_loc4_);
      }
      
      internal function editUserComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         trace(_loc3_.debug);
         switch(_loc3_.status)
         {
            case "0":
               trace("register ok");
               TitleUI.instance.edit.serverResponse(0);
               break;
            case "1":
               trace("username exists");
               TitleUI.instance.edit.serverResponse(1);
               break;
            case "2":
               trace("email exists");
               TitleUI.instance.edit.serverResponse(2);
               break;
            case "3":
               trace("facebookid exists");
               TitleUI.instance.edit.serverResponse(3);
               break;
            case "4":
               trace("sql error");
               TitleUI.instance.edit.serverResponse(4);
         }
      }
      
      internal function editUserIOError(param1:IOErrorEvent) : void
      {
         trace("edit user IO error");
         TitleUI.instance.edit.serverResponse(5);
      }
      
      public function sendVerify(param1:String) : *
      {
         var _loc2_:URLRequest = new URLRequest(this.server + "sendverify.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).email = param1;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.sendVerifyComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.sendVerifyIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function sendVerifyComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         switch(_loc3_.status)
         {
            case "0":
               trace("resend ok");
               TitleUI.instance.resend.serverResponse(0);
               break;
            case "1":
               trace("did not enter correct username/password");
               TitleUI.instance.resend.serverResponse(1);
               break;
            case "2":
               trace("user does not exist");
               TitleUI.instance.resend.serverResponse(2);
         }
      }
      
      internal function sendVerifyIOError(param1:IOErrorEvent) : void
      {
         trace("sendVerify IO error");
         TitleUI.instance.resend.serverResponse(3);
      }
      
      public function createCharacter(param1:String) : *
      {
         if(this.offlineMode)
         {
            this.saveAllCharData();
            this.saveCharName();
            this.charstring = param1 + ",1";
            TitleUI.instance.charcreate.serverResponse(0);
            return;
         }
         var _loc2_:URLRequest = new URLRequest(this.server + "createcharacter.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).charname = param1;
         _loc4_.magicnum = this.magicnum;
         _loc4_.stratusid = "12345";
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.createCharacterComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.createCharacterIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function createCharacterComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("character created");
               this.saveAllCharData();
               this.charstring = _loc3_.chars;
               TitleUI.instance.charcreate.serverResponse(0);
               break;
            case "1":
               trace("not logged in");
               TitleUI.instance.charcreate.serverResponse(1);
               break;
            case "2":
               trace("wrong magic number");
               TitleUI.instance.charcreate.serverResponse(2);
               break;
            case "3":
               trace("charname exists");
               TitleUI.instance.charcreate.serverResponse(3);
               break;
            case "4":
               trace("sql error");
               TitleUI.instance.charcreate.serverResponse(4);
         }
      }
      
      internal function createCharacterIOError(param1:IOErrorEvent) : void
      {
         trace("sendVerify IO error");
         TitleUI.instance.charcreate.serverResponse(5);
      }
      
      public function deleteCharacter(param1:String) : *
      {
         this.deleteCharCookieData(param1);
         if(this.offlineMode)
         {
            this.clearCharName();
            this.charstring = "";
            TitleUI.instance.charselect.chardeleteform.serverResponse(0);
            return;
         }
         var _loc2_:URLRequest = new URLRequest(this.server + "deletecharacter.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).charname = param1;
         _loc4_.magicnum = this.magicnum;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.deleteCharacterComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.deleteCharacterIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function deleteCharacterComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("character deleted");
               this.charstring = _loc3_.chars;
               TitleUI.instance.charselect.chardeleteform.serverResponse(0);
               break;
            case "1":
               trace("not logged in");
               TitleUI.instance.charselect.chardeleteform.serverResponse(1);
               break;
            case "2":
               trace("wrong magic number");
               TitleUI.instance.charselect.chardeleteform.serverResponse(2);
               break;
            case "3":
               trace("sql error");
               TitleUI.instance.charselect.chardeleteform.serverResponse(3);
         }
      }
      
      internal function deleteCharacterIOError(param1:IOErrorEvent) : void
      {
         trace("deleteCharacter IO error");
         TitleUI.instance.charselect.chardeleteform.serverResponse(4);
      }
      
      public function whoIsHere(param1:int) : *
      {
         var _loc2_:URLRequest = new URLRequest(this.server + "whoishere.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).node = param1.toString();
         _loc4_.magicnum = this.magicnum;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.whoIsHereComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.whoIsHereIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function whoIsHereComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("whoishere: " + _loc3_.chars);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function whoIsHereIOError(param1:IOErrorEvent) : void
      {
         trace("whoIsHere IO error");
      }
      
      public function getOpponents() : *
      {
         if(this.offlineMode)
         {
            DuelModeUI.instance.setDuelList("");
            return;
         }
         var _loc1_:URLRequest = new URLRequest(this.server + "getopponents.php");
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.charname = StatsManager.charname;
         _loc3_.lvl = StatsManager.getPlayerLevelString();
         _loc3_.magicnum = this.magicnum;
         if(this.debug)
         {
            _loc3_.debug = 1;
         }
         _loc1_.data = _loc3_;
         _loc1_.method = URLRequestMethod.POST;
         _loc2_.addEventListener(Event.COMPLETE,this.getOpponentsComplete,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.getOpponentsIOError,false,0,true);
         _loc2_.load(_loc1_);
      }
      
      internal function getOpponentsComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               DuelModeUI.instance.setDuelList(_loc3_.chars);
               break;
            case "1":
               trace("not logged in");
               DuelModeUI.instance.onLeave(null);
               break;
            case "2":
               trace("incorrect magic number");
               DuelModeUI.instance.onLeave(null);
         }
      }
      
      internal function getOpponentsIOError(param1:IOErrorEvent) : void
      {
         trace("getOpponents IO error");
         DuelModeUI.instance.onLeave(null);
      }
      
      public function getOpponentData(param1:String) : *
      {
         var _loc2_:URLRequest = new URLRequest(this.server + "getopponentdata.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).charname = param1;
         _loc4_.magicnum = this.magicnum;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.getOpponentDataComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.getOpponentDataIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function getOpponentDataComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               DuelModeUI.instance.gotOpponentData(_loc3_.playerstats,_loc3_.skillstats,_loc3_.stratusid,int(_loc3_.lastping),_loc3_.taunt);
               break;
            case "1":
               trace("not logged in");
               DuelModeUI.instance.onLeave(null);
               break;
            case "2":
               trace("incorrect magic number");
               DuelModeUI.instance.onLeave(null);
         }
      }
      
      internal function getOpponentDataIOError(param1:IOErrorEvent) : void
      {
         trace("getOpponentData IO error");
         DuelModeUI.instance.onLeave(null);
      }
      
      public function getLeaderboards(param1:int = 0, param2:Boolean = false) : *
      {
         var _loc3_:URLRequest = new URLRequest(this.server + "getleaderboards.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).page = param1;
         _loc5_.magicnum = this.magicnum;
         if(param2)
         {
            _loc5_.weekly = "1";
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.getLeaderboardsComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.getLeaderboardsIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function getLeaderboardsComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               if(GameEngine.isTitle())
               {
                  LeaderboardUI.instance.setLeaderboard(_loc3_.chars);
               }
               else
               {
                  DuelModeUI.instance.setLeaderboard(_loc3_.chars);
               }
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getLeaderboardsIOError(param1:IOErrorEvent) : void
      {
         trace("getLeaderboards IO error");
         if(GameEngine.isTitle())
         {
            LeaderboardUI.instance.ioError();
         }
         else
         {
            DuelModeUI.instance.ioError();
         }
      }
      
      public function giveItem(param1:String, param2:String, param3:String, param4:int) : *
      {
         if(param3 == "" && param4 == 0)
         {
            return;
         }
         var _loc5_:URLRequest = new URLRequest(this.server + "giveitem.php");
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc7_:URLVariables;
         (_loc7_ = new URLVariables()).receiver = param1;
         _loc7_.giver = param2;
         _loc7_.items = param3;
         _loc7_.coins = param4;
         _loc7_.magicnum = this.magicnum;
         this.giveItemReceiver = param1;
         _loc5_.data = _loc7_;
         _loc5_.method = URLRequestMethod.POST;
         _loc6_.addEventListener(Event.COMPLETE,this.giveItemComplete,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.giveItemIOError,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      internal function giveItemComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("give ok");
               NetworkManager.instance.globalCheckNotification(this.giveItemReceiver);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
               break;
            case "3":
               trace("giving nothing");
         }
      }
      
      internal function giveItemIOError(param1:IOErrorEvent) : void
      {
         trace("giveItem IO error");
      }
      
      public function checkNotifications() : *
      {
         var _loc1_:URLRequest = new URLRequest(this.server + "getnotifications.php");
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.magicnum = this.magicnum;
         _loc3_.charname = StatsManager.charname;
         _loc1_.data = _loc3_;
         _loc1_.method = URLRequestMethod.POST;
         _loc2_.addEventListener(Event.COMPLETE,this.checkNotificationsComplete,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.checkNotificationsIOError,false,0,true);
         _loc2_.load(_loc1_);
      }
      
      internal function checkNotificationsComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("check notifications ok");
               if(StatsManager.giftNotification == "")
               {
                  StatsManager.giftNotification = _loc3_.notif;
               }
               else
               {
                  StatsManager.giftNotification = StatsManager.giftNotification + "^" + _loc3_.notif;
               }
               if(GameEngine.isAdventureMode() && !OverworldHUD.instance.duelmodeUI.visible && !OverworldHUD.instance.warUI.visible)
               {
                  StatsManager.parseGiftNotificationsString();
               }
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function checkNotificationsIOError(param1:IOErrorEvent) : void
      {
         trace("check notifications IO error");
      }
      
      public function duelEnd(param1:String, param2:String) : *
      {
         var _loc3_:URLRequest = new URLRequest(this.server + "duelend.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).winner = param1;
         _loc5_.loser = param2;
         _loc5_.magicnum = this.magicnum;
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.duelEndComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.duelEndIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function duelEndComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("duel results submitted");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function duelEndIOError(param1:IOErrorEvent) : void
      {
         trace("duelEnd IO error");
      }
      
      public function getClanMemberCount() : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc1_:URLRequest = new URLRequest(this.server + "/war/getclanmembercount.php");
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.magicnum = this.magicnum;
         if(this.debug)
         {
            _loc3_.debug = 1;
         }
         _loc1_.data = _loc3_;
         _loc1_.method = URLRequestMethod.POST;
         _loc2_.addEventListener(Event.COMPLETE,this.getClanMemberCountComplete,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.getClanMemberCountIOError,false,0,true);
         _loc2_.load(_loc1_);
      }
      
      internal function getClanMemberCountComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get war maps complete");
               OverworldHUD.instance.warUI.warChooseUI.gotClanMemberCount(_loc3_.red,_loc3_.green,_loc3_.blue,_loc3_.yellow);
               break;
            case "1":
               trace("not logged in");
               OverworldHUD.instance.warUI.loading.visible = false;
               break;
            case "2":
               trace("incorrect magic number");
               OverworldHUD.instance.warUI.loading.visible = false;
         }
      }
      
      internal function getClanMemberCountIOError(param1:IOErrorEvent) : void
      {
         trace("Error get clan member count.");
         OverworldHUD.instance.warUI.loading.visible = false;
      }
      
      public function getWarMaps(param1:int, param2:Boolean = true) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "/war/getwarmaps.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).magicnum = this.magicnum;
         _loc5_.charid = StatsManager.id;
         _loc5_.side = param1;
         if(param2)
         {
            _loc5_.getworld = 1;
         }
         else
         {
            _loc5_.getworld = 0;
         }
         if(this.debug)
         {
            _loc5_.debug = 1;
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.getWarMapsComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.getWarMapsIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function getWarMapsComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get war maps complete");
               OverworldHUD.instance.warUI.initWarMarkers(_loc3_.maps,_loc3_.sentry,_loc3_.activebattles,_loc3_.nextupdate,_loc3_.maintenance);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getWarMapsIOError(param1:IOErrorEvent) : void
      {
         trace("Error get war maps.");
      }
      
      public function getWarHexMap(param1:int, param2:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "/war/getwarhex.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).magicnum = this.magicnum;
         _loc5_.map = param1;
         _loc5_.side = param2;
         if(this.debug)
         {
            _loc5_.debug = 1;
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.getWarHexMapComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.getWarHexMapIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function getWarHexMapComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get war hex map complete");
               OverworldHUD.instance.warUI.initWarHexMap(_loc3_.hex,_loc3_.tdata);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getWarHexMapIOError(param1:IOErrorEvent) : void
      {
         trace("Error get war hex map.");
      }
      
      public function getWarMessage(param1:int, param2:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "/war/warmessage.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).magicnum = this.magicnum;
         _loc5_.map = param1;
         _loc5_.side = param2;
         _loc5_.op = "get";
         if(this.debug)
         {
            _loc5_.debug = 1;
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.getWarMessageComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.getWarMessageIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function getWarMessageComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get war message complete");
               OverworldHUD.instance.warUI.warHexUI.initMessages(_loc3_.msg);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getWarMessageIOError(param1:IOErrorEvent) : void
      {
         trace("Error get war message.");
      }
      
      public function addWarMessage(param1:int, param2:int, param3:int, param4:String, param5:String) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc6_:URLRequest = new URLRequest(this.server + "/war/warmessage.php");
         var _loc7_:URLLoader;
         (_loc7_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc8_:URLVariables;
         (_loc8_ = new URLVariables()).magicnum = this.magicnum;
         _loc8_.map = param1;
         _loc8_.side = param2;
         _loc8_.charside = param3;
         _loc8_.charname = param4;
         _loc8_.msg = param5;
         _loc8_.op = "add";
         if(this.debug)
         {
            _loc8_.debug = 1;
         }
         _loc6_.data = _loc8_;
         _loc6_.method = URLRequestMethod.POST;
         _loc7_.addEventListener(Event.COMPLETE,this.addWarMessageComplete,false,0,true);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,this.addWarMessageIOError,false,0,true);
         _loc7_.load(_loc6_);
      }
      
      internal function addWarMessageComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("add war message complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function addWarMessageIOError(param1:IOErrorEvent) : void
      {
         trace("Error add war message.");
      }
      
      public function getWarHexData(param1:int, param2:int, param3:int, param4:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc5_:URLRequest = new URLRequest(this.server + "/war/getwarhexdata.php");
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc7_:URLVariables;
         (_loc7_ = new URLVariables()).magicnum = this.magicnum;
         _loc7_.map = param1;
         _loc7_.x = param2;
         _loc7_.y = param3;
         _loc7_.side = param4;
         if(this.debug)
         {
            _loc7_.debug = 1;
         }
         _loc5_.data = _loc7_;
         _loc5_.method = URLRequestMethod.POST;
         _loc6_.addEventListener(Event.COMPLETE,this.getWarHexDataComplete,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.getWarHexDataIOError,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      internal function getWarHexDataComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get war hex data complete");
               OverworldHUD.instance.warUI.warHexUI.initWarHexData(_loc3_.hex,_loc3_.sentry);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getWarHexDataIOError(param1:IOErrorEvent) : void
      {
         trace("Error get hex data.");
      }
      
      public function addWarSentry(param1:int, param2:int, param3:int, param4:int, param5:String) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc6_:URLRequest = new URLRequest(this.server + "/war/warsentry.php");
         var _loc7_:URLLoader;
         (_loc7_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc8_:URLVariables;
         (_loc8_ = new URLVariables()).magicnum = this.magicnum;
         _loc8_.map = param1;
         _loc8_.side = param2;
         _loc8_.charid = param5;
         _loc8_.x = param3;
         _loc8_.y = param4;
         _loc8_.op = "add";
         if(this.debug)
         {
            _loc8_.debug = 1;
         }
         _loc6_.data = _loc8_;
         _loc6_.method = URLRequestMethod.POST;
         _loc7_.addEventListener(Event.COMPLETE,this.addWarSentryComplete,false,0,true);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,this.addWarSentryIOError,false,0,true);
         _loc7_.load(_loc6_);
      }
      
      internal function addWarSentryComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get add war sentry complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function addWarSentryIOError(param1:IOErrorEvent) : void
      {
         trace("Error add war sentry.");
      }
      
      public function delWarSentry(param1:int, param2:String) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "/war/warsentry.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).magicnum = this.magicnum;
         _loc5_.charid = param2;
         _loc5_.op = "del";
         if(this.debug)
         {
            _loc5_.debug = 1;
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.delWarSentryComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.delWarSentryIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function delWarSentryComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("del war sentry complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function delWarSentryIOError(param1:IOErrorEvent) : void
      {
         trace("Error del war sentry.");
      }
      
      public function getWarEnemySentry(param1:int, param2:int, param3:int, param4:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc5_:URLRequest = new URLRequest(this.server + "/war/getwarenemysentry.php");
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc7_:URLVariables;
         (_loc7_ = new URLVariables()).magicnum = this.magicnum;
         _loc7_.map = param1;
         _loc7_.side = param4;
         _loc7_.x = param2;
         _loc7_.y = param3;
         if(this.debug)
         {
            _loc7_.debug = 1;
         }
         _loc5_.data = _loc7_;
         _loc5_.method = URLRequestMethod.POST;
         _loc6_.addEventListener(Event.COMPLETE,this.getWarEnemySentryComplete,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.getWarEnemySentryIOError,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      internal function getWarEnemySentryComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get war enemy sentry complete");
               OverworldHUD.instance.warUI.warHexUI.startBattle(_loc3_.char);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getWarEnemySentryIOError(param1:IOErrorEvent) : void
      {
         trace("Error get war enemy sentry.");
      }
      
      public function setWarHex(param1:int, param2:int, param3:int, param4:int, param5:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc6_:URLRequest = new URLRequest(this.server + "/war/setwarhex.php");
         var _loc7_:URLLoader;
         (_loc7_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc8_:URLVariables;
         (_loc8_ = new URLVariables()).magicnum = this.magicnum;
         _loc8_.map = param1;
         _loc8_.x = param2;
         _loc8_.y = param3;
         _loc8_.side = param4;
         _loc8_.value = param5;
         if(this.debug)
         {
            _loc8_.debug = 1;
         }
         _loc6_.data = _loc8_;
         _loc6_.method = URLRequestMethod.POST;
         _loc7_.addEventListener(Event.COMPLETE,this.setWarHexComplete,false,0,true);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,this.setWarHexIOError,false,0,true);
         _loc7_.load(_loc6_);
      }
      
      internal function setWarHexComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("set war hex complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function setWarHexIOError(param1:IOErrorEvent) : void
      {
         trace("Error set war hex.");
      }
      
      public function startBuild(param1:int, param2:int, param3:int, param4:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc5_:URLRequest = new URLRequest(this.server + "/war/startbuild.php");
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc7_:URLVariables;
         (_loc7_ = new URLVariables()).magicnum = this.magicnum;
         _loc7_.map = param1;
         _loc7_.x = param2;
         _loc7_.y = param3;
         _loc7_.type = param4;
         if(this.debug)
         {
            _loc7_.debug = 1;
         }
         _loc5_.data = _loc7_;
         _loc5_.method = URLRequestMethod.POST;
         _loc6_.addEventListener(Event.COMPLETE,this.startBuildComplete,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.startBuildIOError,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      internal function startBuildComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("start build complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function startBuildIOError(param1:IOErrorEvent) : void
      {
         trace("Error start build.");
      }
      
      public function doBuild(param1:int, param2:int, param3:int, param4:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc5_:URLRequest = new URLRequest(this.server + "/war/dobuild.php");
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc7_:URLVariables;
         (_loc7_ = new URLVariables()).magicnum = this.magicnum;
         _loc7_.map = param1;
         _loc7_.x = param2;
         _loc7_.y = param3;
         _loc7_.cost = param4;
         if(this.debug)
         {
            _loc7_.debug = 1;
         }
         _loc5_.data = _loc7_;
         _loc5_.method = URLRequestMethod.POST;
         _loc6_.addEventListener(Event.COMPLETE,this.doBuildComplete,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.doBuildIOError,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      internal function doBuildComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("do build complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function doBuildIOError(param1:IOErrorEvent) : void
      {
         trace("Error do build.");
      }
      
      public function logMessage(param1:String) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc2_:URLRequest = new URLRequest(this.server + "/logmessage.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).magicnum = this.magicnum;
         _loc4_.charname = StatsManager.charname;
         _loc4_.msg = escape(param1);
         if(this.debug)
         {
            _loc4_.debug = 1;
         }
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.logMessageError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function logMessageError(param1:IOErrorEvent) : void
      {
         trace("log message error");
      }
      
      public function loadCharData(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:URLRequest = null;
         var _loc4_:URLLoader = null;
         var _loc5_:URLVariables = null;
         StatsManager.charname = param1;
         if(param2)
         {
            this.lastUpdate = 0;
         }
         if(this.offlineMode)
         {
            trace("offline load user data complete");
            this.loadCharCookieData();
            StatsManager.refreshMCS();
            NodeGenerator.instance.initSurroundingTerrCache(StatsManager.getLocation(),false);
         }
         else
         {
            _loc3_ = new URLRequest(this.server + "loaddata.php");
            (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
            (_loc5_ = new URLVariables()).lastupdate = this.lastUpdate;
            _loc5_.charname = param1;
            _loc5_.magicnum = this.magicnum;
            if(StatsManager.useCirrus)
            {
               _loc5_.stratusid = NetworkManager.getInstance().getNid();
            }
            else
            {
               _loc5_.stratusid = "";
            }
            if(this.debug)
            {
               _loc5_.debug = 1;
            }
            _loc3_.data = _loc5_;
            _loc3_.method = URLRequestMethod.POST;
            _loc4_.addEventListener(Event.COMPLETE,this.loadCharDataComplete,false,0,true);
            _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.loadCharDataIOError,false,0,true);
            _loc4_.load(_loc3_);
         }
         this.resetDataModified();
      }
      
      internal function loadCharDataComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               this.saveLastUpdate(_loc3_.lastupdate);
               StatsManager.id = _loc3_.id;
               if(_loc3_.apupdate != "")
               {
                  StatsManager.nextAPUpdate = _loc3_.apupdate;
               }
               if(_loc3_.dtupdate != "")
               {
                  StatsManager.nextDTUpdate = _loc3_.dtupdate;
               }
               if(_loc3_.warupdate != "")
               {
                  StatsManager.nextWarTurn = _loc3_.warupdate;
               }
               if(_loc3_.playerstats != null)
               {
                  StatsManager.parsePlayerStatsString(_loc3_.playerstats);
               }
               if(_loc3_.equipment != null)
               {
                  StatsManager.parseEquipmentString(_loc3_.equipment);
               }
               if(_loc3_.skillstats != null)
               {
                  StatsManager.parseSkillStatsString(_loc3_.skillstats);
               }
               if(_loc3_.skillslots != null)
               {
                  StatsManager.parseSkillSlotsString(_loc3_.skillslots);
               }
               if(_loc3_.inventory != null)
               {
                  StatsManager.parseInventoryString(_loc3_.inventory);
               }
               if(_loc3_.stash != null)
               {
                  StatsManager.parseStashString(_loc3_.stash);
               }
               if(_loc3_.questitems != null)
               {
                  StatsManager.parseQuestItemsString(_loc3_.questitems);
               }
               if(_loc3_.intstats != null)
               {
                  StatsManager.parseIntStatsString(_loc3_.intstats);
               }
               if(_loc3_.achievementstats != null)
               {
                  StatsManager.parseAchievementStatsString(_loc3_.achievementstats);
               }
               if(_loc3_.booleanstats != null)
               {
                  StatsManager.parseBooleanStatsString(_loc3_.booleanstats);
               }
               if(_loc3_.activequest != null)
               {
                  StatsManager.setActiveQuestString(_loc3_.activequest);
               }
               if(_loc3_.completedquest != null)
               {
                  StatsManager.parseCompletedQuestString(_loc3_.completedquest);
               }
               if(_loc3_.taunt != null)
               {
                  StatsManager.setTaunt(_loc3_.taunt);
               }
               if(_loc3_.rank != null)
               {
                  StatsManager.rank = _loc3_.rank;
               }
               if(_loc3_.wins != null)
               {
                  StatsManager.setPlayerStats(StatsManager.STAT_WINS,_loc3_.wins);
               }
               if(_loc3_.bounty != null)
               {
                  StatsManager.bounty = _loc3_.bounty;
               }
               if(_loc3_.notif != null)
               {
                  StatsManager.giftNotification = _loc3_.notif;
               }
               if(_loc3_.friends != null)
               {
                  StatsManager.parseFriendListString(_loc3_.friends);
               }
               if(_loc3_.purchases != null)
               {
                  StatsManager.purchasesMade.setIntValue(_loc3_.purchases);
               }
               trace("online load user data complete");
               StatsManager.refreshMCS();
               NodeGenerator.instance.initSurroundingTerrCache(StatsManager.getLocation(),false);
               this.storeCurrentSessionId();
               break;
            case "1":
               trace("not logged in");
               GameEngine.initTitleScreen();
               break;
            case "2":
               trace("incorrect magic number");
               GameEngine.initTitleScreen();
               break;
            case "3":
               trace("character not found on server");
               GameEngine.initTitleScreen();
               TitleUI.instance.switchToReady();
         }
      }
      
      internal function loadCharDataIOError(param1:IOErrorEvent) : void
      {
         trace("Error loading user data.");
         GameEngine.initTitleScreen();
         TitleUI.instance.switchToReady();
      }
      
      public function saveAllCharData() : *
      {
         this.saveCharCookieData();
         if(this.offlineMode)
         {
            trace("offline save user data complete");
            this.resetDataModified();
         }
         else
         {
            this.markAllDataModified();
            this.saveModifiedCharData(true);
         }
      }
      
      public function saveModifiedCharData(param1:Boolean = false) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc6_:URLVariables = null;
         if(!this.checkCurrentSessionId())
         {
            OverworldHUD.instance.showMultipleClients();
            return;
         }
         StatsManager.resetPingCounter();
         this.saveCharCookieData();
         if(this.offlineMode)
         {
            trace("offline save user data complete.");
            this.resetDataModified();
         }
         else
         {
            _loc2_ = false;
            _loc3_ = 0;
            while(_loc3_ < DATASLOTS)
            {
               if(this.dataModified[_loc3_])
               {
                  _loc2_ = true;
               }
               _loc3_++;
            }
            if(!_loc2_)
            {
               return;
            }
            trace("saving data");
            _loc4_ = new URLRequest(this.server + "savedata.php");
            (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
            (_loc6_ = new URLVariables()).charname = StatsManager.charname;
            _loc6_.magicnum = this.magicnum;
            if(this.dataModified[0])
            {
               _loc6_.playerlevel = StatsManager.getPlayerLevelString();
            }
            if(this.dataModified[1])
            {
               _loc6_.playerstats = StatsManager.getPlayerStatsString();
               _loc6_.battlestats = StatsManager.getBattleStatsString();
            }
            if(this.dataModified[2])
            {
               _loc6_.equipment = StatsManager.getEquipmentString();
            }
            if(this.dataModified[3])
            {
               _loc6_.skillstats = StatsManager.getSkillStatsString();
            }
            if(this.dataModified[4])
            {
               _loc6_.inventory = StatsManager.getInventoryString();
            }
            if(this.dataModified[5])
            {
               _loc6_.questitems = StatsManager.getQuestItemsString();
            }
            if(this.dataModified[6])
            {
               _loc6_.intstats = StatsManager.getIntStatsString();
            }
            if(this.dataModified[7])
            {
               _loc6_.booleanstats = StatsManager.getBooleanStatsString();
            }
            if(this.dataModified[8])
            {
               _loc6_.activequest = StatsManager.getActiveQuestString();
            }
            if(this.dataModified[9])
            {
               _loc6_.completedquest = StatsManager.getCompletedQuestString();
            }
            if(this.dataModified[10])
            {
               _loc6_.playerlocation = StatsManager.getLocationString();
            }
            if(this.dataModified[11])
            {
               _loc6_.taunt = StatsManager.getTaunt();
            }
            if(this.dataModified[12] && StatsManager.usePlayerIO && !QueryManagerPIO.instance.isMigrator)
            {
               _loc6_.friends = StatsManager.getFriendListString();
            }
            if(this.dataModified[14])
            {
               _loc6_.skillslots = StatsManager.getSkillSlotsString();
            }
            if(this.dataModified[15])
            {
               _loc6_.side = StatsManager.getSide();
            }
            if(this.dataModified[16])
            {
               _loc6_.playerdan = StatsManager.getPlayerDanString();
            }
            if(this.dataModified[17])
            {
               _loc6_.stash = StatsManager.getStashString();
            }
            if(this.dataModified[19])
            {
               _loc6_.achievementstats = StatsManager.getAchievementStatsString();
            }
            if(StatsManager.nextAPUpdate != this.lastAPUpdate)
            {
               _loc6_.apupdate = StatsManager.nextAPUpdate;
               this.lastAPUpdate = StatsManager.nextAPUpdate;
            }
            if(StatsManager.nextDTUpdate != this.lastDTUpdate)
            {
               _loc6_.dtupdate = StatsManager.nextDTUpdate;
               this.lastDTUpdate = StatsManager.nextDTUpdate;
            }
            if(StatsManager.nextWarTurn != this.lastWarTurn)
            {
               _loc6_.warupdate = StatsManager.nextWarTurn;
               this.lastWarTurn = StatsManager.nextWarTurn;
            }
            if(this.debug)
            {
               _loc6_.debug = 1;
            }
            this.resetDataModified();
            _loc4_.data = _loc6_;
            _loc4_.method = URLRequestMethod.POST;
            _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.saveCharDataIOError,false,0,true);
            _loc5_.load(_loc4_);
            this.saveLastUpdate();
         }
      }
      
      internal function saveCharDataIOError(param1:IOErrorEvent) : void
      {
         trace("Error saving user data.");
         this.markAllDataModified();
      }
      
      public function saveReplay(param1:String, param2:String, param3:String, param4:int) : *
      {
         var _loc5_:URLRequest = new URLRequest(this.server + "savereplay.php");
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc7_:URLVariables;
         (_loc7_ = new URLVariables()).name1 = param1;
         _loc7_.name2 = param2;
         _loc7_.magicnum = this.magicnum;
         _loc7_.data = param3;
         _loc7_.win = param4;
         if(this.debug)
         {
            _loc7_.debug = 1;
         }
         _loc5_.data = _loc7_;
         _loc5_.method = URLRequestMethod.POST;
         _loc6_.addEventListener(Event.COMPLETE,this.saveReplayComplete,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.saveReplayIOError,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      internal function saveReplayComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("save replay complete");
               WinUI.instance.replaySaved();
               LoseUI.instance.replaySaved();
               if(StatsManager.isFacebook())
               {
                  this.shareDuelTV();
               }
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function saveReplayIOError(param1:IOErrorEvent) : void
      {
         trace("Error saving replay.");
      }
      
      public function getReplay(param1:String) : *
      {
         GameEngine.showLoadingScreen();
         var _loc2_:URLRequest = new URLRequest(this.server + "getreplay.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).magicnum = this.magicnum;
         _loc4_.id = param1;
         if(this.debug)
         {
            _loc4_.debug = 1;
         }
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.getReplayComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.getReplayIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      public function getReplayByName(param1:String) : *
      {
         GameEngine.showLoadingScreen();
         var _loc2_:URLRequest = new URLRequest(this.server + "getreplay.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).magicnum = this.magicnum;
         _loc4_.name = param1;
         if(this.debug)
         {
            _loc4_.debug = 1;
         }
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.getReplayComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.getReplayIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function getReplayComplete(param1:Event) : void
      {
         GameEngine.hideLoadingScreen();
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get replay complete");
               NetworkManager.instance.playRecording(_loc3_.data);
               break;
            case "1":
               trace("not logged in");
               if(GameEngine.isPlayBackClient())
               {
                  this.getReplay("0");
               }
               break;
            case "2":
               trace("incorrect magic number");
               if(GameEngine.isPlayBackClient())
               {
                  this.getReplay("0");
               }
               break;
            case "3":
               trace("not found");
               if(GameEngine.isPlayBackClient())
               {
                  this.getReplay("0");
               }
               else
               {
                  OverworldHUD.instance.showDialog(LangManager.getString(484),LangManager.getString(5));
               }
         }
      }
      
      internal function getReplayIOError(param1:IOErrorEvent) : void
      {
         GameEngine.hideLoadingScreen();
         trace("Error get replay.");
      }
      
      public function updateGlobalVar(param1:int, param2:int) : *
      {
         OverworldHUD.instance.globalVarDialog.addGlobalVar(param1,param2);
         if(StatsManager.skipUpdateGlobalVar || this.offlineMode)
         {
            trace("skipping global var update: " + param1 + " " + param2);
            return;
         }
         if(param1 == 50005 || param1 == 50006)
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "updateglobalvar.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).charid = StatsManager.id;
         _loc5_.magicnum = this.magicnum;
         _loc5_.varid = param1;
         _loc5_.value = param2;
         if(this.debug)
         {
            _loc5_.debug = 1;
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.updateGlobalVarComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.updateGlobalVarIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function updateGlobalVarComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("update global var complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function updateGlobalVarIOError(param1:IOErrorEvent) : void
      {
         trace("Error saving updating global var.");
      }
      
      public function getGlobalVar(param1:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc2_:URLRequest = new URLRequest(this.server + "getglobalvar.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).magicnum = this.magicnum;
         _loc4_.varid = param1;
         if(this.debug)
         {
            _loc4_.debug = 1;
         }
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.getGlobalVarComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.getGlobalVarIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function getGlobalVarComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get global var complete");
               trace(_loc3_.key + _loc3_.value);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getGlobalVarIOError(param1:IOErrorEvent) : void
      {
         trace("Error get global var.");
      }
      
      public function updateTownProsperity(param1:int) : *
      {
         var _loc2_:Point = NodeGenerator.instance.getTerritory(QuestGenerator.instance.currentNPCNodeId);
         var _loc3_:int = StatsManager.getSide();
         OverworldHUD.instance.globalVarDialog.updateTownProsperity(param1,_loc3_,_loc2_.x,_loc2_.y);
         if(StatsManager.skipUpdateGlobalVar || this.offlineMode || NodeGenerator.instance.isNoChangeTown(_loc2_.x << 12 | _loc2_.y))
         {
            trace("skipping town prosperity update: (" + (_loc2_.x - 341) + "," + (_loc2_.y - 341) + ") " + param1);
            return;
         }
         var _loc4_:URLRequest = new URLRequest(this.server + "/town/updatetownprosperity.php");
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc6_:URLVariables;
         (_loc6_ = new URLVariables()).charid = StatsManager.id;
         _loc6_.magicnum = this.magicnum;
         _loc6_.tx = _loc2_.x;
         _loc6_.ty = _loc2_.y;
         _loc6_.side = _loc3_;
         _loc6_.value = param1;
         if(this.debug)
         {
            _loc6_.debug = 1;
         }
         _loc4_.data = _loc6_;
         _loc4_.method = URLRequestMethod.POST;
         _loc5_.addEventListener(Event.COMPLETE,this.updateTownProsperityComplete,false,0,true);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.updateTownProsperityIOError,false,0,true);
         _loc5_.load(_loc4_);
      }
      
      internal function updateTownProsperityComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("update town prosperity complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function updateTownProsperityIOError(param1:IOErrorEvent) : void
      {
         trace("Error updating town prosperity.");
      }
      
      public function createTown(param1:int, param2:int, param3:String = "") : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc4_:URLRequest = new URLRequest(this.server + "/town/createtown.php");
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc6_:URLVariables;
         (_loc6_ = new URLVariables()).charid = StatsManager.id;
         _loc6_.magicnum = this.magicnum;
         _loc6_.x = param1;
         _loc6_.y = param2;
         _loc6_.name = param3;
         _loc6_.founder = StatsManager.charname;
         _loc6_.side = StatsManager.getSide();
         if(this.debug)
         {
            _loc6_.debug = 1;
         }
         _loc4_.data = _loc6_;
         _loc4_.method = URLRequestMethod.POST;
         _loc5_.addEventListener(Event.COMPLETE,this.createTownComplete,false,0,true);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.createTownIOError,false,0,true);
         _loc5_.load(_loc4_);
      }
      
      internal function createTownComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("create town complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function createTownIOError(param1:IOErrorEvent) : void
      {
         trace("Error create town.");
      }
      
      public function getTownData(param1:int, param2:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "/town/gettowndata.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).magicnum = this.magicnum;
         _loc5_.x = param1;
         _loc5_.y = param2;
         if(this.debug)
         {
            _loc5_.debug = 1;
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.getTownDataComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.getTownDataIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function getTownDataComplete(param1:Event) : void
      {
         var _loc4_:Point = null;
         var _loc5_:TerritoryData = null;
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get town data complete");
               _loc4_ = NodeGenerator.instance.getTerritory(StageManager.getCurrentNode());
               (_loc5_ = NodeGenerator.instance.getTerritoryData(_loc4_.x,_loc4_.y,true)).setTerrExtraData(_loc3_.data,null);
               _loc5_.showTownData();
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getTownDataIOError(param1:IOErrorEvent) : void
      {
         trace("Error get town data.");
      }
      
      public function createSpawnPoint(param1:int, param2:int, param3:int, param4:int, param5:String, param6:Boolean) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc7_:URLRequest = new URLRequest(this.server + "/war/spawnpointcreate.php");
         var _loc8_:URLLoader;
         (_loc8_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc9_:URLVariables;
         (_loc9_ = new URLVariables()).magicnum = this.magicnum;
         _loc9_.x = param3;
         _loc9_.y = param4;
         _loc9_.side = param2;
         _loc9_.mapid = param1;
         _loc9_.cp = param5;
         _loc9_.hasTown = param6;
         if(this.debug)
         {
            _loc9_.debug = 1;
         }
         _loc7_.data = _loc9_;
         _loc7_.method = URLRequestMethod.POST;
         _loc8_.addEventListener(Event.COMPLETE,this.createSpawnPointComplete,false,0,true);
         _loc8_.addEventListener(IOErrorEvent.IO_ERROR,this.createSpawnPointIOError,false,0,true);
         _loc8_.load(_loc7_);
      }
      
      internal function createSpawnPointComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("create spawn point complete");
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
         OverworldHUD.instance.warUI.warHexUI.createSpawnPointCallBack(_loc3_.status);
      }
      
      internal function createSpawnPointIOError(param1:IOErrorEvent) : void
      {
         trace("Error create spawn point.");
      }
      
      public function destroySpawnPoint(param1:int, param2:int, param3:int) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc4_:URLRequest = new URLRequest(this.server + "/war/spawnpointdestroy.php");
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc6_:URLVariables;
         (_loc6_ = new URLVariables()).magicnum = this.magicnum;
         _loc6_.x = param2;
         _loc6_.y = param3;
         _loc6_.mapid = param1;
         if(this.debug)
         {
            _loc6_.debug = 1;
         }
         _loc4_.data = _loc6_;
         _loc4_.method = URLRequestMethod.POST;
         _loc5_.addEventListener(Event.COMPLETE,this.destroySpawnPointComplete,false,0,true);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.destroySpawnPointIOError,false,0,true);
         _loc5_.load(_loc4_);
      }
      
      internal function destroySpawnPointComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("destroy spawn point complete");
               OverworldHUD.instance.warUI.warHexUI.createSpawnPointCallBack(10);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function destroySpawnPointIOError(param1:IOErrorEvent) : void
      {
         trace("Error destroy spawn point.");
      }
      
      public function getTerritoryData(param1:int, param2:int) : *
      {
         if(this.offlineMode)
         {
            NodeGenerator.instance.gotTerritoryData(param1,param2,"0");
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "/town/getterritorydata.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).magicnum = this.magicnum;
         _loc5_.x = param1;
         _loc5_.y = param2;
         if(this.debug)
         {
            _loc5_.debug = 1;
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.getTerritoryDataComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.getTerritoryDataIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function getTerritoryDataComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get territory data complete:" + _loc3_.x + "," + _loc3_.y);
               NodeGenerator.instance.gotTerritoryData(_loc3_.x,_loc3_.y,_loc3_.data);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getTerritoryDataIOError(param1:IOErrorEvent) : void
      {
         trace("Error get territory data");
      }
      
      public function getTerritoryGroupData(param1:int, param2:int) : *
      {
         if(this.offlineMode)
         {
            NodeGenerator.instance.gotTerritoryGroupData(param1,param2,"0|0|0|0|0|0|0|0|0");
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "/town/getterritorygroupdata.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).magicnum = this.magicnum;
         _loc5_.x = param1;
         _loc5_.y = param2;
         if(this.debug)
         {
            _loc5_.debug = 1;
         }
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.addEventListener(Event.COMPLETE,this.getTerritoryGroupDataComplete,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.getTerritoryGroupDataIOError,false,0,true);
         _loc4_.load(_loc3_);
      }
      
      internal function getTerritoryGroupDataComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               trace("get territory group data complete:" + _loc3_.x + "," + _loc3_.y);
               NodeGenerator.instance.gotTerritoryGroupData(_loc3_.x,_loc3_.y,_loc3_.data);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getTerritoryGroupDataIOError(param1:IOErrorEvent) : void
      {
         trace("Error get territory group data");
      }
      
      public function reportHack(param1:String) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         if(this.hackReported)
         {
            return;
         }
         OverworldHUD.instance.showCorrupted();
         var _loc2_:URLRequest = new URLRequest(this.server + "rh.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).magicnum = this.magicnum;
         _loc4_.charname = StatsManager.charname;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.reportHackComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.reportHackIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function reportHackComplete(param1:Event) : void
      {
         this.hackReported = true;
      }
      
      internal function reportHackIOError(param1:IOErrorEvent) : void
      {
         trace("Error r h");
      }
      
      public function reportGotGold(param1:int, param2:String) : *
      {
         if(StatsManager.skipUpdateGlobalVar || this.offlineMode)
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(this.server + "/playerio/reportgotgold.php");
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).charname = StatsManager.charname;
         _loc5_.num = param1;
         _loc5_.method = param2;
         _loc5_.level = StatsManager.getLevel() + StatsManager.getPlayerStats(StatsManager.STAT_DAN) * 80;
         _loc3_.data = _loc5_;
         _loc3_.method = URLRequestMethod.POST;
         _loc4_.load(_loc3_);
      }
      
      public function reportPremiumBuy(param1:int, param2:String, param3:int) : *
      {
         if(StatsManager.skipUpdateGlobalVar || this.offlineMode || StatsManager.consoleEnabled)
         {
            return;
         }
         var _loc4_:URLRequest = new URLRequest(this.server + "reportpremiumbuy.php");
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc6_:URLVariables;
         (_loc6_ = new URLVariables()).magicnum = this.magicnum;
         _loc6_.charname = StatsManager.charname;
         _loc6_.id = param1;
         _loc6_.str = param2;
         _loc4_.data = _loc6_;
         _loc4_.method = URLRequestMethod.POST;
         _loc5_.addEventListener(Event.COMPLETE,this.reportPremiumBuyComplete,false,0,true);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.reportPremiumBuyIOError,false,0,true);
         _loc5_.load(_loc4_);
      }
      
      internal function reportPremiumBuyComplete(param1:Event) : void
      {
         trace("report premium buy complete");
      }
      
      internal function reportPremiumBuyIOError(param1:IOErrorEvent) : void
      {
         trace("Error report premium buy");
      }
      
      public function getDiscount() : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc1_:URLRequest = new URLRequest(this.server + "getdiscount.php");
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.magicnum = this.magicnum;
         _loc1_.data = _loc3_;
         _loc1_.method = URLRequestMethod.POST;
         _loc2_.addEventListener(Event.COMPLETE,this.getDiscountComplete,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.getDiscountIOError,false,0,true);
         _loc2_.load(_loc1_);
      }
      
      internal function getDiscountComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               OverworldHUD.instance.payUI.gotDiscount(_loc3_.discount,_loc3_.expire);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getDiscountIOError(param1:IOErrorEvent) : void
      {
         trace("Error get discount");
      }
      
      public function whois(param1:String) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc2_:URLRequest = new URLRequest(this.server + "whois.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).magicnum = this.magicnum;
         _loc4_.charname = param1;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.whoisComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.whoisIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function whoisComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               OverworldHUD.instance.updateChatLogWordsOnly(_loc3_.char + " is " + _loc3_.alts);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function whoisIOError(param1:IOErrorEvent) : void
      {
         trace("Error whois");
      }
      
      public function changeName(param1:String) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc2_:URLRequest = new URLRequest(this.server + "changename.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).magicnum = this.magicnum;
         _loc4_.oldname = StatsManager.charname;
         _loc4_.newname = param1;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.changeNameComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.changeNameIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function changeNameComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               OverworldHUD.instance.changeNameDialog.changeSuccessful();
               break;
            case "3":
               OverworldHUD.instance.changeNameDialog.changeError(3);
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function changeNameIOError(param1:IOErrorEvent) : void
      {
         trace("Error changename");
      }
      
      public function getPlayerLocation(param1:String) : *
      {
         if(this.offlineMode)
         {
            return;
         }
         var _loc2_:URLRequest = new URLRequest(this.server + "getplayerlocation.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).magicnum = this.magicnum;
         _loc4_.charname = param1;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.getPlayerLocationComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.getPlayerLocationIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function getPlayerLocationComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         if(this.debug)
         {
            trace(_loc3_.debug);
         }
         switch(_loc3_.status)
         {
            case "0":
               OverworldHUD.instance.chatText.words.text = _loc3_.location;
               break;
            case "1":
               trace("not logged in");
               break;
            case "2":
               trace("incorrect magic number");
         }
      }
      
      internal function getPlayerLocationIOError(param1:IOErrorEvent) : void
      {
         trace("Error getPlayerLocation");
      }
      
      internal function saveCharCookieData() : *
      {
         trace("save cookie data");
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         _loc1_.data.playerlevel = StatsManager.getPlayerLevelString();
         _loc1_.data.dan = StatsManager.getPlayerStats(StatsManager.STAT_DAN);
         _loc1_.data.purchases = StatsManager.purchasesMade.getIntValue();
         _loc1_.data.saved = true;
         _loc1_.flush();
         var _loc2_:SharedObject = SharedObject.getLocal(StatsManager.cookieName + "_" + StatsManager.charname);
         _loc2_.data.saved = true;
         if(!this.offlineMode)
         {
            _loc2_.data.equipment = StatsManager.getEquipmentString();
            _loc2_.data.playerlevel = StatsManager.getPlayerLevelString();
         }
         else
         {
            _loc2_.data.nextAPUpdate = StatsManager.nextAPUpdate;
            _loc2_.data.nextDTUpdate = StatsManager.nextDTUpdate;
            _loc2_.data.lastUpdate = this.lastUpdate;
            _loc2_.data.playerlevel = StatsManager.getPlayerLevelString();
            _loc2_.data.playerStats = StatsManager.getPlayerStatsString();
            _loc2_.data.equipment = StatsManager.getEquipmentString();
            _loc2_.data.skillStats = StatsManager.getSkillStatsString();
            _loc2_.data.skillSlots = StatsManager.getSkillSlotsString();
            _loc2_.data.inventory = StatsManager.getInventoryString();
            _loc2_.data.stash = StatsManager.getStashString();
            _loc2_.data.questItems = StatsManager.getQuestItemsString();
            _loc2_.data.intStats = StatsManager.getIntStatsString();
            _loc2_.data.achievementStats = StatsManager.getAchievementStatsString();
            _loc2_.data.booleanStats = StatsManager.getBooleanStatsString();
            _loc2_.data.activeQuestList = StatsManager.getActiveQuestString();
            _loc2_.data.completedQuestList = StatsManager.getCompletedQuestString();
            _loc2_.data.playerlocation = StatsManager.getLocationString();
            _loc2_.data.taunt = StatsManager.getTaunt();
            _loc2_.data.friends = StatsManager.getFriendListString();
         }
         _loc2_.flush();
         this.saveCharName();
      }
      
      internal function deleteCharCookieData(param1:String) : *
      {
         trace("delete cookie data");
         var _loc2_:SharedObject = SharedObject.getLocal(StatsManager.cookieName + "_" + param1);
         _loc2_.data.saved = false;
         _loc2_.data.nextAPUpdate = "";
         _loc2_.data.nextDTUpdate = "";
         _loc2_.data.lastUpdate = "";
         _loc2_.data.playerLevel = "";
         _loc2_.data.playerStats = "";
         _loc2_.data.equipment = "";
         _loc2_.data.skillStats = "";
         _loc2_.data.skillSlots = "";
         _loc2_.data.inventory = "";
         _loc2_.data.stash = "";
         _loc2_.data.questItems = "";
         _loc2_.data.intStats = "";
         _loc2_.data.achievementStats = "";
         _loc2_.data.booleanStats = "";
         _loc2_.data.activeQuestList = "";
         _loc2_.data.completedQuestList = "";
         _loc2_.data.playerlocation = "";
         _loc2_.data.taunt = "";
         _loc2_.data.friends = "";
         _loc2_.flush();
      }
      
      internal function loadCharCookieData() : *
      {
         trace("load cookie data");
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName + "_" + StatsManager.charname);
         if(_loc1_.data.saved != true)
         {
            // LOCAL SOLO BUILD: seed a guest character so the overworld knows
            // where to spawn. Without a saved SharedObject the game returns early
            // with STAT_LOCATION == 0 and the world never loads.
            try
            {
               StatsManager.setPlayerStats(StatsManager.STAT_LOCATION,8382465);
               StatsManager.setPlayerStats(StatsManager.STAT_LOCATION_ROOM,0);
               StatsManager.setPlayerStats(StatsManager.STAT_LEVEL,1);
               StatsManager.setPlayerStats(StatsManager.STAT_HP,100);
               StatsManager.setPlayerStats(StatsManager.STAT_MAXHP,100);
               StatsManager.setPlayerStats(StatsManager.STAT_GOLD,5000);
               _loc1_.data.saved = true;
               _loc1_.data.charname = StatsManager.charname;
               _loc1_.flush();
            }
            catch(e:Error)
            {
               trace("solo seed failed: " + e);
            }
            return;
         }
         StatsManager.nextAPUpdate = _loc1_.data.nextAPUpdate;
         StatsManager.nextDTUpdate = _loc1_.data.nextDTUpdate;
         this.lastUpdate = _loc1_.data.lastUpdate;
         if(_loc1_.data.playerStats != "")
         {
            StatsManager.parsePlayerStatsString(_loc1_.data.playerStats);
         }
         if(_loc1_.data.equipment != "")
         {
            StatsManager.parseEquipmentString(_loc1_.data.equipment);
         }
         if(_loc1_.data.skillStats != "")
         {
            StatsManager.parseSkillStatsString(_loc1_.data.skillStats);
         }
         if(_loc1_.data.skillSlots != "")
         {
            StatsManager.parseSkillSlotsString(_loc1_.data.skillSlots);
         }
         if(_loc1_.data.inventory != "")
         {
            StatsManager.parseInventoryString(_loc1_.data.inventory);
         }
         if(_loc1_.data.stash != "")
         {
            StatsManager.parseStashString(_loc1_.data.stash);
         }
         if(_loc1_.data.questItems != "")
         {
            StatsManager.parseQuestItemsString(_loc1_.data.questItems);
         }
         if(_loc1_.data.intStats != "")
         {
            StatsManager.parseIntStatsString(_loc1_.data.intStats);
         }
         if(_loc1_.data.achievementStats != "")
         {
            StatsManager.parseAchievementStatsString(_loc1_.data.achievementStats);
         }
         if(_loc1_.data.booleanStats != "")
         {
            StatsManager.parseBooleanStatsString(_loc1_.data.booleanStats);
         }
         if(_loc1_.data.activeQuestList != "")
         {
            StatsManager.setActiveQuestString(_loc1_.data.activeQuestList);
         }
         if(_loc1_.data.completedQuestList != "")
         {
            StatsManager.parseCompletedQuestString(_loc1_.data.completedQuestList);
         }
         if(_loc1_.data.taunt != "")
         {
            StatsManager.setTaunt(_loc1_.data.taunt);
         }
         StatsManager.parseFriendListString(_loc1_.data.friends);
      }
      
      internal function saveLogin(param1:String, param2:String) : *
      {
         if(param1 == "" || param1 == "guest" || param2 == "")
         {
            return;
         }
         var _loc3_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         _loc3_.data.saved = true;
         _loc3_.data.user = param1;
         _loc3_.data.pass = param2;
         _loc3_.flush();
      }
      
      internal function clearAutoLogin() : *
      {
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         _loc1_.data.saved = true;
         _loc1_.data.user = "";
         _loc1_.data.pass = "";
         _loc1_.data.accesstoken = "";
         _loc1_.flush();
      }
      
      public function getSavedOptions() : *
      {
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         if(_loc1_.data.saved != true)
         {
            ResourceManager.loadMusicResource();
            SoundManager.instance.playMusic(MusicManager.MUSIC_QUIET);
            ResourceManager.loadSoundResource();
            return false;
         }
         if(_loc1_.data.hasMusic != undefined)
         {
            SoundManager.instance.hasMusic = _loc1_.data.hasMusic;
         }
         if(SoundManager.instance.hasMusic)
         {
            ResourceManager.loadMusicResource();
         }
         SoundManager.instance.playMusic(MusicManager.MUSIC_QUIET);
         if(_loc1_.data.hasSound != undefined)
         {
            SoundManager.instance.hasSound = _loc1_.data.hasSound;
         }
         if(SoundManager.instance.hasSound)
         {
            ResourceManager.loadSoundResource();
         }
         if(_loc1_.data.censored != undefined)
         {
            StatsManager.censored = _loc1_.data.censored;
         }
         if(_loc1_.data.hasChatNotification != undefined)
         {
            StatsManager.hasChatNotification = _loc1_.data.hasChatNotification;
         }
         if(_loc1_.data.recordDuels != undefined)
         {
            StatsManager.recordDuels = _loc1_.data.recordDuels;
         }
         if(_loc1_.data.autoAssignStats != undefined)
         {
            StatsManager.autoAssignStats = _loc1_.data.autoAssignStats;
         }
         if(_loc1_.data.showNinjaServant != undefined)
         {
            StatsManager.showNinjaServant = _loc1_.data.showNinjaServant;
         }
      }
      
      public function showAds() : Boolean
      {
         if(StatsManager.isKongregate || StatsManager.consoleEnabled)
         {
            return false;
         }
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         if(_loc1_.data.saved != true)
         {
            return false;
         }
         if((_loc1_.data.playerlevel >= 10 || _loc1_.data.dan > 0) && _loc1_.data.purchases == 0)
         {
            return true;
         }
         return false;
      }
      
      public function autoLogin() : Boolean
      {
         // LOCAL SOLO BUILD: start a guest session.
         this.offlineMode = true;
         this.login("Guest","pass");
         return true;
         if(StatsManager.offlineModeOnly)
         {
            return false;
         }
         if(this.offlineMode)
         {
            this.login("Guest","pass");
            return true;
         }
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         if(_loc1_.data.saved != true)
         {
            return false;
         }
         var _loc2_:String = String(_loc1_.data.user);
         var _loc3_:String = String(_loc1_.data.pass);
         if(_loc2_ != "" && _loc3_ != "")
         {
            this.login(_loc2_,_loc3_);
            return true;
         }
         return false;
      }
      
      internal function saveCharName() : *
      {
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         _loc1_.data.saved = true;
         _loc1_.data.charname = StatsManager.charname;
         _loc1_.flush();
      }
      
      internal function clearCharName() : *
      {
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         _loc1_.data.saved = true;
         _loc1_.data.charname = "";
         _loc1_.flush();
      }
      
      internal function saveOptions() : *
      {
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         _loc1_.data.saved = true;
         _loc1_.data.hasMusic = SoundManager.instance.hasMusic;
         _loc1_.data.hasSound = SoundManager.instance.hasSound;
         _loc1_.data.censored = StatsManager.censored;
         _loc1_.data.hasChatNotification = StatsManager.hasChatNotification;
         _loc1_.data.recordDuels = StatsManager.recordDuels;
         _loc1_.data.autoSlash = StatsManager.autoSlash;
         _loc1_.data.autoAssignStats = StatsManager.autoAssignStats;
         _loc1_.data.showNinjaServant = StatsManager.showNinjaServant;
         _loc1_.data.doFullScreen = StatsManager.doFullScreen;
         _loc1_.flush();
         QueryManager.instance.reportDataModified(StatsManager.OPTIONS);
      }
      
      internal function getLastCharacterEquipmentString() : String
      {
         var sharedObject:SharedObject = null;
         var charname:String = null;
         try
         {
            sharedObject = SharedObject.getLocal(StatsManager.cookieName);
            if(sharedObject.data.saved != true)
            {
               return "";
            }
            charname = String(sharedObject.data.charname);
            sharedObject = SharedObject.getLocal(StatsManager.cookieName + "_" + charname);
            if(sharedObject.data.saved != true)
            {
               return "";
            }
            return sharedObject.data.equipment;
         }
         catch(errObject:Error)
         {
            trace("getLastCharacterEquipmentString error");
            return "";
         }
      }
      
      internal function showWebsite(param1:String) : *
      {
         var url:String = param1;
         var request:URLRequest = new URLRequest(url);
         try
         {
            navigateToURL(request,"_blank");
         }
         catch(e:Error)
         {
            trace("Error occurred!");
         }
      }
      
      internal function showWebsiteOnThisPage(param1:String) : *
      {
         var url:String = param1;
         var request:URLRequest = new URLRequest(url);
         try
         {
            navigateToURL(request);
         }
         catch(e:Error)
         {
            trace("Error occurred!");
         }
      }
      
      public function showEBWebsite() : *
      {
         this.showWebsite("http://www.explosivebarrel.net");
      }
      
      public function showPlayOnlineWebsite() : *
      {
         if(LangManager.getLanguage() == LangManager.CHINESE)
         {
            this.showWebsite("http://gamebox.catv.net/");
         }
         else
         {
            this.showWebsite("http://www.facebook.com/strawhatsamuraiduels/");
         }
      }
      
      internal function storeCurrentSessionId() : *
      {
         if(StatsManager.canMultiClient || GameEngine.isPlayBackClient() || this.offlineMode)
         {
            return;
         }
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName,"/");
         this.sessionID = Math.random() * 10000;
         _loc1_.data.current = this.sessionID;
         _loc1_.flush();
      }
      
      internal function checkCurrentSessionId() : Boolean
      {
         if(StatsManager.canMultiClient || GameEngine.isPlayBackClient() || this.offlineMode)
         {
            return true;
         }
         if(OverworldHUD.instance == null)
         {
            return true;
         }
         var _loc1_:SharedObject = SharedObject.getLocal(StatsManager.cookieName,"/");
         return _loc1_.data.current == this.sessionID;
      }
      
      internal function shareDuelTV() : *
      {
         ExternalInterface.call("shareDuelTVOnWall",StatsManager.charname);
      }
   }
}
