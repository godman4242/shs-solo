package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="LoginForm")]
   public class LoginForm extends MovieClip
   {
       
      
      public var playonlineButton:YellowButton;
      
      public var errormessage:TextField;
      
      public var usernamefield:TextField;
      
      public var usernamelabel:TextField;
      
      public var passwordfield:TextField;
      
      public var resendbutton:YellowButtonSmall;
      
      public var facebookLoginButton:SimpleButton;
      
      public var passwordlabel:TextField;
      
      public var guestButton:YellowButton;
      
      public var registrationtext:TextField;
      
      public var registerButton:YellowButtonSmall;
      
      public var loginButton:YellowButtonSmall;
      
      public var reregistertext:TextField;
      
      public function LoginForm()
      {
         super();
         this.passwordfield.displayAsPassword = true;
         this.registrationtext.visible = false;
         this.resendbutton.visible = false;
         LangManager.initTextField(this.usernamelabel);
         this.usernamelabel.text = LangManager.getString(12) + "/" + LangManager.getString(15);
         LangManager.initTextField(this.passwordlabel);
         this.passwordlabel.text = LangManager.getString(13);
         this.registerButton.setText(LangManager.getString(16));
         this.loginButton.setText(LangManager.getString(53));
         LangManager.initTextField(this.errormessage);
         this.errormessage.text = "";
         LangManager.initTextField(this.registrationtext);
         this.registrationtext.text = LangManager.getString(54);
         this.resendbutton.setText(LangManager.getString(51));
         this.guestButton.setText(LangManager.getString(296));
         this.playonlineButton.setText(LangManager.getString(304));
         this.playonlineButton.visible = false;
         this.facebookLoginButton.visible = StatsManager.usePlayerIO;
         this.reregistertext.visible = false;
         if(StatsManager.offlineModeOnly)
         {
            this.usernamefield.visible = false;
            this.passwordfield.visible = false;
            this.usernamelabel.visible = false;
            this.passwordlabel.visible = false;
            this.loginButton.visible = false;
            this.registerButton.visible = false;
            this.errormessage.visible = false;
            this.facebookLoginButton.visible = false;
            this.playonlineButton.visible = true;
            this.guestButton.x = 50;
            this.guestButton.y = 0;
            this.playonlineButton.x = 50;
            this.playonlineButton.y = 35;
         }
         else if(StatsManager.isKongregate)
         {
            this.usernamefield.visible = false;
            this.passwordfield.visible = false;
            this.usernamelabel.visible = false;
            this.passwordlabel.visible = false;
            this.loginButton.visible = false;
            this.registerButton.visible = false;
            this.errormessage.visible = false;
            this.facebookLoginButton.visible = false;
            this.playonlineButton.visible = true;
            this.guestButton.visible = false;
            this.playonlineButton.setText("Log In");
            this.playonlineButton.x = 50;
            this.playonlineButton.y = 0;
         }
         else if(StatsManager.usePlayerIO)
         {
            this.guestButton.y = 310;
            if(!QueryManagerPIO.instance.needEmailVerification)
            {
               this.guestButton.visible = false;
            }
         }
      }
      
      public function reAddListeners() : *
      {
         this.loginButton.addEventListener(MouseEvent.CLICK,this.login);
         this.registerButton.addEventListener(MouseEvent.CLICK,this.register);
         this.resendbutton.addEventListener(MouseEvent.CLICK,this.resendemail);
         this.guestButton.addEventListener(MouseEvent.CLICK,this.playasguest);
         this.playonlineButton.addEventListener(MouseEvent.CLICK,this.playonline);
         this.facebookLoginButton.addEventListener(MouseEvent.CLICK,this.facebookLogin);
         this.registerButton.addEventListeners();
         this.loginButton.addEventListeners();
         this.resendbutton.addEventListeners();
         this.guestButton.addEventListeners();
         this.playonlineButton.addEventListeners();
      }
      
      internal function removeListeners() : *
      {
         this.loginButton.removeEventListener(MouseEvent.CLICK,this.login);
         this.registerButton.removeEventListener(MouseEvent.CLICK,this.register);
         this.resendbutton.removeEventListener(MouseEvent.CLICK,this.resendemail);
         this.guestButton.removeEventListener(MouseEvent.CLICK,this.playasguest);
         this.playonlineButton.removeEventListener(MouseEvent.CLICK,this.playonline);
         this.facebookLoginButton.removeEventListener(MouseEvent.CLICK,this.facebookLogin);
         this.registerButton.removeEventListeners();
         this.loginButton.removeEventListeners();
         this.resendbutton.removeEventListeners();
         this.guestButton.removeEventListeners();
         this.playonlineButton.removeEventListeners();
      }
      
      internal function login(param1:MouseEvent) : void
      {
         if(this.usernamefield.text == "" || this.passwordfield.text == "")
         {
            this.errormessage.text = LangManager.getString(18);
         }
         else
         {
            this.removeListeners();
            TitleUI.instance.loadingScreenOn();
            if(OverworldHUD.instance != null)
            {
               OverworldHUD.instance = null;
            }
            QueryManager.instance.offlineMode = false;
            if(NetworkManager.instance != null && !NetworkManager.instance.connected)
            {
               NetworkManager.instance.init();
            }
            StatsManager.showFriends = true;
            QueryManager.instance.login(this.usernamefield.text,this.passwordfield.text);
         }
      }
      
      public function playasguest(param1:MouseEvent) : *
      {
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
         QueryManager.instance.login("Guest","pass");
      }
      
      internal function playonline(param1:MouseEvent) : *
      {
         if(StatsManager.isKongregate)
         {
            Kongregate.instance.login();
         }
         else
         {
            QueryManager.instance.showPlayOnlineWebsite();
         }
      }
      
      internal function facebookLogin(param1:MouseEvent) : *
      {
         QueryManagerPIO.instance.loginFacebook();
      }
      
      internal function serverResponse(param1:*) : int
      {
         if(!visible)
         {
            visible = true;
         }
         switch(param1)
         {
            case 0:
               if(!QueryManager.instance.offlineMode)
               {
                  QueryManager.instance.saveLogin(this.usernamefield.text,this.passwordfield.text);
                  TitleUI.instance.switchToReady();
               }
               else
               {
                  // LOCAL SOLO BUILD: in offline mode the game normally jumps to
                  // Character Create, whose form assets are missing in this build
                  // (CreateCharForm.reAddListeners -> Error #1009). Go to the
                  // character-select screen instead, which is the normal path.
                  visible = false;
                  TitleUI.instance.switchToReady();
               }
               return 0;
            case 1:
               this.reAddListeners();
               TitleUI.instance.loadingScreenOff();
               this.errormessage.text = LangManager.getString(55);
               return 1;
            case 2:
               this.reAddListeners();
               TitleUI.instance.loadingScreenOff();
               this.errormessage.text = LangManager.getString(56);
               this.resendbutton.visible = true;
               return 2;
            case 4:
               TitleUI.instance.setLoadingScreenTextBig(LangManager.getString(646));
               return 4;
            case 5:
               TitleUI.instance.setLoadingScreenTextBig("Facebook login error. Please PM us for help.");
               return 5;
            case 6:
               TitleUI.instance.setLoadingScreenTextBig("Facebook login error 2. Please PM us for help.");
               return 5;
            case 7:
               TitleUI.instance.setLoadingScreenTextBig("SpilGames login error. Please PM us for help.");
               return 5;
            case 3:
         }
         this.reAddListeners();
         TitleUI.instance.loadingScreenOff();
         this.errormessage.text = LangManager.getString(24);
         return 3;
      }
      
      public function serverErrorMessage(param1:String) : *
      {
         if(!visible)
         {
            visible = true;
         }
         this.reAddListeners();
         TitleUI.instance.loadingScreenOff();
         this.errormessage.text = param1;
      }
      
      internal function register(param1:MouseEvent) : void
      {
         TitleUI.instance.switchToRegister();
      }
      
      internal function resendemail(param1:MouseEvent) : void
      {
         TitleUI.instance.switchToResend();
      }
   }
}
