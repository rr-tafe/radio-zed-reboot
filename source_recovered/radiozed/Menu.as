package
{
   import org.flixel.data.FlxPanel;
   import org.flixel.*;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class Menu extends FlxState
   {
      
      private var Img_clear_data_Graphic:Class;
      
      private var ImgCredits:Class;
      
      private var Img_clear_data_Graphic_Light:Class;
      
      private var ImgSponsorLogo:Class;
      
      private var ImgHelp_close_button_light:Class;
      
      private var bob:Boolean = false;
      
      private var Img_main_menu_button_light:Class;
      
      private var ImgHelpWindow:Class;
      
      private var ImgCursor:Class;
      
      private var ImgSponsorLogo_light:Class;
      
      private var start:FlxButton;
      
      private var shared:SharedObject;
      
      private var SndMenuClick:Class;
      
      private var Img_dialog:Class;
      
      private var Img_dialog_button:Class;
      
      private var backGround_Img:Class;
      
      private var ImgButton:Class;
      
      private var blackScreenImg:Class;
      
      private var _cursor:FlxSprite;
      
      private var ImgMenuSign:Class;
      
      public function Menu()
      {
         var bobText:String;
         var sponsorLogo_Graphic_light:FlxSprite;
         var menu_button_Graphic:FlxSprite;
         var FlxPanel1:FlxPanel;
         var ver:FlxText;
         var menuText:FlxText;
         var clear_data_Graphic_Light:FlxSprite;
         var bob:FlxText;
         var backGround:FlxSprite;
         var menu_button_Graphic_Light:FlxSprite;
         var MenuSign:FlxSprite;
         var sponsorLogo:FlxButton;
         var sponsorLogo_Graphic:FlxSprite;
         var clear_data_Graphic:FlxSprite;
         var menu_button_PlayGame:FlxButton = null;
         var menu_button_PlayGame_Push:Function = null;
         var menu_button_Continue:FlxButton = null;
         var menu_button_Continue_Push:Function = null;
         var menu_button_More_games:FlxButton = null;
         var menu_button_More_games_Push:Function = null;
         var menu_button_Credits:FlxButton = null;
         var menu_button_Credits_Push:Function = null;
         var menu_button_Achivement:FlxButton = null;
         var menu_button_Achivement_Push:Function = null;
         var clear_data_button:FlxButton = null;
         var clear_data_fun:Function = null;
         var menu_button_Logo_Push:Function = null;
         this.ImgCursor = Menu_ImgCursor;
         this.ImgButton = Menu_ImgButton;
         this.backGround_Img = Menu_backGround_Img;
         this.Img_main_menu_button_light = Menu_Img_main_menu_button_light;
         this.Img_clear_data_Graphic = Menu_Img_clear_data_Graphic;
         this.Img_clear_data_Graphic_Light = Menu_Img_clear_data_Graphic_Light;
         this.blackScreenImg = Menu_blackScreenImg;
         this.Img_dialog = Menu_Img_dialog;
         this.Img_dialog_button = Menu_Img_dialog_button;
         this.ImgHelpWindow = Menu_ImgHelpWindow;
         this.ImgMenuSign = Menu_ImgMenuSign;
         this.ImgCredits = Menu_ImgCredits;
         this.ImgHelp_close_button_light = Menu_ImgHelp_close_button_light;
         this.ImgSponsorLogo = Menu_ImgSponsorLogo;
         this.ImgSponsorLogo_light = Menu_ImgSponsorLogo_light;
         this.SndMenuClick = Menu_SndMenuClick;
         super();
         menu_button_PlayGame_Push = function():void
         {
            var deleteDataPush:Function = null;
            var cancelDataPush:Function = null;
            var backBlackScreen:FlxSprite = null;
            var clearData_dialog:FlxSprite = null;
            var clearData_dialog_text:FlxText = null;
            var _clearData_dialog_choose_text:String = null;
            var clearData_dialog_choose_text:FlxText = null;
            var clearDataButton_Graphic:FlxSprite = null;
            var clearDataButton_Graphic_Light:FlxSprite = null;
            var deleteData:FlxButton = null;
            var cancelData:FlxButton = null;
            deleteDataPush = function():void
            {
               FlxG.play(SndMenuClick);
               shared.data.lvl = 1;
               shared.data.zombie = shared.data.lvl * 2;
               shared.data.zombieOnLvl = shared.data.zombie * 2;
               shared.data.score = 0;
               shared.data.sp = 0;
               shared.data.money = 0;
               shared.data.stat = [0,0,0,0,0,0,0];
               shared.data.bulletMiss = 0;
               shared.data.bulletHit = 0;
               shared.data.headShoot = 0;
               shared.data.zombieKilled = 0;
               shared.data.maxLvl = 0;
               shared.data.moneyEarned = 0;
               shared.data.bulletMissOnLvl = 0;
               shared.data.leftBarricade = 100;
               shared.data.rightBarricade = 100;
               shared.data.leftBarricade_Max = 100;
               shared.data.rightBarricade_Max = 100;
               shared.data.leftBarricade_lvl = 0;
               shared.data.rightBarricade_lvl = 0;
               shared.data.archivement = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]];
               shared.data.playerSkills = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]];
               shared.data.bot1Skills = [[0,0,0],[0,0,0],[0,0,0]];
               shared.data.bot2Skills = [[0,0,0],[0,0,0],[0,0,0]];
               shared.data.playerWeapons = [[2,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]];
               shared.data.barricadesUpgrade = [[0,0,0],[0,0,0]];
               FlxG.state = new PlayLvl();
            };
            cancelDataPush = function():void
            {
               FlxG.play(SndMenuClick);
               backBlackScreen.kill();
               deleteData.kill();
               cancelData.kill();
               clearData_dialog.kill();
               clearData_dialog_text.kill();
               clearData_dialog_choose_text.kill();
               clear_data_button.active = true;
               menu_button_PlayGame.active = true;
               menu_button_Credits.active = true;
               menu_button_More_games.active = true;
               menu_button_Achivement.active = true;
               menu_button_Continue.active = true;
            };
            if(shared.data.lvl != 1)
            {
               backBlackScreen = new FlxSprite();
               backBlackScreen.loadGraphic(blackScreenImg);
               backBlackScreen.scale.x = 640;
               backBlackScreen.scale.y = 480;
               backBlackScreen.alpha = 0.5;
               add(backBlackScreen);
               clear_data_button.active = false;
               menu_button_PlayGame.active = false;
               menu_button_Credits.active = false;
               menu_button_More_games.active = false;
               menu_button_Achivement.active = false;
               menu_button_Continue.active = false;
               clearData_dialog = new FlxSprite(235,222,Img_dialog);
               add(clearData_dialog);
               clearData_dialog_text = new FlxText(238,225,FlxG.width,"This will remove your last game!").setFormat(null,8,11052705,"left",2309720);
               add(clearData_dialog_text);
               _clearData_dialog_choose_text = "New Game               Cancel";
               clearData_dialog_choose_text = new FlxText(251,242,FlxG.width,_clearData_dialog_choose_text).setFormat(null,8,14868183,"left",2309720);
               add(clearData_dialog_choose_text);
               clearDataButton_Graphic = new FlxSprite(0,0,Img_dialog_button);
               clearDataButton_Graphic.alpha = 0;
               clearDataButton_Graphic_Light = new FlxSprite(0,0,Img_dialog_button);
               deleteData = new FlxButton(238,241,deleteDataPush);
               deleteData.loadGraphic(clearDataButton_Graphic,clearDataButton_Graphic_Light);
               add(deleteData);
               clearDataButton_Graphic = new FlxSprite(0,0,Img_dialog_button);
               clearDataButton_Graphic.alpha = 0;
               clearDataButton_Graphic_Light = new FlxSprite(0,0,Img_dialog_button);
               cancelData = new FlxButton(323,241,cancelDataPush);
               cancelData.loadGraphic(clearDataButton_Graphic,clearDataButton_Graphic_Light);
               add(cancelData);
               add(_cursor);
            }
            else
            {
               shared.data.leftBarricade = 100;
               shared.data.rightBarricade = 100;
               shared.data.leftBarricade_Max = 100;
               shared.data.rightBarricade_Max = 100;
               deleteDataPush();
               FlxG.state = new PlayLvl();
            }
         };
         menu_button_Continue_Push = function():void
         {
            if(shared.data.lvl >= 2)
            {
               FlxG.state = new Shop();
            }
         };
         menu_button_More_games_Push = function():void
         {
            FlxG.play(SndMenuClick);
            if(shared.data.archivement[4][1] == 0)
            {
               shared.data.archivement[4][1] = 1;
               shared.data.sp += 5;
            }
            var _loc2_:URLRequest = new URLRequest("http://www.andkon.com/arcade/");
            navigateToURL(_loc2_,"_blank");
         };
         menu_button_Credits_Push = function():void
         {
            var closeHelp_Graphic:FlxSprite;
            var closeHelp_Graphic_Light:FlxSprite;
            var backBlackScreen:FlxSprite = null;
            var creditsWindow:FlxSprite = null;
            var closeHelp:FlxButton = null;
            var closeHelpPush:Function = null;
            closeHelpPush = function():void
            {
               FlxG.play(SndMenuClick);
               backBlackScreen.kill();
               closeHelp.kill();
               creditsWindow.kill();
               clear_data_button.active = true;
               menu_button_PlayGame.active = true;
               menu_button_Credits.active = true;
               menu_button_More_games.active = true;
               menu_button_Achivement.active = true;
               menu_button_Continue.active = true;
            };
            FlxG.play(SndMenuClick);
            if(shared.data.archivement[1][3] == 0)
            {
               shared.data.archivement[1][3] = 1;
               shared.data.sp += 5;
            }
            backBlackScreen = new FlxSprite();
            backBlackScreen.loadGraphic(blackScreenImg);
            backBlackScreen.scale.x = 640;
            backBlackScreen.scale.y = 480;
            backBlackScreen.alpha = 0.5;
            add(backBlackScreen);
            clear_data_button.active = false;
            menu_button_PlayGame.active = false;
            menu_button_Credits.active = false;
            menu_button_More_games.active = false;
            menu_button_Achivement.active = false;
            menu_button_Continue.active = false;
            creditsWindow = new FlxSprite(200,200,ImgCredits);
            creditsWindow.solid = false;
            add(creditsWindow);
            closeHelp_Graphic = new FlxSprite(0,0,ImgHelp_close_button_light);
            closeHelp_Graphic.alpha = 0;
            closeHelp_Graphic_Light = new FlxSprite(0,0,ImgHelp_close_button_light);
            closeHelp = new FlxButton(437,202,closeHelpPush);
            closeHelp.loadGraphic(closeHelp_Graphic,closeHelp_Graphic_Light);
            add(closeHelp);
            add(_cursor);
         };
         menu_button_Achivement_Push = function():void
         {
            var closeHelp_Graphic_Light:FlxSprite;
            var closeHelp_Graphic:FlxSprite;
            var backBlackScreen:FlxSprite = null;
            var helpWindow:FlxSprite = null;
            var closeHelp:FlxButton = null;
            var closeHelpPush:Function = null;
            closeHelpPush = function():void
            {
               FlxG.play(SndMenuClick);
               backBlackScreen.kill();
               closeHelp.kill();
               helpWindow.kill();
               clear_data_button.active = true;
               menu_button_PlayGame.active = true;
               menu_button_Credits.active = true;
               menu_button_More_games.active = true;
               menu_button_Achivement.active = true;
               menu_button_Continue.active = true;
            };
            FlxG.play(SndMenuClick);
            backBlackScreen = new FlxSprite();
            backBlackScreen.loadGraphic(blackScreenImg);
            backBlackScreen.scale.x = 640;
            backBlackScreen.scale.y = 480;
            backBlackScreen.alpha = 0.5;
            add(backBlackScreen);
            clear_data_button.active = false;
            menu_button_PlayGame.active = false;
            menu_button_Credits.active = false;
            menu_button_More_games.active = false;
            menu_button_Achivement.active = false;
            menu_button_Continue.active = false;
            helpWindow = new FlxSprite(200,200,ImgHelpWindow);
            helpWindow.solid = false;
            add(helpWindow);
            closeHelp_Graphic = new FlxSprite(0,0,ImgHelp_close_button_light);
            closeHelp_Graphic.alpha = 0;
            closeHelp_Graphic_Light = new FlxSprite(0,0,ImgHelp_close_button_light);
            closeHelp = new FlxButton(437,202,closeHelpPush);
            closeHelp.loadGraphic(closeHelp_Graphic,closeHelp_Graphic_Light);
            add(closeHelp);
            add(_cursor);
         };
         clear_data_fun = function():void
         {
            var _clearData_dialog_choose_text:String;
            var clearDataButton_Graphic_Light:FlxSprite;
            var clearDataButton_Graphic:FlxSprite;
            var backBlackScreen:FlxSprite = null;
            var clearData_dialog:FlxSprite = null;
            var clearData_dialog_text:FlxText = null;
            var clearData_dialog_choose_text:FlxText = null;
            var deleteData:FlxButton = null;
            var cancelData:FlxButton = null;
            var deleteDataPush:Function = null;
            var cancelDataPush:Function = null;
            deleteDataPush = function():void
            {
               OBF_0c();
               cancelDataPush();
            };
            cancelDataPush = function():void
            {
               FlxG.play(SndMenuClick);
               backBlackScreen.kill();
               deleteData.kill();
               cancelData.kill();
               clearData_dialog.kill();
               clearData_dialog_text.kill();
               clearData_dialog_choose_text.kill();
               clear_data_button.active = true;
               menu_button_PlayGame.active = true;
               menu_button_Credits.active = true;
               menu_button_More_games.active = true;
               menu_button_Achivement.active = true;
               menu_button_Continue.active = true;
            };
            FlxG.play(SndMenuClick);
            backBlackScreen = new FlxSprite();
            backBlackScreen.loadGraphic(blackScreenImg);
            backBlackScreen.scale.x = 640;
            backBlackScreen.scale.y = 480;
            backBlackScreen.alpha = 0.5;
            add(backBlackScreen);
            clear_data_button.active = false;
            menu_button_PlayGame.active = false;
            menu_button_Credits.active = false;
            menu_button_More_games.active = false;
            menu_button_Achivement.active = false;
            menu_button_Continue.active = false;
            clearData_dialog = new FlxSprite(235,222,Img_dialog);
            add(clearData_dialog);
            clearData_dialog_text = new FlxText(243,225,FlxG.width,"Hey, this will delete your data!").setFormat(null,8,11052705,"left",2309720);
            add(clearData_dialog_text);
            _clearData_dialog_choose_text = "Delete                  Cancel";
            clearData_dialog_choose_text = new FlxText(259,242,FlxG.width,_clearData_dialog_choose_text).setFormat(null,8,14868183,"left",2309720);
            add(clearData_dialog_choose_text);
            clearDataButton_Graphic = new FlxSprite(0,0,Img_dialog_button);
            clearDataButton_Graphic.alpha = 0;
            clearDataButton_Graphic_Light = new FlxSprite(0,0,Img_dialog_button);
            deleteData = new FlxButton(238,241,deleteDataPush);
            deleteData.loadGraphic(clearDataButton_Graphic,clearDataButton_Graphic_Light);
            add(deleteData);
            clearDataButton_Graphic = new FlxSprite(0,0,Img_dialog_button);
            clearDataButton_Graphic.alpha = 0;
            clearDataButton_Graphic_Light = new FlxSprite(0,0,Img_dialog_button);
            cancelData = new FlxButton(323,241,cancelDataPush);
            cancelData.loadGraphic(clearDataButton_Graphic,clearDataButton_Graphic_Light);
            add(cancelData);
            add(_cursor);
         };
         menu_button_Logo_Push = function():void
         {
            FlxG.play(SndMenuClick);
            if(shared.data.archivement[4][1] == 0)
            {
               shared.data.archivement[4][1] = 1;
               shared.data.sp += 5;
            }
            var _loc2_:URLRequest = new URLRequest("http://www.andkon.com/arcade/");
            navigateToURL(_loc2_,"_blank");
         };
         this.shared = SharedObject.getLocal("reloaded");
         backGround = new FlxSprite(0,0,this.backGround_Img);
         backGround.solid = false;
         add(backGround);
         MenuSign = new FlxSprite(528,16,this.ImgMenuSign);
         MenuSign.solid = false;
         add(MenuSign);
         ver = new FlxText(597,468,70,"ver 1.03");
         ver.color = 11052705;
         ver.shadow = 2309720;
         ver.size = 8;
         add(ver);
         menuText = new FlxText(550,18,FlxG.width,"MENU").setFormat(null,16,11052705,"left",2309720);
         add(menuText);
         bobText = "New Game\nContinue\nAndkon\nCredits\nHelp";
         bob = new FlxText(542,46,FlxG.width,bobText).setFormat(null,8,14868183,"left",2309720);
         add(bob);
         menu_button_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Graphic.alpha = 0;
         menu_button_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_PlayGame = new FlxButton(531,47,menu_button_PlayGame_Push);
         menu_button_PlayGame.loadGraphic(menu_button_Graphic,menu_button_Graphic_Light);
         add(menu_button_PlayGame);
         menu_button_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Graphic.alpha = 0;
         menu_button_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Continue = new FlxButton(531,57,menu_button_Continue_Push);
         menu_button_Continue.loadGraphic(menu_button_Graphic,menu_button_Graphic_Light);
         add(menu_button_Continue);
         menu_button_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Graphic.alpha = 0;
         menu_button_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_More_games = new FlxButton(531,67,menu_button_More_games_Push);
         menu_button_More_games.loadGraphic(menu_button_Graphic,menu_button_Graphic_Light);
         add(menu_button_More_games);
         menu_button_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Graphic.alpha = 0;
         menu_button_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Credits = new FlxButton(531,77,menu_button_Credits_Push);
         menu_button_Credits.loadGraphic(menu_button_Graphic,menu_button_Graphic_Light);
         add(menu_button_Credits);
         menu_button_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Graphic.alpha = 0;
         menu_button_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Achivement = new FlxButton(531,87,menu_button_Achivement_Push);
         menu_button_Achivement.loadGraphic(menu_button_Graphic,menu_button_Graphic_Light);
         add(menu_button_Achivement);
         clear_data_Graphic = new FlxSprite(0,0,this.Img_clear_data_Graphic);
         clear_data_Graphic_Light = new FlxSprite(0,0,this.Img_clear_data_Graphic_Light);
         clear_data_button = new FlxButton(1,468,clear_data_fun);
         clear_data_button.width = 30;
         clear_data_button.loadGraphic(clear_data_Graphic,clear_data_Graphic_Light);
         add(clear_data_button);
         sponsorLogo_Graphic = new FlxSprite(0,0,this.ImgSponsorLogo);
         sponsorLogo_Graphic_light = new FlxSprite(0,0,this.ImgSponsorLogo_light);
         sponsorLogo = new FlxButton(0,0,menu_button_Logo_Push);
         sponsorLogo.loadGraphic(sponsorLogo_Graphic,sponsorLogo_Graphic_light);
         add(sponsorLogo);
         FlxPanel1 = new FlxPanel();
         FlxPanel1.show(false);
         FlxPanel1.setup("","","");
         this._cursor = new FlxSprite(0,0,this.ImgCursor);
         this._cursor.solid = false;
         add(this._cursor);
      }
      
      override public function update() : void
      {
         this._cursor.x = FlxG.mouse.x;
         this._cursor.y = FlxG.mouse.y;
         super.update();
      }
      
      private function OBF_1a14() : void
      {
         FlxG.play(this.SndMenuClick);
         FlxG.state = new PlayLvl();
      }
      
      private function OBF_0c() : void
      {
         this.shared.data.visits = 1;
         this.shared.data.lvl = 1;
         this.shared.data.score = 0;
         this.shared.data.sp = 0;
         this.shared.data.money = 0;
         this.shared.data.stat = [0,0,0,0,0,0,0];
         this.shared.data.bulletMiss = 0;
         this.shared.data.bulletHit = 0;
         this.shared.data.headShoot = 0;
         this.shared.data.zombieKilled = 0;
         this.shared.data.maxLvl = 0;
         this.shared.data.moneyEarned = 0;
         this.shared.data.bulletMissOnLvl = 0;
         this.shared.data.leftBarricade = 100;
         this.shared.data.rightBarricade = 100;
         this.shared.data.leftBarricade_Max = 100;
         this.shared.data.rightBarricade_Max = 100;
         this.shared.data.leftBarricade_lvl = 0;
         this.shared.data.rightBarricade_lvl = 0;
         this.shared.data.bulletShot = [0,0,0,0,0,0,0,0,0];
         this.shared.data.playerSkills = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]];
         this.shared.data.bot1Skills = [[0,0,0],[0,0,0],[0,0,0]];
         this.shared.data.bot2Skills = [[0,0,0],[0,0,0],[0,0,0]];
         this.shared.data.playerWeapons = [[2,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]];
         this.shared.data.barricadesUpgrade = [[0,0,0],[0,0,0]];
         this.shared.data.archivement = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]];
      }
   }
}

