package
{
   import Facebook.*;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import playerio.*;
   
   public class QueryManagerPIO extends QueryManagerBase
   {
      
      public static var instance:QueryManagerPIO;
      
      internal static var WAR_TERRITORYOWNERS:int = 0;
      
      internal static var WAR_SELFSENTRY:int = 1;
      
      internal static var WAR_SPAWNPOINTS:int = 2;
      
      internal static var WAR_NEXTUPDATE:int = 3;
      
      internal static var WAR_MAINTENANCE:int = 4;
      
      public static var WORLDSTATESTR_ASCIIADD:int = 32;
       
      
      internal var client:Client;
      
      internal var playerObj:DatabaseObject = null;
      
      internal var playerData:DatabaseObject = null;
      
      internal var battleData:DatabaseObject = null;
      
      public var gameid:String = "straw-hat-samurai-duels-5nsekxalfuoiuqdxrmtxw";
      
      internal var needEmailVerification:Boolean = false;
      
      internal var partnerPay:String = "";
      
      internal var doMigration:Boolean = false;
      
      internal var isMigrator:Boolean = false;
      
      public var facebookTokenLogin:Boolean = false;
      
      internal var noPayVault:Boolean = false;
      
      internal var charDataString:String;
      
      internal var sqlLastUpdate:String;
      
      internal var migrationSaveCheckNum:int = 0;
      
      internal var piolastAPUpdate:int;
      
      internal var piolastDTUpdate:int;
      
      internal var piolastWarTurn:int;
      
      internal var loadChecks:int;
      
      internal var opponentCache:Array = null;
      
      internal var opponentCacheCreated:int = 0;
      
      internal var currentPage:int = 0;
      
      internal var nextStart:int;
      
      internal var hasNextPage:Boolean;
      
      internal var hasPrevPage:Boolean;
      
      internal var pages:Array;
      
      internal var warmapData:Array;
      
      internal var warmapDataCounter:int = 0;
      
      internal var clanDataCache:IntMap;
      
      public function QueryManagerPIO()
      {
         this.warmapData = new Array();
         this.clanDataCache = new IntMap();
         super();
         server = StatsManager.server;
         instance = this;
         if(StatsManager.usePlayerIODevServer)
         {
            this.gameid = "straw-hat-samurai-duels-no1ygg8lk6xmk5txblnwa";
         }
      }
      
      public function getResourceURL(param1:String) : String
      {
         if(StatsManager.useTestData)
         {
            return PlayerIO.gameFS(this.gameid).getUrl("/testres/" + param1);
         }
         return PlayerIO.gameFS(this.gameid).getUrl("/res/" + param1);
      }
      
      public function getStringsDir() : String
      {
         if(StatsManager.useTestData)
         {
            return PlayerIO.gameFS(this.gameid).getUrl("/testlang/");
         }
         return PlayerIO.gameFS(this.gameid).getUrl("/lang/");
      }
      
      public function getDataXML(param1:String) : String
      {
         if(StatsManager.useTestData)
         {
            return PlayerIO.gameFS(this.gameid).getUrl("/testdata/" + param1);
         }
         return PlayerIO.gameFS(this.gameid).getUrl("/data/" + param1);
      }
      
      override public function registerUser(param1:String, param2:String, param3:String, param4:String = "") : *
      {
         if(!this.needEmailVerification)
         {
            this.registerPIOUser(param1,param2,param3,param4);
            return;
         }
         var _loc5_:URLRequest = new URLRequest(server + "/playerio/registeruser.php");
         var _loc6_:URLLoader;
         (_loc6_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc7_:URLVariables;
         (_loc7_ = new URLVariables()).username = param1;
         _loc7_.password = param2;
         _loc7_.email = param3;
         _loc7_.facebookid = param4;
         if(debug)
         {
            _loc7_.debug = 1;
         }
         _loc5_.data = _loc7_;
         _loc5_.method = URLRequestMethod.POST;
         _loc6_.addEventListener(Event.COMPLETE,this.registerComplete,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,registerIOError,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      override internal function registerComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         switch(_loc3_.status)
         {
            case "0":
               trace("server register ok");
               this.registerPIOUser(TitleUI.instance.register.usernamefield.text,TitleUI.instance.register.password1field.text,TitleUI.instance.register.emailfield.text);
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
      
      public function registerPIOUser(param1:String, param2:String, param3:String, param4:String = "") : *
      {
         PlayerIO.quickConnect.simpleRegister(StatsManager.mainTimeLine.stage,this.gameid,param1,param2,param3,null,null,null,this.partnerPay,this.registerCompletePIO,this.registerErrorPIO);
         username = param1;
      }
      
      internal function registerCompletePIO(param1:Client) : *
      {
         if(this.needEmailVerification)
         {
            trace("pio register ok, sending email");
            sendVerify(TitleUI.instance.register.emailfield.text);
            param1.bigDB.loadMyPlayerObject(this.gotRegisteredPlayerObj);
         }
         else
         {
            this.handleConnect(param1);
         }
      }
      
      internal function gotRegisteredPlayerObj(param1:DatabaseObject) : *
      {
         param1.emailverified = false;
         param1.save();
         TitleUI.instance.register.serverResponse(0);
      }
      
      internal function registerErrorPIO(param1:PlayerIORegistrationError) : *
      {
         var _loc2_:String = "Error";
         if(param1.captchaError != null)
         {
            _loc2_ = param1.captchaError;
         }
         else if(param1.emailError != null)
         {
            _loc2_ = param1.emailError;
         }
         else if(param1.passwordError != null)
         {
            _loc2_ = param1.passwordError;
         }
         else if(param1.usernameError != null)
         {
            _loc2_ = param1.usernameError;
         }
         TitleUI.instance.register.serverErrorMessage(_loc2_);
         username = "";
      }
      
      override public function login(param1:String, param2:String) : *
      {
         var _loc3_:URLRequest = null;
         var _loc4_:URLLoader = null;
         var _loc5_:URLVariables = null;
         if(!this.doMigration)
         {
            this.piologin(param1,param2);
            return;
         }
         if(!offlineMode)
         {
            _loc3_ = new URLRequest(server + "/playerio/getcharmigrationdata.php");
            (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.VARIABLES;
            (_loc5_ = new URLVariables()).username = param1;
            _loc5_.password = param2;
            _loc5_.lang = LangManager.getLanguage();
            _loc5_.ver = StatsManager.clientVersion;
            if(StatsManager.impersonateUser)
            {
               _loc5_.impers = "onate";
            }
            if(debug)
            {
               _loc5_.debug = 1;
            }
            _loc3_.data = _loc5_;
            _loc3_.method = URLRequestMethod.POST;
            _loc4_.addEventListener(Event.COMPLETE,this.migrationloginComplete,false,0,true);
            _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.migrationloginIOError,false,0,true);
            _loc4_.load(_loc3_);
         }
         else
         {
            this.migrationloginFail();
         }
      }
      
      internal function facebookMigration(param1:Client) : *
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLLoader = null;
         var _loc4_:URLVariables = null;
         trace("facebook migration start");
         this.client = param1;
         if(!offlineMode)
         {
            _loc2_ = new URLRequest(server + "/playerio/getcharmigrationdata.php");
            _loc3_ = new URLLoader();
            _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
            (_loc4_ = new URLVariables()).fbid = StatsManager.facebookid;
            _loc4_.lang = LangManager.getLanguage();
            _loc4_.ver = StatsManager.clientVersion;
            if(debug)
            {
               _loc4_.debug = 1;
            }
            _loc2_.data = _loc4_;
            _loc2_.method = URLRequestMethod.POST;
            _loc3_.addEventListener(Event.COMPLETE,this.migrationloginComplete,false,0,true);
            _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.migrationloginIOError,false,0,true);
            _loc3_.load(_loc2_);
         }
         else
         {
            this.migrationloginFail();
         }
      }
      
      internal function migrationloginFail(param1:PlayerIOError = null) : *
      {
         if(param1 != null)
         {
            trace("migrationloginFail: " + param1);
         }
         this.isMigrator = false;
         if(StatsManager.facebookid == "")
         {
            this.piologin(TitleUI.instance.login.usernamefield.text,TitleUI.instance.login.passwordfield.text);
         }
         else
         {
            this.handleConnect(this.client);
         }
      }
      
      internal function migrationloginComplete(param1:Event) : void
      {
         var vars:URLVariables = null;
         var event:Event = param1;
         var loader:URLLoader = URLLoader(event.target);
         vars = new URLVariables(loader.data);
         if(debug)
         {
            trace(vars.debug);
         }
         switch(vars.status)
         {
            case "0":
               trace("migration stage 1");
               this.isMigrator = true;
               magicnum = vars.magicnum;
               this.sqlLastUpdate = vars.lastupdate;
               loggedIn = true;
               if(StatsManager.facebookid == "")
               {
                  username = TitleUI.instance.login.usernamefield.text;
               }
               this.charDataString = vars.chars;
               if(StatsManager.facebookid != "")
               {
                  this.migrationPIOConnect(this.client);
               }
               else
               {
                  PlayerIO.quickConnect.simpleConnect(StatsManager.mainTimeLine.stage,this.gameid,TitleUI.instance.login.usernamefield.text,TitleUI.instance.login.passwordfield.text,this.migrationPIOConnect,function(param1:PlayerIOError):*
                  {
                     trace("registering new user for migrator");
                     PlayerIO.quickConnect.simpleRegister(StatsManager.mainTimeLine.stage,gameid,TitleUI.instance.login.usernamefield.text,TitleUI.instance.login.passwordfield.text,vars.email,null,null,null,partnerPay,migrationPIOConnect,migrationloginFail);
                  });
               }
               break;
            default:
               this.migrationloginFail();
         }
      }
      
      internal function migrationPIOConnect(param1:Client) : *
      {
         var strArray:Array;
         var charname:String = null;
         var playerlevel:int = 0;
         var equipment:String = null;
         var battlestats:String = null;
         var skillstats:String = null;
         var taunt:String = null;
         var playerdan:int = 0;
         var side:int = 0;
         var apupdate:int = 0;
         var playerstats:String = null;
         var warupdate:int = 0;
         var dtupdate:int = 0;
         var inventory:String = null;
         var intstats:String = null;
         var skillslots:String = null;
         var booleanstats:String = null;
         var questitems:String = null;
         var friends:String = null;
         var activequest:String = null;
         var created:String = null;
         var completedquest:String = null;
         var purchases:int = 0;
         var location:String = null;
         var type:String = null;
         var _client:Client = param1;
         this.client = _client;
         trace("migration stage 2");
         strArray = this.charDataString.split("$");
         if(strArray.length != 23)
         {
            this.migrationloginFail();
            return;
         }
         trace("migration stage 3");
         charname = String(strArray[0]);
         playerlevel = int(strArray[1]);
         equipment = String(strArray[2]);
         battlestats = String(strArray[3]);
         skillstats = String(strArray[4]);
         taunt = String(strArray[5]);
         playerdan = int(strArray[6]);
         side = int(strArray[7]);
         apupdate = int(strArray[8]);
         playerstats = String(strArray[9]);
         warupdate = int(strArray[10]);
         dtupdate = int(strArray[11]);
         inventory = String(strArray[12]);
         intstats = String(strArray[13]);
         skillslots = String(strArray[14]);
         booleanstats = String(strArray[15]);
         questitems = String(strArray[16]);
         friends = String(strArray[17]);
         activequest = String(strArray[18]);
         created = String(strArray[19]);
         completedquest = String(strArray[20]);
         purchases = int(strArray[21]);
         location = String(strArray[22]);
         type = "migrator";
         this.migrationSaveCheckNum = 0;
         this.client.bigDB.loadMyPlayerObject(function(param1:DatabaseObject):*
         {
            var po:DatabaseObject = param1;
            trace("migration stage 4");
            if(po.lastupdate == null && po.charname != null || po.lastupdate != null)
            {
               if(true || po.lastupdate > int(sqlLastUpdate) - 120)
               {
                  trace("migration not needed");
                  handleConnect(client);
                  return;
               }
            }
            po.charname = charname;
            po.playerlevel = playerlevel;
            po.equipment = equipment;
            po.skillstats = skillstats;
            po.taunt = taunt;
            po.playerdan = playerdan;
            po.side = side;
            po.apupdate = apupdate;
            po.playerstats = playerstats;
            po.warupdate = warupdate;
            po.dtupdate = dtupdate;
            po.inventory = inventory;
            po.intstats = intstats;
            po.skillslots = skillslots;
            po.booleanstats = booleanstats;
            po.questitems = questitems;
            po.friends = friends;
            po.activequest = activequest;
            po.created = created;
            po.completedquest = completedquest;
            po.purchases = purchases;
            po.location = location;
            po.type = type;
            po.save(false,false,migrationSaveCheck,migrationloginFail);
            client.bigDB.loadKeysOrCreate("playerdata",[charname],function(param1:Array):*
            {
               trace("migration stage 5");
               var _loc2_:DatabaseObject = param1[0];
               _loc2_.playerlevel = playerlevel;
               _loc2_.equipment = equipment;
               _loc2_.playerdan = playerdan;
               _loc2_.side = side;
               _loc2_.wins = 0;
               _loc2_.randomindex1 = int(Math.random() * 1000);
               _loc2_.randomindex2 = int(Math.random() * 1000);
               _loc2_.type = type;
               _loc2_.save(false,false,migrationSaveCheck,migrationloginFail);
            },migrationloginFail);
            client.bigDB.loadKeysOrCreate("battledata",[charname],function(param1:Array):*
            {
               trace("migration stage 6");
               var _loc2_:DatabaseObject = param1[0];
               _loc2_.battlestats = battlestats;
               _loc2_.skillstats = skillstats;
               _loc2_.taunt = taunt;
               _loc2_.type = type;
               _loc2_.save(false,false,migrationSaveCheck,migrationloginFail);
            },migrationloginFail);
         },this.migrationloginFail);
      }
      
      internal function migrationSaveCheck() : *
      {
         ++this.migrationSaveCheckNum;
         if(this.migrationSaveCheckNum == 3)
         {
            trace("migration successful");
            this.handleConnect(this.client);
         }
      }
      
      internal function migrationloginIOError(param1:IOErrorEvent) : void
      {
         trace("migration login IO error");
         this.migrationloginFail();
      }
      
      public function spilLogin(param1:String) : *
      {
         var _loc2_:String = null;
         var _loc3_:URLRequest = null;
         var _loc4_:URLLoader = null;
         if(!offlineMode)
         {
            param1 = "UwAB_wAxBAEDhRtDbGgAeQQAUX3mJwgBAAAAAleAc2dpZF8wNDAxMDM4NTFiNDM2YzY4kvrsARwJV1Bva82yQxZeVrvt3GL4qHH5pENmolbKo3eLRQKTBrD3ug";
            _loc2_ = "http://api.playerio.com/clientintegrations/spilgames/auth?gameid=" + this.gameid + "&token=" + param1;
            _loc3_ = new URLRequest(_loc2_);
            (_loc4_ = new URLLoader()).addEventListener(Event.COMPLETE,this.spilLoginComplete,false,0,true);
            _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.spilLoginIOError,false,0,true);
            _loc4_.load(_loc3_);
         }
      }
      
      internal function spilLoginComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:String = _loc2_.data;
         var _loc4_:Array;
         var _loc5_:String = String((_loc4_ = _loc3_.split(/\n/))[0]);
         var _loc6_:String = String(_loc4_[1]);
         PlayerIO.connect(StatsManager.mainTimeLine.stage,this.gameid,"public",_loc4_[0],_loc4_[1],this.partnerPay,this.loginCompletePIO,this.loginErrorPIO);
      }
      
      internal function spilLoginIOError(param1:Event) : void
      {
         trace("spil login error");
         TitleUI.instance.login.serverResponse(7);
      }
      
      public function piologin(param1:String, param2:String) : *
      {
         if(!offlineMode)
         {
            if(StatsManager.impersonateUser)
            {
               PlayerIO.connect(StatsManager.mainTimeLine.stage,this.gameid,"public",param1,"",this.partnerPay,this.loginCompletePIO,this.loginErrorPIO);
            }
            else
            {
               PlayerIO.quickConnect.simpleConnect(StatsManager.mainTimeLine.stage,this.gameid,param1,param2,this.loginCompletePIO,this.loginErrorPIO);
            }
            username = param1;
         }
         else
         {
            loggedIn = true;
            username = "Guest";
            charstring = "";
            TitleUI.instance.login.serverResponse(0);
            saveLastUpdate("1000000");
            NetworkManager.getInstance();
         }
      }
      
      internal function loginCompletePIO(param1:Client) : *
      {
         trace("login ok");
         StatsManager.facebookid = "";
         StatsManager.facebookFriends = "";
         this.handleConnect(param1);
      }
      
      internal function loginErrorPIO(param1:PlayerIOError) : *
      {
         if(!TitleUI.instance.login.visible)
         {
            TitleUI.instance.switchToLogin();
         }
         TitleUI.instance.login.serverErrorMessage(param1.message);
         username = "";
         if(param1.message == "The user does not exist")
         {
            TitleUI.instance.login.reregistertext.visible = true;
         }
      }
      
      public function loginKongregate(param1:Number, param2:String) : *
      {
         username = "kong" + param1.toString();
         PlayerIO.quickConnect.kongregateConnect(StatsManager.mainTimeLine.stage,this.gameid,param1.toString(),param2,this.loginCompletePIO,this.loginErrorPIO);
      }
      
      internal function loginFacebook() : *
      {
         if(StatsManager.isMobile)
         {
            Mobile.instance.loginFacebook();
            return;
         }
         PlayerIO.quickConnect.facebookOAuthConnectPopup(StatsManager.mainTimeLine.stage,this.gameid,"_blank",["publish_stream","offline_access"],this.partnerPay,function(param1:Client, param2:String, param3:String):void
         {
            StatsManager.facebookid = param3;
            var _loc4_:SharedObject;
            (_loc4_ = SharedObject.getLocal(StatsManager.cookieName)).data.saved = true;
            _loc4_.data.accesstoken = param2;
            _loc4_.flush();
            FB.init({
               "access_token":param2,
               "app_id":"197461360314820",
               "debug":false
            });
            getFBName(param1,param2);
         });
      }
      
      internal function tokenLoginFacebook(param1:String) : *
      {
         var access_token:String = param1;
         PlayerIO.quickConnect.facebookOAuthConnect(StatsManager.mainTimeLine.stage,this.gameid,access_token,this.partnerPay,function(param1:Client, param2:String):void
         {
            StatsManager.facebookid = param2;
            FB.init({
               "access_token":access_token,
               "app_id":"197461360314820",
               "debug":false
            });
            getFBName(param1,access_token);
         });
      }
      
      internal function fbLoginError() : *
      {
         trace("facebook login error");
         if(!TitleUI.instance.login.visible)
         {
            TitleUI.instance.switchToLogin();
         }
         clearAutoLogin();
      }
      
      internal function facebookAPI(param1:String, param2:String, param3:Function, param4:Function) : *
      {
         var str:String = param1;
         var access_token:String = param2;
         var successCallback:Function = param3;
         var failCallback:Function = param4;
         var request:URLRequest = new URLRequest("https://graph.facebook.com/" + str + "&access_token=" + access_token);
         var loader:URLLoader = new URLLoader();
         request.method = URLRequestMethod.GET;
         loader.addEventListener(Event.COMPLETE,function(param1:Event):*
         {
            var _loc2_:URLLoader = URLLoader(param1.target);
            var _loc3_:Object = FBJSON.deserialize(_loc2_.data);
            successCallback(_loc3_);
         },false,0,true);
         loader.addEventListener(IOErrorEvent.IO_ERROR,failCallback,false,0,true);
         loader.load(request);
      }
      
      internal function getFBName(param1:Client, param2:String) : *
      {
         var client:Client = param1;
         var access_token:String = param2;
         this.facebookAPI("me?fields=name",access_token,function(param1:Object):*
         {
            username = param1.name;
            getFBFriends(client,access_token);
         },function(param1:Event):*
         {
            fbLoginError();
         });
      }
      
      internal function getFBFriends(param1:Client, param2:String) : *
      {
         var client:Client = param1;
         var access_token:String = param2;
         TitleUI.instance.loadingScreenOn();
         StatsManager.facebookFriends = "";
         if(this.doMigration)
         {
            this.facebookMigration(client);
         }
         else
         {
            this.handleConnect(client);
         }
         this.facebookAPI("fql?q=SELECT uid, first_name FROM user WHERE is_app_user = \'1\' AND uid IN (SELECT uid2 FROM friend WHERE uid1=me())",access_token,this.getFBFriendsComplete,function(param1:Event):*
         {
            StatsManager.facebookFriends = "";
         });
      }
      
      internal function getFBFriendsComplete(param1:Object) : *
      {
         var fbnames:Array = null;
         var fbwinscallback:Function = null;
         var fbwinserror:Function = null;
         var rows:Object = param1;
         fbwinscallback = function(param1:Array):*
         {
            var _loc4_:DatabaseObject = null;
            var _loc2_:int = int(param1.length);
            var _loc3_:String = "";
            var _loc5_:* = 0;
            while(_loc5_ < _loc2_)
            {
               _loc4_ = param1[_loc5_];
               _loc3_ += _loc4_.key + "," + fbnames[_loc4_.key] + "," + _loc4_.wins + "," + _loc4_.charname + "|";
               _loc5_++;
            }
            StatsManager.facebookFriends = _loc3_;
         };
         fbwinserror = function(param1:PlayerIOError):*
         {
            trace(param1);
            StatsManager.facebookFriends = "";
         };
         var fbwinskeys:Array = new Array();
         fbnames = new Array();
         var max:int = int(rows.data.length);
         var i:int = 0;
         while(i < max)
         {
            fbwinskeys.push(rows.data[i].uid.toString());
            fbnames[rows.data[i].uid.toString()] = rows.data[i].first_name;
            i++;
         }
         this.client.bigDB.loadKeys("FBwins",fbwinskeys,fbwinscallback,fbwinserror);
      }
      
      override public function autoLogin() : Boolean
      {
         // LOCAL SOLO BUILD: start a guest session. offlineMode=true makes
         // QueryManagerBase.login() skip the (dead) network round-trip and call
         // serverResponse(0) directly.
         offlineMode = true;
         this.login("Guest","pass");
         return true;
         if(StatsManager.offlineModeOnly)
         {
            return false;
         }
         if(offlineMode)
         {
            this.login("Guest","pass");
            return true;
         }
         var _loc1_:Object = GameEngine.getLoaderInfo(StatsManager.mainTimeLine).parameters;
         if(_loc1_.fb_access_token != null && _loc1_.fb_access_token != "")
         {
            this.tokenLoginFacebook(_loc1_.fb_access_token);
            this.facebookTokenLogin = true;
            return true;
         }
         var _loc2_:SharedObject = SharedObject.getLocal(StatsManager.cookieName);
         if(_loc2_.data.saved != true)
         {
            return false;
         }
         var _loc3_:String = String(_loc2_.data.accesstoken);
         if(_loc3_ != null && _loc3_ != "")
         {
            this.tokenLoginFacebook(_loc3_);
            return true;
         }
         var _loc4_:String = String(_loc2_.data.user);
         var _loc5_:String = String(_loc2_.data.pass);
         if(_loc4_ != null && _loc5_ != null && _loc4_ != "" && _loc5_ != "")
         {
            TitleUI.instance.login.usernamefield.text = _loc4_;
            TitleUI.instance.login.passwordfield.text = _loc5_;
            this.login(_loc4_,_loc5_);
            return true;
         }
         return false;
      }
      
      override public function checkFlashVarsLogin() : *
      {
         var _loc1_:Object = GameEngine.getLoaderInfo(StatsManager.mainTimeLine).parameters;
         if(_loc1_.fb_access_token != null)
         {
            this.tokenLoginFacebook(_loc1_.fb_access_token);
            return;
         }
         trace("no flash vars");
         TitleUI.instance.login.serverResponse(6);
      }
      
      public function checkEmailVerified(param1:String) : *
      {
         var _loc2_:URLRequest = new URLRequest(server + "/playerio/checkemailverified.php");
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         var _loc4_:URLVariables;
         (_loc4_ = new URLVariables()).username = param1;
         _loc2_.data = _loc4_;
         _loc2_.method = URLRequestMethod.POST;
         _loc3_.addEventListener(Event.COMPLETE,this.checkEmailVerifiedComplete,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.checkEmailVerifiedIOError,false,0,true);
         _loc3_.load(_loc2_);
      }
      
      internal function checkEmailVerifiedComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         switch(_loc3_.status)
         {
            case "0":
               trace("email verified");
               this.playerObj.emailverified = true;
               this.playerObj.save();
               this.gotplayerObj(this.playerObj);
               break;
            case "1":
               trace("email not verified");
               if(StatsManager.useExternalLogin || StatsManager.useFlashVarsLogin)
               {
                  return;
               }
               TitleUI.instance.login.serverResponse(2);
               break;
         }
      }
      
      internal function checkEmailVerifiedIOError(param1:IOErrorEvent) : void
      {
         trace("Unable to reach server");
         TitleUI.instance.login.serverResponse(3);
      }
      
      internal function handleConnect(param1:Client) : *
      {
         var client:Client = param1;
         if(StatsManager.usePlayerIODevServer)
         {
            client.multiplayer.developmentServer = "localhost:8184";
         }
         this.client = client;
         userid = client.connectUserId;
         client.bigDB.load("GeneralData","motd",function(param1:DatabaseObject):*
         {
            if(param1.motd != null && param1.motd != "")
            {
               TitleUI.instance.showMOTD(param1.motd);
            }
            if(!StatsManager.consoleEnabled && param1.maintenance != null && Boolean(param1.maintenance))
            {
               TitleUI.instance.setLoadingScreenTextBig(LangManager.getString(674));
               return;
            }
            if(param1.minversion != null && int(param1.minversion * 1000) > int(StatsManager.clientVersion * 1000))
            {
               TitleUI.instance.setLoadingScreenTextBig(LangManager.getString(646));
               return;
            }
            client.bigDB.loadMyPlayerObject(gotplayerObj);
         });
      }
      
      internal function gotplayerObj(param1:DatabaseObject) : *
      {
         this.playerObj = param1;
         if(this.needEmailVerification && this.playerObj.emailverified != null && this.playerObj.emailverified == false)
         {
            this.checkEmailVerified(username);
            return;
         }
         loggedIn = true;
         if(param1.charname == null || param1.charname == "")
         {
            charstring = "";
         }
         else
         {
            charstring = param1.charname + "," + param1.playerlevel;
         }
         if(!this.isMigrator && this.doMigration)
         {
            this.sqlLogin();
         }
         else if(StatsManager.useCirrus && !NetworkManager.getInstance().connected)
         {
            NetworkManager.getInstance();
         }
         else
         {
            TitleUI.instance.login.serverResponse(0);
         }
      }
      
      public function sqlLogin() : *
      {
         var sqlloginComplete:Function = null;
         var sqlloginIOError:Function = null;
         var request:URLRequest = null;
         var loader:URLLoader = null;
         var variables:URLVariables = null;
         sqlloginComplete = function(param1:Event):void
         {
            var _loc2_:URLLoader = URLLoader(param1.target);
            var _loc3_:URLVariables = new URLVariables(_loc2_.data);
            if(debug)
            {
               trace(_loc3_.debug);
            }
            switch(_loc3_.status)
            {
               case "0":
                  magicnum = _loc3_.magicnum;
                  if(StatsManager.useCirrus && !NetworkManager.getInstance().connected)
                  {
                     NetworkManager.getInstance();
                  }
                  else
                  {
                     TitleUI.instance.login.serverResponse(0);
                  }
                  break;
               default:
                  trace("Unable to reach server: " + _loc3_.status);
                  if(isMigrator)
                  {
                     TitleUI.instance.login.serverResponse(3);
                  }
                  else if(StatsManager.useCirrus && !NetworkManager.getInstance().connected)
                  {
                     NetworkManager.getInstance();
                  }
                  else
                  {
                     TitleUI.instance.login.serverResponse(0);
                  }
            }
         };
         sqlloginIOError = function(param1:IOErrorEvent):*
         {
            if(isMigrator)
            {
               TitleUI.instance.login.serverResponse(3);
            }
            else if(StatsManager.useCirrus && !NetworkManager.getInstance().connected)
            {
               NetworkManager.getInstance();
            }
            else
            {
               TitleUI.instance.login.serverResponse(0);
            }
         };
         if(!offlineMode)
         {
            request = new URLRequest(server + "/playerio/login_pio.php");
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            variables = new URLVariables();
            variables.username = username;
            variables.userid = userid;
            variables.lang = LangManager.getLanguage();
            if(debug)
            {
               variables.debug = 1;
            }
            request.data = variables;
            request.method = URLRequestMethod.POST;
            loader.addEventListener(Event.COMPLETE,sqlloginComplete,false,0,true);
            loader.addEventListener(IOErrorEvent.IO_ERROR,sqlloginIOError,false,0,true);
            loader.load(request);
         }
      }
      
      override public function logout() : *
      {
         clearAutoLogin();
         loggedIn = false;
         this.playerObj = null;
         this.playerData = null;
         this.battleData = null;
         this.isMigrator = false;
         StatsManager.facebookid = "";
         StatsManager.facebookFriends = "";
         StatsManager.stash = new Vector.<Item>();
         this.isMigrator = false;
         NetworkManager.instance.disconnectGlobalPIO();
      }
      
      override public function createCharacter(param1:String) : *
      {
         if(this.isMigrator)
         {
            TitleUI.instance.charcreate.serverResponse(3);
            TitleUI.instance.charcreate.errormessage.text = "Cannot create character when logged in with this user";
            return;
         }
         if(offlineMode)
         {
            saveAllCharData();
            saveCharName();
            charstring = param1 + ",1";
            TitleUI.instance.charcreate.serverResponse(0);
            return;
         }
         this.playerObj.charname = param1;
         this.playerObj.type = "piotester";
         this.playerObj.save();
         NetworkManager.instance.connectGlobalGroupPIO(true);
      }
      
      internal function createCharacterResponse(param1:int) : *
      {
         var _loc2_:* = undefined;
         if(StatsManager.consoleEnabled && param1 == 5)
         {
            param1 = 0;
         }
         if(param1 != 0)
         {
            TitleUI.instance.charcreate.serverResponse(param1);
            this.playerObj.charname = "";
            this.playerObj.save();
         }
         else
         {
            this.playerObj.created = new Date().toUTCString();
            if(StatsManager.facebookid != "" && (this.playerObj.facebookid == null || this.playerObj.facebookid == ""))
            {
               this.playerObj.facebookid = StatsManager.facebookid;
            }
            saveAllCharData();
            charstring = this.playerObj.charname + ",1";
            _loc2_ = new Object();
            _loc2_.playerlevel = 1;
            _loc2_.type = "piotester";
            _loc2_.equipment = StatsManager.getEquipmentString();
            this.client.bigDB.createObject("PlayerData",this.playerObj.charname,_loc2_);
            TitleUI.instance.charcreate.serverResponse(0);
         }
      }
      
      override public function saveModifiedCharData(param1:Boolean = false) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         if(!checkCurrentSessionId())
         {
            OverworldHUD.instance.showMultipleClients();
            return;
         }
         StatsManager.resetPingCounter();
         saveCharCookieData();
         if(offlineMode)
         {
            trace("offline save user data complete.");
            resetDataModified();
         }
         else
         {
            _loc2_ = false;
            _loc3_ = 0;
            while(_loc3_ < DATASLOTS)
            {
               if(dataModified[_loc3_])
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
            if(dataModified[0])
            {
               NetworkManager.instance.saveUpdate(0,StatsManager.getPlayerLevelString());
               this.playerObj.playerlevel = StatsManager.getLevel();
               if(this.playerData != null)
               {
                  this.playerData.playerlevel = StatsManager.getLevel();
               }
            }
            if(dataModified[1])
            {
               NetworkManager.instance.saveUpdate(1,StatsManager.getPlayerStatsString());
               NetworkManager.instance.saveUpdate(103,StatsManager.getBattleStatsString());
               this.playerObj.playerstats = StatsManager.getPlayerStatsString();
               if(this.battleData != null)
               {
                  this.battleData.battlestats = StatsManager.getBattleStatsString();
               }
            }
            if(dataModified[2])
            {
               NetworkManager.instance.saveUpdate(2,StatsManager.getEquipmentString());
               this.playerObj.equipment = StatsManager.getEquipmentString();
               if(this.playerData != null)
               {
                  this.playerData.equipment = StatsManager.getEquipmentString();
               }
            }
            if(dataModified[3])
            {
               NetworkManager.instance.saveUpdate(3,StatsManager.getSkillStatsString());
               this.playerObj.skillstats = StatsManager.getSkillStatsString();
               if(this.battleData != null)
               {
                  this.battleData.skillstats = StatsManager.getSkillStatsString();
               }
            }
            if(dataModified[4])
            {
               NetworkManager.instance.saveUpdate(4,StatsManager.getInventoryString());
               this.playerObj.inventory = StatsManager.getInventoryString();
            }
            if(dataModified[5])
            {
               NetworkManager.instance.saveUpdate(5,StatsManager.getQuestItemsString());
               this.playerObj.questitems = StatsManager.getQuestItemsString();
            }
            if(dataModified[6])
            {
               NetworkManager.instance.saveUpdate(6,StatsManager.getIntStatsString());
               this.playerObj.intstats = StatsManager.getIntStatsString();
            }
            if(dataModified[7])
            {
               NetworkManager.instance.saveUpdate(7,StatsManager.getBooleanStatsString());
               this.playerObj.booleanstats = StatsManager.getBooleanStatsString();
            }
            if(dataModified[8])
            {
               NetworkManager.instance.saveUpdate(8,StatsManager.getActiveQuestString());
               this.playerObj.activequest = StatsManager.getActiveQuestString();
            }
            if(dataModified[9])
            {
               NetworkManager.instance.saveUpdate(9,StatsManager.getCompletedQuestString());
               this.playerObj.completedquest = StatsManager.getCompletedQuestString();
            }
            if(dataModified[10])
            {
               NetworkManager.instance.saveUpdate(10,StatsManager.getLocationString());
               this.playerObj.location = StatsManager.getLocationString();
               if(this.playerData != null)
               {
                  this.playerData.location = StatsManager.getLocationString();
               }
            }
            if(dataModified[11])
            {
               NetworkManager.instance.saveUpdate(11,StatsManager.getTaunt());
               this.playerObj.taunt = StatsManager.getTaunt();
               if(this.battleData != null)
               {
                  this.battleData.taunt = StatsManager.getTaunt();
               }
            }
            if(dataModified[12])
            {
               NetworkManager.instance.saveUpdate(12,StatsManager.getFriendListString());
               this.playerObj.friends = StatsManager.getFriendListString();
            }
            if(dataModified[14])
            {
               NetworkManager.instance.saveUpdate(14,StatsManager.getSkillSlotsString());
               this.playerObj.skillslots = StatsManager.getSkillSlotsString();
            }
            if(dataModified[15])
            {
               NetworkManager.instance.saveUpdate(15,StatsManager.getSide().toString());
               this.playerObj.side = StatsManager.getSide();
               if(this.playerData != null)
               {
                  this.playerData.side = StatsManager.getSide();
               }
            }
            if(dataModified[16])
            {
               NetworkManager.instance.saveUpdate(16,StatsManager.getPlayerDanString());
               this.playerObj.playerdan = StatsManager.getPlayerDanString();
               if(this.playerData != null)
               {
                  this.playerData.playerdan = StatsManager.getPlayerStats(StatsManager.STAT_DAN);
               }
            }
            if(dataModified[17])
            {
               NetworkManager.instance.saveUpdate(17,StatsManager.getStashString());
               this.playerObj.stash = StatsManager.getStashString();
            }
            if(dataModified[18])
            {
               NetworkManager.instance.saveUpdate(18,StatsManager.getOptionsString());
               this.playerObj.options = StatsManager.getOptionsString();
            }
            if(dataModified[19])
            {
               NetworkManager.instance.saveUpdate(19,StatsManager.getAchievementStatsString());
               this.playerObj.achievementstats = StatsManager.getAchievementStatsString();
            }
            if(StatsManager.nextAPUpdate != this.piolastAPUpdate)
            {
               NetworkManager.instance.saveUpdate(100,StatsManager.nextAPUpdate.toString());
               this.playerObj.apupdate = StatsManager.nextAPUpdate;
               this.piolastAPUpdate = StatsManager.nextAPUpdate;
            }
            if(StatsManager.nextDTUpdate != this.piolastDTUpdate)
            {
               NetworkManager.instance.saveUpdate(101,StatsManager.nextDTUpdate.toString());
               this.playerObj.dtupdate = StatsManager.nextDTUpdate;
               this.piolastDTUpdate = StatsManager.nextDTUpdate;
            }
            if(StatsManager.nextWarTurn != this.piolastWarTurn)
            {
               NetworkManager.instance.saveUpdate(102,StatsManager.nextWarTurn.toString());
               this.playerObj.warupdate = StatsManager.nextWarTurn;
               this.piolastWarTurn = StatsManager.nextWarTurn;
            }
            saveLastUpdate();
            if(this.isMigrator)
            {
               super.saveModifiedCharData(param1);
            }
            resetDataModified();
            if(param1)
            {
               this.playerObj.save();
            }
         }
      }
      
      override public function loadCharData(param1:String, param2:Boolean = false) : *
      {
         StatsManager.charname = param1;
         if(StatsManager.usePlayerIO && StatsManager.usePlayerIOForDuels)
         {
            NetworkManager.instance.nid = param1;
         }
         if(param2)
         {
            lastUpdate = 0;
         }
         if(offlineMode)
         {
            trace("offline load user data complete");
            loadCharCookieData();
            StatsManager.refreshMCS();
            NodeGenerator.instance.initSurroundingTerrCache(StatsManager.getLocation(),false);
         }
         else
         {
            StatsManager.id = param1;
            storeCurrentSessionId();
            this.loadChecks = 0;
            this.client.payVault.refresh(this.loadPayVaultCallBack,this.loadPayVaultError);
            this.client.bigDB.loadKeysOrCreate("PlayerData",[param1],this.loadPlayerDataCallBack,this.loadError);
            this.client.bigDB.loadKeysOrCreate("BattleData",[param1],this.loadBattleDataCallBack,this.loadError);
            this.client.bigDB.load("Notifications",param1,this.loadNotificationsCallBack,this.loadError);
            this.loadTowns();
            NetworkManager.instance.connectGlobalGroupPIO();
         }
      }
      
      internal function loadPayVaultCallBack() : *
      {
         trace("payvault loaded");
         this.checkLoadComplete();
      }
      
      internal function loadPayVaultError(param1:PlayerIOError) : *
      {
         this.noPayVault = true;
         this.checkLoadComplete();
      }
      
      internal function loadPlayerDataCallBack(param1:Array) : *
      {
         trace("playerdata loaded");
         this.playerData = param1[0];
         this.checkLoadComplete();
      }
      
      internal function loadBattleDataCallBack(param1:Array) : *
      {
         trace("battledata loaded");
         this.battleData = param1[0];
         if(StatsManager.useCirrus)
         {
            this.battleData.stratusid = NetworkManager.getInstance().getNid();
         }
         else
         {
            this.battleData.stratusid = "";
         }
         this.battleData.save();
         this.checkLoadComplete();
      }
      
      internal function loadNotificationsCallBack(param1:DatabaseObject) : *
      {
         trace("notifications loaded");
         if(param1 != null)
         {
            StatsManager.giftNotification = param1.notif;
            this.client.bigDB.deleteKeys("Notifications",[StatsManager.charname]);
         }
         this.checkLoadComplete();
      }
      
      internal function loadTowns() : *
      {
         this.client.bigDB.load("GeneralData","TownState",function(param1:DatabaseObject):*
         {
            trace("towns data loaded");
            QuestEngine.gotTownsData(param1.towns);
            checkLoadComplete();
         },function(param1:PlayerIOError):*
         {
            trace(param1);
         });
      }
      
      public function checkLoadComplete() : *
      {
         ++this.loadChecks;
         if(this.loadChecks == 6)
         {
            this.client.bigDB.loadMyPlayerObject(this.loadPlayerObjAgainCallBack,this.loadError);
         }
      }
      
      internal function loadPlayerObjAgainCallBack(param1:DatabaseObject) : *
      {
         var sharedObject:SharedObject = null;
         var obj:DatabaseObject = param1;
         try
         {
            trace("playerobject loaded");
            this.playerObj = obj;
            if(this.playerObj.charname == null)
            {
               NetworkManager.instance.disconnectGlobalPIO();
               NetworkManager.instance.disconnectChatPIO();
               return;
            }
            if(this.playerObj != null && this.playerObj.playerstats == null && this.playerObj.equipment == null)
            {
               NetworkManager.instance.disconnectGlobalPIO();
               NetworkManager.instance.disconnectChatPIO();
               GameEngine.hideLoadingScreen();
               GameEngine.initTitleScreen();
               this.deleteCharacter(this.playerObj.charname);
               TitleUI.instance.switchToCharacterCreate();
               return;
            }
            if(this.playerObj.apupdate != "")
            {
               StatsManager.nextAPUpdate = this.playerObj.apupdate;
            }
            if(this.playerObj.dtupdate != "")
            {
               StatsManager.nextDTUpdate = this.playerObj.dtupdate;
            }
            if(this.playerObj.warupdate != "")
            {
               StatsManager.nextWarTurn = this.playerObj.warupdate;
            }
            if(this.playerObj.playerstats != null)
            {
               StatsManager.parsePlayerStatsString(this.playerObj.playerstats);
            }
            if(this.playerObj.equipment != null)
            {
               StatsManager.parseEquipmentString(this.playerObj.equipment);
            }
            if(this.playerObj.skillstats != null)
            {
               StatsManager.parseSkillStatsString(this.playerObj.skillstats);
            }
            if(this.playerObj.skillslots != null)
            {
               StatsManager.parseSkillSlotsString(this.playerObj.skillslots);
            }
            if(this.playerObj.inventory != null)
            {
               StatsManager.parseInventoryString(this.playerObj.inventory);
            }
            if(this.playerObj.questitems != null)
            {
               StatsManager.parseQuestItemsString(this.playerObj.questitems);
            }
            if(this.playerObj.stash != null)
            {
               StatsManager.parseStashString(this.playerObj.stash);
            }
            if(this.playerObj.intstats != null)
            {
               StatsManager.parseIntStatsString(this.playerObj.intstats);
            }
            if(this.playerObj.achievementstats != null)
            {
               StatsManager.parseAchievementStatsString(this.playerObj.achievementstats);
            }
            if(this.playerObj.booleanstats != null)
            {
               StatsManager.parseBooleanStatsString(this.playerObj.booleanstats);
            }
            if(this.playerObj.activequest != null)
            {
               StatsManager.setActiveQuestString(this.playerObj.activequest);
            }
            if(this.playerObj.completedquest != null)
            {
               StatsManager.parseCompletedQuestString(this.playerObj.completedquest);
            }
            if(this.playerObj.taunt != null)
            {
               StatsManager.setTaunt(this.playerObj.taunt);
            }
            if(this.playerObj.wins != null)
            {
               StatsManager.setPlayerStats(StatsManager.STAT_WINS,this.playerObj.wins);
            }
            if(this.playerObj.bounty != null)
            {
               StatsManager.bounty = this.playerObj.bounty;
            }
            if(this.playerObj.friends != null)
            {
               StatsManager.parseFriendListString(this.playerObj.friends);
            }
            if(this.playerObj.purchases != null)
            {
               StatsManager.purchasesMade.setIntValue(this.playerObj.purchases);
            }
            if(this.playerObj.options != null)
            {
               sharedObject = SharedObject.getLocal(StatsManager.cookieName);
               if(sharedObject.data.saved != true)
               {
                  StatsManager.parseOptionsString(this.playerObj.options);
               }
            }
            StatsManager.refreshMCS();
            if(StatsManager.isCustomClan(StatsManager.getSide()))
            {
               this.loadCustomClanData(StatsManager.getSide(),this.gotMyCustomClanData);
            }
            else
            {
               this.gotMyCustomClanData();
            }
            if(this.playerObj.hackreported != null)
            {
               StatsManager.hackReported = true;
            }
            StatsManager.bonusPrizeCollected = false;
            StatsManager.didRebirth = false;
         }
         catch(e:Error)
         {
            QueryManagerPIO.instance.client.errorLog.writeError(e.message,"loadPlayerObjAgainCallBack " + StatsManager.charname,e.getStackTrace(),e.errorID);
         }
      }
      
      internal function gotMyCustomClanData(param1:DatabaseObject = null) : *
      {
         trace("online load user data complete");
         if(param1 != null)
         {
            StatsManager.initCustomClan(param1.clanname,param1.color,param1.logo,param1.logocolor,param1.acronym,param1.founder,param1.owned);
         }
         NodeGenerator.instance.initSurroundingTerrCache(StatsManager.getLocation(),false);
      }
      
      internal function loadError(param1:PlayerIOError) : *
      {
         trace(param1);
         this.client.errorLog.writeError(param1.name,param1.message,param1.getStackTrace(),param1.errorID);
      }
      
      override public function deleteCharacter(param1:String) : *
      {
         if(this.isMigrator)
         {
            TitleUI.instance.charselect.chardeleteform.serverResponse(3);
            TitleUI.instance.charselect.chardeleteform.errormessage.text = "Cannot delete character when logged in with this user";
            return;
         }
         deleteCharCookieData(param1);
         clearCharName();
         charstring = "";
         this.client.bigDB.deleteKeys("PlayerData",[param1]);
         this.client.bigDB.deleteKeys("BattleData",[param1]);
         this.client.bigDB.deleteKeys("GlobalHighScore",[param1]);
         this.client.bigDB.deleteKeys("WeeklyHighScore",[param1]);
         this.client.bigDB.deleteKeys("Notifications",[param1]);
         this.client.bigDB.deleteKeys("WarSentryData",[param1]);
         this.playerObj.prevname = this.playerObj.charname;
         delete this.playerObj.apupdate;
         delete this.playerObj.charname;
         delete this.playerObj.playerstats;
         delete this.playerObj.taunt;
         delete this.playerObj.warupdate;
         delete this.playerObj.skillstats;
         delete this.playerObj.equipment;
         delete this.playerObj.dtupdate;
         delete this.playerObj.inventory;
         delete this.playerObj.stash;
         delete this.playerObj.intstats;
         delete this.playerObj.achievementstats;
         delete this.playerObj.side;
         delete this.playerObj.skillslots;
         delete this.playerObj.booleanstats;
         delete this.playerObj.questitems;
         delete this.playerObj.activequest;
         delete this.playerObj.created;
         delete this.playerObj.playerlevel;
         delete this.playerObj.playerdan;
         delete this.playerObj.completedquest;
         delete this.playerObj.location;
         delete this.playerObj.options;
         this.playerObj.save();
         TitleUI.instance.charselect.chardeleteform.serverResponse(0);
      }
      
      override public function getOpponents() : *
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(offlineMode)
         {
            DuelModeUI.instance.setDuelList("");
            return;
         }
         if(this.opponentCache == null || getServerTime() - this.opponentCacheCreated > 60 * 2)
         {
            _loc1_ = StatsManager.getLevel();
            this.opponentCacheCreated = getServerTime();
            _loc3_ = Math.random() * 3;
            if(_loc3_ == 0)
            {
               _loc2_ = "ByLevelRandomA";
            }
            else if(_loc3_ == 1)
            {
               _loc2_ = "ByLevelRandomB";
            }
            else if(_loc3_ == 2)
            {
               _loc2_ = "ByLevelRandomC";
            }
            this.client.bigDB.loadRange("PlayerData",_loc2_,[],_loc1_,null,20,this.getOpponentsCompletePIO,this.getOpponentsErrorPIO);
         }
         else
         {
            this.getOpponentsCompletePIO(this.opponentCache);
         }
      }
      
      internal function getOpponentsCompletePIO(param1:Array) : void
      {
         var _loc2_:DatabaseObject = null;
         var _loc5_:int = 0;
         var _loc3_:int = int(param1.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = param1[_loc3_];
            if(_loc2_.key == StatsManager.charname || _loc2_.key == "admin" || _loc2_.key == "RyuKanji" || _loc2_.key == "kageyoshi" || _loc2_.key == "MasaruKanji")
            {
               param1.splice(_loc3_,1);
            }
            _loc3_--;
         }
         this.opponentCache = param1.slice(0,param1.length);
         var _loc4_:String = "";
         _loc3_ = 0;
         while(_loc3_ < 6 && param1.length > 0)
         {
            _loc2_ = param1.splice(int(Math.random() * param1.length),1)[0];
            if(_loc2_.online != null && Boolean(_loc2_.online))
            {
               _loc5_ = 0;
            }
            else
            {
               _loc5_ = 10000;
            }
            if(_loc2_.equipment == null)
            {
               _loc2_.equipment = XMLNpc.DEFAULT_EQSTRING;
            }
            _loc4_ += _loc2_.key + "$" + _loc2_.playerlevel + "$" + _loc2_.equipment + "$" + _loc5_ + "^";
            _loc3_++;
         }
         DuelModeUI.instance.setDuelList(_loc4_);
      }
      
      internal function getOpponentsErrorPIO(param1:PlayerIOError) : void
      {
         trace("getOpponents IO error:" + param1);
         DuelModeUI.instance.onLeave(null);
      }
      
      override public function getOpponentData(param1:String) : *
      {
         this.client.bigDB.load("BattleData",param1,this.getOpponentDataCompletePIO,this.getOpponentDataErrorPIO);
      }
      
      internal function getOpponentDataCompletePIO(param1:DatabaseObject) : void
      {
         var _loc2_:* = undefined;
         if(param1 == null)
         {
            DuelModeUI.instance.onLeave(null);
         }
         else
         {
            if(param1.battlestats == null)
            {
               this.getOpponentDataErrorPIO(null);
               return;
            }
            if(param1.skillstats == null)
            {
               param1.skillstats = "";
            }
            if(param1.stratusid == null)
            {
               param1.stratusid = "";
            }
            if(param1.battlestats == null)
            {
               param1.battlestats = "5|10|10|10|1|1|1|0|0|0|0|0|0|0";
            }
            if(param1.online != null && Boolean(param1.online))
            {
               _loc2_ = 0;
            }
            else
            {
               _loc2_ = 10000;
            }
            if(param1.taunt == null)
            {
               param1.taunt = "";
            }
            DuelModeUI.instance.gotOpponentData(param1.battlestats,param1.skillstats,param1.stratusid,_loc2_,param1.taunt);
         }
      }
      
      internal function getOpponentDataErrorPIO(param1:PlayerIOError) : void
      {
         trace("getOpponentData IO error");
         DuelModeUI.instance.onLeave(null);
      }
      
      override public function duelEnd(param1:String, param2:String) : *
      {
         if(this.isMigrator)
         {
            super.duelEnd(param1,param2);
         }
         NetworkManager.instance.reportDuelEnd(param2);
      }
      
      override public function getLeaderboards(param1:int = 0, param2:Boolean = false) : *
      {
         var _loc3_:Object = null;
         if(param1 == 0)
         {
            this.currentPage = 0;
            _loc3_ = null;
            this.hasNextPage = false;
            this.hasPrevPage = false;
            this.pages = new Array();
         }
         else
         {
            if(!(this.hasNextPage && param1 > this.currentPage))
            {
               if(this.hasPrevPage && param1 < this.currentPage)
               {
                  --this.currentPage;
                  this.getLeaderboardsCompletePIO(this.pages[this.currentPage]);
                  return;
               }
               return;
            }
            ++this.currentPage;
            _loc3_ = this.nextStart;
         }
         if(param2)
         {
            this.client.bigDB.loadRange("WeeklyHighScore","ByRating",null,_loc3_,null,11,this.getLeaderboardsCompletePIO,this.getLeaderboardsErrorPIO);
         }
         else
         {
            this.client.bigDB.loadRange("GlobalHighScore","ByRating",null,_loc3_,null,11,this.getLeaderboardsCompletePIO,this.getLeaderboardsErrorPIO);
         }
      }
      
      internal function getLeaderboardsCompletePIO(param1:Array) : void
      {
         var _loc3_:DatabaseObject = null;
         this.pages[this.currentPage] = param1;
         this.hasNextPage = param1.length == 11;
         this.hasPrevPage = this.currentPage > 0;
         if(this.hasNextPage)
         {
            this.nextStart = param1[10].rating;
         }
         var _loc2_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param1.length && _loc4_ < 10)
         {
            _loc3_ = param1[_loc4_];
            if(_loc3_.wins == null)
            {
               _loc3_.wins = 0;
            }
            if(_loc3_.loss == null)
            {
               _loc3_.loss = 0;
            }
            if(_loc3_.draw == null)
            {
               _loc3_.draw = 0;
            }
            _loc2_ += _loc3_.key + "#" + "0" + "#" + _loc3_.wins + "#" + _loc3_.loss + "#" + _loc3_.draw + "#" + "0" + "^";
            _loc4_++;
         }
         if(GameEngine.isTitle())
         {
            LeaderboardUI.instance.setLeaderboard(_loc2_);
         }
         else
         {
            DuelModeUI.instance.setLeaderboard(_loc2_);
         }
      }
      
      internal function getLeaderboardsErrorPIO(param1:PlayerIOError) : void
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
      
      override public function giveItem(param1:String, param2:String, param3:String, param4:int) : *
      {
         if(param3 == "" && param4 == 0)
         {
            return;
         }
         NetworkManager.instance.giveItem(param1,param3,param4);
      }
      
      override public function checkNotifications() : *
      {
         this.client.bigDB.load("Notifications",StatsManager.charname,this.checkNotificationsCallBack);
      }
      
      internal function checkNotificationsCallBack(param1:DatabaseObject) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(StatsManager.giftNotification == "")
         {
            StatsManager.giftNotification = param1.notif;
         }
         else
         {
            StatsManager.giftNotification = StatsManager.giftNotification + "^" + param1.notif;
         }
         if(GameEngine.isAdventureMode() && !OverworldHUD.instance.duelmodeUI.visible && !OverworldHUD.instance.warUI.visible)
         {
            StatsManager.parseGiftNotificationsString();
         }
         this.client.bigDB.deleteKeys("Notifications",[StatsManager.charname]);
      }
      
      public function getPayVaultCoins() : int
      {
         // LOCAL SOLO BUILD: the PlayerIO pay-vault backend is dead, so there
         // are no premium coins. Return 0 instead of throwing.
         if(this.noPayVault)
         {
            return 0;
         }
         try
         {
            if(this.client == null || this.client.payVault == null)
            {
               return 0;
            }
            return this.client.payVault.coins;
         }
         catch(e:Error)
         {
            trace("payvault coins not loaded, need to refresh");
            client.payVault.refresh(function():*
            {
               if(GameEngine.isAdventureMode())
               {
                  OverworldHUD.instance.updateHUD();
               }
            });
         }
         return 0;
      }
      
      public function refreshPayVaultCoins() : *
      {
         if(this.noPayVault)
         {
            return;
         }
         this.client.payVault.refresh(function():*
         {
            if(GameEngine.isAdventureMode())
            {
               OverworldHUD.instance.updateHUD();
            }
         });
      }
      
      public function debitPayVaultCoins(param1:int, param2:Function, param3:Function) : *
      {
         var num:int = param1;
         var callbackSuccess:Function = param2;
         var callbackError:Function = param3;
         if(this.noPayVault)
         {
            return;
         }
         this.client.payVault.debit(num,"",function():*
         {
            NetworkManager.instance.sendRefundTry(num);
            callbackSuccess.call();
         },function():*
         {
            trace("unable to reach server");
            callbackError();
         });
      }
      
      public function buyFBGold(param1:int) : *
      {
         var num:int = param1;
         this.client.payVault.getBuyCoinsInfo("facebookv2",{
            "coinamount":num.toString(),
            "title":num.toString() + " " + LangManager.getString(64),
            "description":LangManager.getString(687),
            "image":"http://www.explosivebarrel.com/duels/facebook/FacebookCredits/gold.png",
            "currencies":"USD"
         },function(param1:Object):void
         {
            var info:Object = param1;
            try
            {
               FB.ui(info,function(param1:Object):void
               {
                  if(param1.status == "completed")
                  {
                     trace("FB Purchase completed!");
                     OverworldHUD.instance.payUI.FBCallback(FacebookCredits.PAYMENT_SUCCEEDED);
                  }
                  else
                  {
                     trace("FB Purchase cancelled.");
                     OverworldHUD.instance.payUI.FBCallback(FacebookCredits.PAYMENT_CANCELLED,param1.status);
                  }
               });
            }
            catch(error:Error)
            {
               trace("use paypal instead");
               OverworldHUD.instance.payUI.paymentselect.hide();
               OverworldHUD.instance.payUI.paymentselect.show(num,OverworldHUD.instance.payUI);
            }
         },function(param1:PlayerIOError):void
         {
            trace("Unable to buy FB coins",param1);
            OverworldHUD.instance.payUI.FBCallback(FacebookCredits.PAYMENT_FAILED);
         });
      }
      
      public function fbRequest(param1:String) : *
      {
         var msg:String = param1;
         FB.ui({
            "method":"apprequests",
            "message":msg
         },function(param1:Object):void
         {
            trace("fbRequest ok");
         });
      }
      
      override internal function shareDuelTV() : *
      {
         var link:String = "http://www.strawhatsamuraiduels.com/watch?name=" + StatsManager.charname;
         FB.ui({
            "method":"feed",
            "name":"Straw Hat Samurai: Duels",
            "link":"http://www.facebook.com/strawhatsamuraiduels",
            "picture":"http://strawhatsamuraiduels.com/facebook/shareimage.gif",
            "caption":"Watch me kick some ass!",
            "description":"Check out my duel on Straw Hat Samurai: Duels TV!",
            "actions":"[{\"name\": \"Watch duel\", \"link\": \"" + link + "\"}]"
         },function(param1:Object):void
         {
            trace("fbShareDuelsTV ok");
         });
      }
      
      override public function reportHack(param1:String) : *
      {
         if(offlineMode)
         {
            return;
         }
         if(hackReported)
         {
            return;
         }
         hackReported = true;
         if(StatsManager.hackReported)
         {
            StatsManager.saveLocation(666);
            StatsManager.setBuff(StatsManager.BUFF_HELL,86400);
         }
         NetworkManager.instance.reportHack(param1);
         OverworldHUD.instance.showCorrupted();
         StatsManager.hackReported = true;
      }
      
      override public function getTerritoryData(param1:int, param2:int) : *
      {
         var territoryId:int;
         var terrX:int = param1;
         var terrY:int = param2;
         if(offlineMode)
         {
            NodeGenerator.instance.gotTerritoryData(terrX,terrY,"0");
            return;
         }
         territoryId = terrX << 12 | terrY;
         this.client.bigDB.load("TerritoryData",territoryId.toString(),function(param1:DatabaseObject):*
         {
            var _loc2_:String = null;
            var _loc3_:String = null;
            var _loc4_:String = null;
            if(param1 == null)
            {
               NodeGenerator.instance.gotTerritoryData(terrX,terrY,"0");
            }
            else
            {
               _loc3_ = "0";
               if(param1.war)
               {
                  _loc3_ = "1";
               }
               _loc4_ = "";
               if(param1.name != null && param1.name != "")
               {
                  _loc4_ = String(param1.name);
               }
               _loc2_ = param1.prosperity + "," + param1.side + "," + _loc4_ + "," + _loc3_ + "," + param1.questdata + "," + param1.encounterdata + "," + param1.battlereports;
               NodeGenerator.instance.gotTerritoryData(terrX,terrY,_loc2_);
            }
         });
      }
      
      override public function getTerritoryGroupData(param1:int, param2:int) : *
      {
         var keys:Array;
         var territoryId:int;
         var i:int = 0;
         var j:int = 0;
         var terrX:int = param1;
         var terrY:int = param2;
         if(offlineMode)
         {
            NodeGenerator.instance.gotTerritoryGroupData(terrX,terrY,"0|0|0|0|0|0|0|0|0");
            return;
         }
         keys = new Array();
         i = terrX - 1;
         while(i <= terrX + 1)
         {
            j = terrY - 1;
            while(j <= terrY + 1)
            {
               keys.push((i << 12 | j).toString());
               j++;
            }
            i++;
         }
         territoryId = terrX << 12 | terrY;
         this.client.bigDB.loadKeys("TerritoryData",keys,function(param1:Array):*
         {
            var _loc4_:DatabaseObject = null;
            var _loc5_:String = null;
            var _loc6_:String = null;
            var _loc7_:* = 0;
            var _loc8_:* = 0;
            var _loc2_:String = "";
            var _loc3_:int = int(param1.length);
            i = 0;
            while(i < _loc3_)
            {
               _loc4_ = param1[i];
               _loc5_ = "0";
               if(_loc4_.war)
               {
                  _loc5_ = "1";
               }
               _loc6_ = "";
               if(_loc4_.name != null && _loc4_.name != "")
               {
                  _loc6_ = String(_loc4_.name);
               }
               _loc2_ = _loc4_.prosperity + "," + _loc4_.side + "," + _loc6_ + "," + _loc5_ + "," + _loc4_.questdata + "," + _loc4_.encounterdata + "," + _loc4_.battlereports;
               _loc7_ = int(_loc4_.key) >> 12 & 4095;
               _loc8_ = int(_loc4_.key) & 4095;
               NodeGenerator.instance.gotTerritoryData(_loc7_,_loc8_,_loc2_);
               ++i;
            }
            GameEngine.initOverworld();
         },function(param1:PlayerIOError):*
         {
            trace(param1);
            client.errorLog.writeError(param1.name,param1.message,param1.getStackTrace(),param1.errorID);
         });
      }
      
      override public function getTownData(param1:int, param2:int) : *
      {
         var territoryId:int;
         var territoryx:int = param1;
         var territoryy:int = param2;
         if(offlineMode)
         {
            return;
         }
         territoryId = territoryx << 12 | territoryy;
         this.client.bigDB.load("TerritoryExtraData",territoryId.toString(),function(param1:DatabaseObject):*
         {
            var territoryData:TerritoryData = null;
            var o:DatabaseObject = param1;
            territoryData = NodeGenerator.instance.getTerritoryData(territoryx,territoryy,true);
            if(StatsManager.isCustomClan(territoryData.getTownSide()))
            {
               loadCustomClanData(territoryData.getTownSide(),function(param1:DatabaseObject):*
               {
                  territoryData.gotCustomClanData(param1);
                  if(o == null)
                  {
                     o = new DatabaseObject(null,null,null,null,null,null);
                  }
                  o.founder = param1.founder;
                  gotTownData(territoryData,o);
               });
            }
            else
            {
               gotTownData(territoryData,o);
            }
         });
      }
      
      internal function gotTownData(param1:TerritoryData, param2:DatabaseObject) : *
      {
         var _loc3_:* = null;
         var _loc4_:String = null;
         if(param2 == null)
         {
            param1.setTerrExtraData(",,",null);
         }
         else
         {
            _loc4_ = "";
            if(param2.founder != null && param2.founder != "")
            {
               _loc4_ = String(param2.founder);
            }
            _loc3_ = _loc4_ + "," + "" + "," + "";
            param1.setTerrExtraData(_loc3_,param2.influence);
         }
         param1.showTownData();
      }
      
      public function getCustomClanTownOwnerName(param1:int, param2:int) : *
      {
         var territoryData:TerritoryData = null;
         var territoryx:int = param1;
         var territoryy:int = param2;
         territoryData = NodeGenerator.instance.getTerritoryData(territoryx,territoryy,true);
         if(StatsManager.isCustomClan(territoryData.getTownSide()))
         {
            this.loadCustomClanData(territoryData.getTownSide(),function(param1:DatabaseObject):*
            {
               territoryData.gotCustomClanData(param1);
            });
         }
      }
      
      override public function updateTownProsperity(param1:int) : *
      {
         var _loc2_:Point = NodeGenerator.instance.getTerritory(QuestGenerator.instance.currentNPCNodeId);
         var _loc3_:int = StatsManager.getSide();
         OverworldHUD.instance.globalVarDialog.updateTownProsperity(param1,_loc3_,_loc2_.x,_loc2_.y);
         if(StatsManager.skipUpdateGlobalVar || offlineMode || NodeGenerator.instance.isNoChangeTown(_loc2_.x << 12 | _loc2_.y))
         {
            trace("skipping town prosperity update: (" + (_loc2_.x - 341) + "," + (_loc2_.y - 341) + ") " + param1);
            return;
         }
         NetworkManager.instance.updateTownProsperity(NodeGenerator.instance.getTerritoryId(QuestGenerator.instance.currentNPCNodeId),_loc3_,param1);
      }
      
      override public function addWarMessage(param1:int, param2:int, param3:int, param4:String, param5:String) : *
      {
         var _loc6_:Object;
         (_loc6_ = new Object()).mapid = param1;
         _loc6_.side = param2;
         _loc6_.charside = param3;
         _loc6_.charname = param4;
         _loc6_.msg = param5;
         _loc6_.created = getServerTime();
         this.client.bigDB.createObject("WarMessageData",null,_loc6_);
      }
      
      override public function getWarMessage(param1:int, param2:int) : *
      {
         var msgArray:Array = null;
         var startTime:int = 0;
         var mapid:int = param1;
         var side:int = param2;
         msgArray = new Array();
         startTime = getServerTime() - 60 * 60 * 24 * 7;
         this.client.bigDB.loadRange("WarMessageData","ByMapIdSideCreated",[mapid,side],startTime,null,1000,function(param1:Array):*
         {
            var array:Array = param1;
            msgArray = msgArray.concat(array);
            client.bigDB.loadRange("WarMessageData","ByMapIdSideCreated",[mapid,0],startTime,null,1000,function(param1:Array):*
            {
               msgArray = msgArray.concat(param1);
               OverworldHUD.instance.warUI.warHexUI.initMessagesPIO(msgArray);
            },function(param1:PlayerIOError):*
            {
               OverworldHUD.instance.warUI.warHexUI.initMessagesPIO(msgArray);
            });
         });
      }
      
      override public function addWarSentry(param1:int, param2:int, param3:int, param4:int, param5:String) : *
      {
         NetworkManager.instance.addWarSentry(param1,param3,param4);
      }
      
      override public function delWarSentry(param1:int, param2:String) : *
      {
         NetworkManager.instance.delWarSentry(param1,param2);
      }
      
      override public function getWarEnemySentry(param1:int, param2:int, param3:int, param4:int) : *
      {
         var mapid:int = param1;
         var xpos:int = param2;
         var ypos:int = param3;
         var side:int = param4;
         var mapid_x_y:String = mapid + "_" + xpos + "_" + ypos;
         this.client.bigDB.loadRange("WarSentryData","ByMapIdXYSide",[mapid_x_y,side],null,null,10,function(param1:Array):*
         {
            OverworldHUD.instance.warUI.warHexUI.startBattlePIO(param1);
         },function(param1:PlayerIOError):*
         {
            trace(param1);
         });
      }
      
      override public function getWarMaps(param1:int, param2:Boolean = true) : *
      {
         var checkGotWarMaps:Function = null;
         var side:int = param1;
         var getWorld:Boolean = param2;
         checkGotWarMaps = function():*
         {
            ++warmapDataCounter;
            if(warmapDataCounter == 4)
            {
               OverworldHUD.instance.warUI.initWarMarkers(warmapData[WAR_TERRITORYOWNERS],warmapData[WAR_SELFSENTRY],warmapData[WAR_SPAWNPOINTS],warmapData[WAR_NEXTUPDATE],warmapData[WAR_MAINTENANCE]);
               warmapDataCounter = 0;
            }
         };
         if(this.warmapDataCounter > 0)
         {
            trace("getWarMaps already in progress");
            return;
         }
         ++this.warmapDataCounter;
         if(getWorld)
         {
            this.client.bigDB.load("GeneralData","WarRoomState",function(param1:DatabaseObject):*
            {
               var _loc4_:int = 0;
               warmapData[WAR_TERRITORYOWNERS] = param1.territoryowners;
               warmapData[WAR_NEXTUPDATE] = param1.nextupdate;
               warmapData[WAR_MAINTENANCE] = param1.maintenance;
               var _loc2_:String = String(param1.territoryowners);
               var _loc3_:int = _loc2_.length;
               var _loc5_:IntMap = new IntMap();
               var _loc6_:int = 0;
               while(_loc6_ < _loc3_)
               {
                  _loc4_ = _loc2_.charAt(_loc6_).charCodeAt(0) - WORLDSTATESTR_ASCIIADD;
                  if(StatsManager.isCustomClan(_loc4_))
                  {
                     _loc5_.put(_loc4_,_loc4_.toString(),true);
                  }
                  _loc6_++;
               }
               var _loc7_:Array = _loc5_.getValues();
               loadCustomClanDataRange(_loc7_,checkGotWarMaps);
               OverworldHUD.instance.worldMapUI.setWorldState(warmapData[WAR_TERRITORYOWNERS]);
            },function(param1:PlayerIOError):*
            {
               trace(param1);
            });
         }
         else
         {
            this.warmapData[WAR_TERRITORYOWNERS] = "";
            this.warmapData[WAR_NEXTUPDATE] = "";
            checkGotWarMaps();
         }
         this.client.bigDB.load("WarSentryData",StatsManager.charname,function(param1:DatabaseObject):*
         {
            if(param1 != null && param1.mapid_x_y != null)
            {
               warmapData[WAR_SELFSENTRY] = param1.mapid_x_y.split("_").join(",");
            }
            else
            {
               warmapData[WAR_SELFSENTRY] = "";
            }
            checkGotWarMaps();
         },function(param1:PlayerIOError):*
         {
            trace(param1);
         });
         this.client.bigDB.loadRange("WarSpawnPointData","ByMapId",null,null,null,1000,function(param1:Array):*
         {
            var _loc2_:DatabaseObject = null;
            var _loc6_:String = null;
            var _loc3_:int = int(param1.length);
            var _loc4_:String = "";
            var _loc5_:int = 0;
            while(_loc5_ < _loc3_)
            {
               _loc2_ = param1[_loc5_];
               _loc6_ = _loc2_.mapid + "," + _loc2_.side + "," + _loc2_.state + "," + _loc2_.x + "," + _loc2_.y;
               if(_loc4_ == "")
               {
                  _loc4_ = _loc6_;
               }
               else
               {
                  _loc4_ = _loc4_ + "|" + _loc6_;
               }
               _loc5_++;
            }
            warmapData[WAR_SPAWNPOINTS] = _loc4_;
            checkGotWarMaps();
         },function(param1:PlayerIOError):*
         {
            trace(param1);
         });
      }
      
      public function getSpawnPoints() : *
      {
         this.client.bigDB.loadRange("WarSpawnPointData","ByMapId",null,null,null,1000,function(param1:Array):*
         {
            var _loc2_:DatabaseObject = null;
            var _loc6_:String = null;
            var _loc3_:int = int(param1.length);
            var _loc4_:String = "";
            var _loc5_:int = 0;
            while(_loc5_ < _loc3_)
            {
               _loc2_ = param1[_loc5_];
               _loc6_ = _loc2_.mapid + "," + _loc2_.side + "," + _loc2_.state + "," + _loc2_.x + "," + _loc2_.y;
               if(_loc4_ == "")
               {
                  _loc4_ = _loc6_;
               }
               else
               {
                  _loc4_ = _loc4_ + "|" + _loc6_;
               }
               _loc5_++;
            }
            OverworldHUD.instance.warUI.updateSpawnPoints(_loc4_);
         },function(param1:PlayerIOError):*
         {
            trace(param1);
         });
      }
      
      public function getCrops(param1:int, param2:Function) : *
      {
         var key:String = null;
         var side:int = param1;
         var callback:Function = param2;
         if(side == 1)
         {
            key = "50000";
         }
         else if(side == 2)
         {
            key = "50001";
         }
         else if(side == 3)
         {
            key = "50002";
         }
         else
         {
            if(side != 4)
            {
               callback(0);
               return;
            }
            key = "50003";
         }
         this.client.bigDB.load("GeneralData",key,function(param1:DatabaseObject):*
         {
            var _loc2_:int = 0;
            if(param1 != null)
            {
               _loc2_ = int(param1.value);
            }
            callback(_loc2_);
         },function(param1:PlayerIOError):*
         {
            trace(param1);
         });
      }
      
      public function getAllCrops(param1:Function) : *
      {
         var callback:Function = param1;
         this.client.bigDB.loadKeys("GeneralData",["50000","50001","50002","50003"],function(param1:Array):*
         {
            var _loc4_:DatabaseObject = null;
            var _loc2_:int = int(param1.length);
            var _loc3_:Array = [0,0,0,0];
            var _loc5_:int = 0;
            while(_loc5_ < _loc2_)
            {
               if((_loc4_ = param1[_loc5_]).key == "50000")
               {
                  _loc3_[0] = _loc4_.value;
               }
               else if(_loc4_.key == "50001")
               {
                  _loc3_[1] = _loc4_.value;
               }
               else if(_loc4_.key == "50002")
               {
                  _loc3_[2] = _loc4_.value;
               }
               else if(_loc4_.key == "50003")
               {
                  _loc3_[3] = _loc4_.value;
               }
               _loc5_++;
            }
            callback(_loc3_);
         });
      }
      
      public function getWorldMapTerritoryOwners() : *
      {
         this.client.bigDB.load("GeneralData","WarRoomState",function(param1:DatabaseObject):*
         {
            var _loc4_:int = 0;
            warmapData[WAR_TERRITORYOWNERS] = param1.territoryowners;
            warmapData[WAR_NEXTUPDATE] = param1.nextupdate;
            warmapData[WAR_MAINTENANCE] = param1.maintenance;
            var _loc2_:String = String(param1.territoryowners);
            var _loc3_:int = _loc2_.length;
            var _loc5_:IntMap = new IntMap();
            var _loc6_:int = 0;
            while(_loc6_ < _loc3_)
            {
               _loc4_ = _loc2_.charAt(_loc6_).charCodeAt(0) - WORLDSTATESTR_ASCIIADD;
               if(StatsManager.isCustomClan(_loc4_))
               {
                  _loc5_.put(_loc4_,_loc4_.toString(),true);
               }
               _loc6_++;
            }
            var _loc7_:Array = _loc5_.getValues();
            loadCustomClanDataRange(_loc7_,gotWorldMapTerritoryOwners);
         },function(param1:PlayerIOError):*
         {
            trace(param1);
         });
      }
      
      internal function gotWorldMapTerritoryOwners() : *
      {
         OverworldHUD.instance.worldMapUI.initWorldMapMarkers(this.warmapData[WAR_TERRITORYOWNERS]);
      }
      
      override public function getWarHexMap(param1:int, param2:int) : *
      {
         var mapid:int = param1;
         var side:int = param2;
         this.client.bigDB.load("TerritoryData",mapid.toString(),function(param1:DatabaseObject):*
         {
            var townname:String = null;
            var tdata:String = null;
            var o:DatabaseObject = param1;
            if(o == null)
            {
               OverworldHUD.instance.warUI.initWarHexMap("","0");
            }
            else
            {
               townname = "";
               if(o.name != null && o.name != "")
               {
                  townname = String(o.name);
               }
               tdata = o.prosperity + "," + o.side + "," + townname + ",";
               if(o.war)
               {
                  tdata += "1";
               }
               else
               {
                  tdata += "0";
               }
               if(!o.war)
               {
                  OverworldHUD.instance.warUI.initWarHexMap("",tdata);
               }
               else
               {
                  client.bigDB.loadRange("WarHexData","ByMapId",[mapid],null,null,1000,function(param1:Array):*
                  {
                     var max:int;
                     var troops:Array = null;
                     var hexstr:String = null;
                     var o:DatabaseObject = null;
                     var str:String = null;
                     var array:Array = param1;
                     troops = new Array(6);
                     var i:int = 0;
                     while(i < 6)
                     {
                        troops[i] = new Array(6);
                        i++;
                     }
                     hexstr = "";
                     max = int(array.length);
                     i = 0;
                     while(i < max)
                     {
                        o = array[i];
                        str = o.x + "," + o.y + "," + o.owner + "," + "" + "," + o.type + "," + o.cost + ",";
                        if(o.troops[side] != null)
                        {
                           str += o.troops[side];
                        }
                        else
                        {
                           str += "0";
                        }
                        if(hexstr == "")
                        {
                           hexstr = str;
                        }
                        else
                        {
                           hexstr += "|" + str;
                        }
                        troops[o.x][o.y] = o.troops;
                        i++;
                     }
                     client.bigDB.load("CastleGates",mapid.toString(),function(param1:DatabaseObject):*
                     {
                        var _loc2_:int = 0;
                        if(param1 != null && param1.opened != null)
                        {
                           _loc2_ = int(param1.opened);
                        }
                        OverworldHUD.instance.warUI.initWarHexMap(hexstr,tdata,troops,_loc2_);
                     });
                  },function(param1:PlayerIOError):*
                  {
                     trace(param1);
                     tdata = o.prosperity + "," + o.side + "," + o.townname + ",0";
                     OverworldHUD.instance.warUI.initWarHexMap("",tdata);
                  });
               }
            }
         },function(param1:PlayerIOError):*
         {
            trace(param1);
            OverworldHUD.instance.warUI.initWarHexMap("","0");
         });
      }
      
      override public function getWarHexData(param1:int, param2:int, param3:int, param4:int) : *
      {
         var mapid:int = param1;
         var xpos:int = param2;
         var ypos:int = param3;
         var side:int = param4;
         var key:String = mapid + "_" + xpos + "_" + ypos;
         this.client.bigDB.loadRange("WarSentryData","ByMapIdXYSide",[key,side],null,null,1000,function(param1:Array):*
         {
            var _loc2_:DatabaseObject = null;
            var _loc6_:String = null;
            var _loc7_:Array = null;
            var _loc3_:int = int(param1.length);
            var _loc4_:String = "";
            var _loc5_:int = 0;
            while(_loc5_ < _loc3_)
            {
               _loc2_ = param1[_loc5_];
               if((_loc6_ = _loc2_.key).substr(0,4) == "bot_")
               {
                  _loc7_ = _loc6_.split("_");
                  _loc6_ = NameGenerator.getInstance().getSentryBotName(new RNG(int(_loc7_[1]) * 130 + int(_loc7_[2]) * 11));
               }
               _loc4_ += _loc6_ + "," + _loc2_.playerlevel + "|";
               _loc5_++;
            }
            OverworldHUD.instance.warUI.warHexUI.initWarHexDataPIO(_loc4_);
         },function(param1:PlayerIOError):*
         {
            trace(param1);
            OverworldHUD.instance.warUI.warHexUI.initWarHexDataPIO("");
         });
      }
      
      override public function setWarHex(param1:int, param2:int, param3:int, param4:int, param5:int) : *
      {
         NetworkManager.instance.setWarHex(param1,param2,param3,param4,param5);
      }
      
      override public function startBuild(param1:int, param2:int, param3:int, param4:int) : *
      {
         NetworkManager.instance.startBuild(param1,param2,param3,param4);
      }
      
      override public function doBuild(param1:int, param2:int, param3:int, param4:int) : *
      {
         NetworkManager.instance.doBuild(param1,param2,param3,param4);
      }
      
      override public function createSpawnPoint(param1:int, param2:int, param3:int, param4:int, param5:String, param6:Boolean) : *
      {
         NetworkManager.instance.createSpawnPoint(param1,param2,param3,param4,param5,param6);
      }
      
      override public function destroySpawnPoint(param1:int, param2:int, param3:int) : *
      {
         NetworkManager.instance.destroySpawnPoint(param1,param2,param3);
      }
      
      public function getCastleGateOpened(param1:int, param2:Function) : *
      {
         var territoryId:int = param1;
         var callback:Function = param2;
         this.client.bigDB.load("CastleGates",territoryId.toString(),function(param1:DatabaseObject):*
         {
            if(param1 == null)
            {
               callback(0);
            }
            else if(param1.opened != null)
            {
               callback(param1.opened);
            }
            else
            {
               callback(0);
            }
         });
      }
      
      public function setCastleGateOpened(param1:int) : *
      {
         var territoryId:int = param1;
         this.client.bigDB.loadKeysOrCreate("CastleGates",[territoryId.toString()],function(param1:Array):*
         {
            var _loc2_:DatabaseObject = param1[0];
            _loc2_.opened = getServerTime();
            _loc2_.save();
         });
      }
      
      override public function saveReplay(param1:String, param2:String, param3:String, param4:int) : *
      {
         var name1:String = param1;
         var name2:String = param2;
         var data:String = param3;
         var win:int = param4;
         var newo:Object = new Object();
         newo.player1 = name1;
         newo.player2 = name2;
         newo.data = data;
         newo.created = getServerTime();
         newo.win = win;
         newo.views = 0;
         newo.randomindex = int(Math.random() * 30000);
         this.client.bigDB.createObject("ReplayData",null,newo,function(param1:DatabaseObject):*
         {
            WinUI.instance.replaySaved();
            LoseUI.instance.replaySaved();
            if(StatsManager.isFacebook() && QueryManagerPIO.instance.facebookTokenLogin)
            {
               shareDuelTV();
            }
         });
      }
      
      public function playbackClientLogin(param1:String, param2:String) : *
      {
         var pbid:String = param1;
         var pbname:String = param2;
         PlayerIO.quickConnect.simpleConnect(StatsManager.mainTimeLine.stage,this.gameid,"guest","password",function(param1:Client):void
         {
            client = param1;
            if(pbid != null && pbid != "")
            {
               getReplay(pbid);
            }
            else if(pbname != null && pbname != "")
            {
               getReplayByName(pbname);
            }
            else
            {
               getReplay("0");
            }
         },function(param1:PlayerIOError):void
         {
            trace("Error: ",param1);
         });
      }
      
      internal function informWatchPage(param1:DatabaseObject) : *
      {
         ExternalInterface.call("informWatchPage",param1.key,param1.views,param1.player1,param1.player2);
      }
      
      override public function getReplay(param1:String) : *
      {
         var id:String = param1;
         if(id == "0")
         {
            this.client.bigDB.loadRange("ReplayData","ByRandom",null,int(Math.random() * 30000),null,1,function(param1:Array):*
            {
               if(param1.length == 0)
               {
                  if(GameEngine.isPlayBackClient())
                  {
                     getReplay("0");
                  }
                  else
                  {
                     OverworldHUD.instance.showDialog(LangManager.getString(484),LangManager.getString(5));
                  }
               }
               else
               {
                  GameEngine.hideLoadingScreen();
                  NetworkManager.instance.playRecording(param1[0].data);
                  param1[0].views += 1;
                  param1[0].save();
                  if(GameEngine.isPlayBackClient() && !StatsManager.skipUpdateGlobalVar)
                  {
                     informWatchPage(param1[0]);
                  }
               }
            },function(param1:PlayerIOError):*
            {
               trace(param1);
               if(!GameEngine.isPlayBackClient())
               {
                  GameEngine.hideLoadingScreen();
               }
            });
         }
         else
         {
            this.client.bigDB.load("ReplayData",id,function(param1:DatabaseObject):*
            {
               if(param1 == null)
               {
                  if(GameEngine.isPlayBackClient())
                  {
                     getReplay("0");
                  }
                  else
                  {
                     OverworldHUD.instance.showDialog(LangManager.getString(484),LangManager.getString(5));
                  }
               }
               else
               {
                  GameEngine.hideLoadingScreen();
                  NetworkManager.instance.playRecording(param1.data);
                  param1.views += 1;
                  param1.save();
                  if(GameEngine.isPlayBackClient() && !StatsManager.skipUpdateGlobalVar)
                  {
                     informWatchPage(param1);
                  }
               }
            },function(param1:PlayerIOError):*
            {
               trace(param1);
               if(!GameEngine.isPlayBackClient())
               {
                  GameEngine.hideLoadingScreen();
               }
            });
         }
      }
      
      override public function getReplayByName(param1:String) : *
      {
         var charname:String = param1;
         this.client.bigDB.loadRange("ReplayData","ByCharnameCreated",[charname],null,null,1,function(param1:Array):*
         {
            if(param1.length == 0)
            {
               if(GameEngine.isPlayBackClient())
               {
                  getReplay("0");
               }
               else
               {
                  OverworldHUD.instance.showDialog(LangManager.getString(484),LangManager.getString(5));
               }
            }
            else
            {
               trace(param1[0].key);
               GameEngine.hideLoadingScreen();
               NetworkManager.instance.playRecording(param1[0].data);
               param1[0].views += 1;
               param1[0].save();
               if(GameEngine.isPlayBackClient())
               {
                  informWatchPage(param1[0]);
               }
            }
         },function(param1:PlayerIOError):*
         {
            trace(param1);
            if(!GameEngine.isPlayBackClient())
            {
               GameEngine.hideLoadingScreen();
            }
         });
      }
      
      override public function updateGlobalVar(param1:int, param2:int) : *
      {
         OverworldHUD.instance.globalVarDialog.addGlobalVar(param1,param2);
         if(StatsManager.skipUpdateGlobalVar || offlineMode)
         {
            trace("skipping global var update: " + param1 + " " + param2);
            return;
         }
         if(param1 == 50005 || param1 == 50006)
         {
            return;
         }
         NetworkManager.instance.updateGlobalVar(param1,param2);
      }
      
      override public function getGlobalVar(param1:int) : *
      {
         var varid:int = param1;
         this.client.bigDB.load("GeneralData",varid.toString(),function(param1:DatabaseObject):*
         {
            trace(param1.value);
         },function(param1:PlayerIOError):*
         {
            trace(0);
         });
      }
      
      public function getRecentEvents(param1:int) : *
      {
         var tx:int = 0;
         var ty:int = 0;
         var mapid:int = param1;
         this.client.bigDB.loadRange("WorldSimHistory","ByMapId",[mapid],null,null,3,function(param1:Array):*
         {
            tx = mapid >> 12 & 4095;
            ty = mapid & 4095;
            NodeGenerator.instance.getTerritoryData(tx,ty,false).gotRecentEvents(param1);
         },function(param1:PlayerIOError):*
         {
            trace(param1);
            tx = mapid >> 12 & 4095;
            ty = mapid & 4095;
            NodeGenerator.instance.getTerritoryData(tx,ty,false).gotRecentEvents(null);
         });
      }
      
      override public function whois(param1:String) : *
      {
         if(offlineMode)
         {
            return;
         }
         NetworkManager.instance.connectionGlobalPIO.send("whois",param1);
      }
      
      override public function getPlayerLocation(param1:String) : *
      {
         if(offlineMode)
         {
            return;
         }
         NetworkManager.instance.connectionGlobalPIO.send("whereis",param1);
      }
      
      public function showAllOnline() : *
      {
         this.client.bigDB.loadRange("OnlinePlayers","ByRoomId",null,null,null,100,function(param1:Array):*
         {
            if(param1.length == 100)
            {
               OverworldHUD.instance.updateChatLogWordsOnly(">100 players found","#FFCC00");
            }
            else
            {
               OverworldHUD.instance.updateChatLogWordsOnly(param1.length + " player(s) found","#FFCC00");
            }
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               OverworldHUD.instance.updateChatLogWordsOnly(param1[_loc2_].key,"#FFFFFF");
               _loc2_++;
            }
         },function(param1:PlayerIOError):*
         {
            trace(param1);
         });
      }
      
      override internal function checkTimeSkip() : *
      {
         if(StatsManager.nextWarTurn - serverTime > StatsManager.WARMOVEINTERVAL)
         {
            StatsManager.nextWarTurn = serverTime;
            this.playerObj.warupdate = StatsManager.nextWarTurn;
         }
         if(StatsManager.nextAPUpdate - serverTime > StatsManager.APINTERVAL)
         {
            StatsManager.nextAPUpdate = serverTime;
            this.playerObj.apupdate = StatsManager.nextAPUpdate;
         }
         if(StatsManager.nextDTUpdate - serverTime > StatsManager.DTINTERVAL)
         {
            StatsManager.nextDTUpdate = serverTime;
            this.playerObj.dtupdate = StatsManager.nextDTUpdate;
         }
         this.playerObj.save();
      }
      
      override public function changeName(param1:String) : *
      {
         if(offlineMode)
         {
            return;
         }
         NetworkManager.instance.changeName(param1);
      }
      
      public function loadCustomClanData(param1:int, param2:Function = null) : *
      {
         var clanId:int = param1;
         var callback:Function = param2;
         if(callback != null && this.clanDataCache.contains(clanId))
         {
            callback(this.clanDataCache.get(clanId));
            return;
         }
         this.client.bigDB.load("ClanData",clanId.toString(),function(param1:DatabaseObject):*
         {
            if(param1 == null)
            {
               param1 = new DatabaseObject(null,null,null,null,null,null);
               param1.clanname = "?";
               param1.color = 3355443;
               param1.logo = 1;
               param1.logocolor = 13421772;
               param1.acronym = "???";
               param1.owned = 0;
               param1.founder = "?";
            }
            if(clanId == StatsManager.getSide())
            {
               StatsManager.initCustomClan(param1.clanname,param1.color,param1.logo,param1.logocolor,param1.acronym,param1.founder,param1.owned);
            }
            clanDataCache.put(clanId,param1);
            if(callback != null)
            {
               callback(param1);
            }
         });
      }
      
      public function loadCustomClanDataRange(param1:Array, param2:Function) : *
      {
         var keys:Array = param1;
         var callback:Function = param2;
         if(keys == null || keys.length == 0)
         {
            callback();
            return;
         }
         this.client.bigDB.loadKeys("ClanData",keys,function(param1:Array):*
         {
            var _loc3_:DatabaseObject = null;
            var _loc2_:int = int(param1.length);
            var _loc4_:int = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = param1[_loc4_];
               clanDataCache.put(int(_loc3_.key),_loc3_,true);
               _loc4_++;
            }
            callback();
         },function(param1:PlayerIOError):*
         {
            callback();
         });
      }
      
      public function hasCustomClanData(param1:int) : Boolean
      {
         return this.clanDataCache.contains(param1);
      }
      
      public function getCustomClanData(param1:int) : DatabaseObject
      {
         return this.clanDataCache.get(param1);
      }
      
      public function updateCustomClanData(param1:int, param2:String, param3:int, param4:int, param5:int, param6:String, param7:String, param8:int) : *
      {
         var _loc9_:DatabaseObject;
         if((_loc9_ = this.clanDataCache.get(param1)) != null)
         {
            _loc9_.clanname = param2;
            _loc9_.color = param3;
            _loc9_.logo = param4;
            _loc9_.logocolor = param5;
            _loc9_.acronym = param6;
            _loc9_.founder = param7;
            _loc9_.owned = param8;
         }
      }
      
      public function getStoredLegendaryItem(param1:int, param2:Function) : *
      {
         var level:int = param1;
         var callback:Function = param2;
         this.client.bigDB.loadRange("ItemData","ByLevel",null,[level],[level + 3],100,function(param1:Array):*
         {
            if(param1.length == 0)
            {
               callback(new Item(2128));
            }
            var _loc2_:int = Math.random() * param1.length;
            callback(Item.parseNoQty(param1[_loc2_].itemdata));
         });
      }
      
      override public function reportGotGold(param1:int, param2:String) : *
      {
         if(StatsManager.skipUpdateGlobalVar || offlineMode)
         {
            return;
         }
         super.reportGotGold(param1,param2);
         var _loc3_:Object = new Object();
         _loc3_.publisherId = GameEngine.getPublisherId();
         var _loc4_:Number = 0;
         if(param1 == 10)
         {
            _loc4_ = 5;
         }
         else if(param1 == 25)
         {
            _loc4_ = 5;
         }
         else if(param1 == 40)
         {
            _loc4_ = 15;
         }
         else if(param1 == 55)
         {
            _loc4_ = 20;
         }
         else if(param1 == 75)
         {
            _loc4_ = 50;
         }
         _loc3_.amount = _loc4_;
         var _loc5_:Number = new Date().getTime();
         _loc3_.dateTime = _loc5_;
         _loc3_.processed = false;
         this.client.bigDB.createObject("EpicPayHistory",null,_loc3_);
      }
   }
}
