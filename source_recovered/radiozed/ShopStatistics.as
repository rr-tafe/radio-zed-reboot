package
{
   import org.flixel.*;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class ShopStatistics extends FlxState
   {
      
      private var ImgSponsorLogo:Class;
      
      private var ImgGun_Button_light:Class;
      
      private var param:Params;
      
      private var ImgSponsorLogo_light:Class;
      
      private var SndMenuClick:Class;
      
      private var start:FlxButton;
      
      private var _active:Boolean = false;
      
      private var Img_Archivement48:Class;
      
      private var Img_button_start_menu:Class;
      
      private var lang:Texts;
      
      private var ImgCursor:Class;
      
      private var ImgGun_Button:Class;
      
      private var _cursor:FlxSprite;
      
      private var backGround_Img:Class;
      
      private var ImgNone_Archivement:Class;
      
      private var shopBack:Class;
      
      private var Img_main_menu_button_light:Class;
      
      public function ShopStatistics()
      {
         var sponsorLogo_Graphic_light:FlxSprite;
         var xx:Number;
         var gunButton:FlxButton;
         var skillsGuns:FlxText;
         var arcText:FlxText;
         var yy:Number;
         var statText:FlxText;
         var start_Graphic_Light:FlxSprite;
         var statColumn2:FlxText;
         var statColumn3:FlxText;
         var statColumn4:FlxText;
         var startText:FlxText;
         var gunButtonGraphicLight:FlxSprite;
         var backToMenu:FlxButton;
         var archivButtonPush2:Function;
         var statColumn:FlxText;
         var backGround:FlxSprite;
         var stat:String;
         var scoreText:FlxText;
         var stat4:String;
         var stat3Bullets:String;
         var archivButtonPush:Function;
         var startBack:FlxSprite;
         var start_Graphic:FlxSprite;
         var stat2:String;
         var sponsorLogo_Graphic:FlxSprite;
         var i:int;
         var achievementsText:FlxText;
         var sponsorLogo:FlxButton;
         var _frame:Number;
         var gunButtonGraphic:FlxSprite;
         var shop:FlxSprite;
         var shared:SharedObject = null;
         var sponsorLogo_Push:Function = null;
         var backToMenuPush:Function = null;
         var gunButtonPush:Function = null;
         var descriptionText:FlxText = null;
         var archivButtonGraphic:FlxSprite = null;
         var k:int = 0;
         var archivButton:FlxButton = null;
         var archivButton2:FlxButton = null;
         this.shopBack = Shop_statistics_shopBack;
         this.ImgCursor = Shop_statistics_ImgCursor;
         this.ImgGun_Button_light = Shop_statistics_ImgGun_Button_light;
         this.ImgGun_Button = Shop_statistics_ImgGun_Button;
         this.ImgNone_Archivement = Shop_statistics_ImgNone_Archivement;
         this.Img_Archivement48 = Shop_statistics_Img_Archivement48;
         this.Img_button_start_menu = Shop_statistics_Img_button_start_menu;
         this.Img_main_menu_button_light = Shop_statistics_Img_main_menu_button_light;
         this.backGround_Img = Shop_statistics_backGround_Img;
         this.ImgSponsorLogo = Shop_statistics_ImgSponsorLogo;
         this.ImgSponsorLogo_light = Shop_statistics_ImgSponsorLogo_light;
         this.SndMenuClick = Shop_statistics_SndMenuClick;
         this.lang = new Texts();
         this.param = new Params();
         super();
         sponsorLogo_Push = function():void
         {
            if(shared.data.archivement[4][1] == 0)
            {
               shared.data.archivement[4][1] = 1;
               shared.data.sp += 5;
            }
            var _loc2_:URLRequest = new URLRequest("http://www.andkon.com/arcade/");
            navigateToURL(_loc2_,"_blank");
         };
         backToMenuPush = function():void
         {
            FlxG.state = new Menu();
         };
         gunButtonPush = function():void
         {
            FlxG.play(SndMenuClick);
            FlxG.state = new Shop();
         };
         shared = SharedObject.getLocal("reloaded");
         backGround = new FlxSprite(0,0,this.backGround_Img);
         backGround.solid = false;
         add(backGround);
         shop = new FlxSprite(0,0,this.shopBack);
         shop.solid = false;
         add(shop);
         sponsorLogo_Graphic = new FlxSprite(0,0,this.ImgSponsorLogo);
         sponsorLogo_Graphic_light = new FlxSprite(0,0,this.ImgSponsorLogo_light);
         sponsorLogo = new FlxButton(292,7,sponsorLogo_Push);
         sponsorLogo.loadGraphic(sponsorLogo_Graphic,sponsorLogo_Graphic_light);
         add(sponsorLogo);
         startBack = new FlxSprite(500,430,this.Img_button_start_menu);
         add(startBack);
         startText = new FlxText(518,430,FlxG.width,"START").setFormat(null,8,14868183,"left",2309720);
         add(startText);
         start_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         start_Graphic.alpha = 0;
         start_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         this.start = new FlxButton(503,431,this.OBF_1a14);
         this.start.loadGraphic(start_Graphic,start_Graphic_Light);
         add(this.start);
         startBack = new FlxSprite(85,430,this.Img_button_start_menu);
         add(startBack);
         startText = new FlxText(103,430,FlxG.width,"MENU").setFormat(null,8,14868183,"left",2309720);
         add(startText);
         start_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         start_Graphic.alpha = 0;
         start_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         backToMenu = new FlxButton(88,431,backToMenuPush);
         backToMenu.loadGraphic(start_Graphic,start_Graphic_Light);
         add(backToMenu);
         skillsGuns = new FlxText(145,72,FlxG.width,this.lang.skillsGuns).setFormat(null,16,11052705,"left",2309720);
         add(skillsGuns);
         achievementsText = new FlxText(337,72,FlxG.width,this.lang.achievements).setFormat(null,16,14868183,"left",2309720);
         add(achievementsText);
         gunButton = new FlxButton(85,63,gunButtonPush);
         gunButtonGraphic = new FlxSprite(0,0,this.ImgGun_Button);
         gunButtonGraphicLight = new FlxSprite(0,0,this.ImgGun_Button_light);
         gunButton.loadGraphic(gunButtonGraphic,gunButtonGraphicLight);
         add(gunButton);
         arcText = new FlxText(113,106,FlxG.width,this.lang.archivement);
         arcText.color = 14868183;
         arcText.size = 8;
         arcText.shadow = 2309720;
         add(arcText);
         statText = new FlxText(330,106,FlxG.width,"Statistics");
         statText.color = 14868183;
         statText.size = 8;
         statText.shadow = 2309720;
         add(statText);
         descriptionText = new FlxText(118,375,FlxG.width,"Click on icons for information");
         descriptionText.color = 14868183;
         descriptionText.size = 8;
         descriptionText.shadow = 2309720;
         add(descriptionText);
         stat = "Zombie killing:  " + "\n" + "Max wave: " + "\n" + "Money earned: " + "\n" + "Money spent: " + "\n" + "Shots made: " + "\n" + "Misses: " + "\n" + "Hits: " + "\n" + "Accuracy: \n" + "Headshots: ";
         statColumn = new FlxText(330,126,FlxG.width,stat);
         statColumn.color = 14868183;
         statColumn.size = 8;
         statColumn.shadow = 2309720;
         add(statColumn);
         stat2 = String(shared.data.zombieKilled) + "\n" + String(shared.data.maxLvl) + "\n" + String(shared.data.moneyEarned) + "\n" + String(shared.data.moneyEarned - shared.data.money) + "\n" + String(shared.data.bulletMiss + shared.data.bulletHit) + "\n" + String(shared.data.bulletMiss) + "\n" + String(shared.data.bulletHit) + "\n" + String(Math.floor(shared.data.bulletHit / (shared.data.bulletMiss + shared.data.bulletHit) * 100) / 100) + "\n" + String(shared.data.headShoot);
         statColumn2 = new FlxText(410,126,FlxG.width,stat2);
         statColumn2.color = 14868183;
         statColumn2.size = 8;
         statColumn2.shadow = 2309720;
         add(statColumn2);
         stat3Bullets = "Glocks-17:  " + "\n" + "Desert Eagle: " + "\n" + "Uzi: " + "\n" + "HK G36: " + "\n" + "Steyr AUG: " + "\n" + "AK-47: " + "\n" + "M-16:" + "\n" + "SM SSG 69: \n" + "FN M249 SAW: ";
         statColumn3 = new FlxText(451,126,FlxG.width,stat3Bullets);
         statColumn3.color = 14868183;
         statColumn3.size = 8;
         statColumn3.shadow = 2309720;
         add(statColumn3);
         stat4 = String(shared.data.bulletShot[0]) + "\n" + String(shared.data.bulletShot[1]) + "\n" + String(shared.data.bulletShot[2]) + "\n" + String(shared.data.bulletShot[3]) + "\n" + String(shared.data.bulletShot[4]) + "\n" + String(shared.data.bulletShot[5]) + "\n" + String(shared.data.bulletShot[6]) + "\n" + String(shared.data.bulletShot[7]) + "\n" + String(shared.data.bulletShot[8]);
         statColumn4 = new FlxText(523,126,FlxG.width,stat4);
         statColumn4.color = 14868183;
         statColumn4.size = 8;
         statColumn4.shadow = 2309720;
         add(statColumn4);
         scoreText = new FlxText(353,416,FlxG.width,"Total score: " + String(shared.data.score)).setFormat(null,8,14868183,"left",2309720);
         add(scoreText);
         xx = 113;
         yy = 130;
         _frame = 0;
         i = 0;
         while(i < 7)
         {
            k = 0;
            while(k < 6)
            {
               if(shared.data.archivement[i][k] == 0)
               {
                  archivButtonPush = function():void
                  {
                     FlxG.play(SndMenuClick);
                     descriptionText.text = lang.descriptionArch[this._line][this._column];
                  };
                  archivButtonGraphic = new FlxSprite(0,0,this.ImgNone_Archivement);
                  archivButton = new FlxButton(xx,yy,archivButtonPush);
                  archivButton.loadGraphic(archivButtonGraphic);
                  archivButton._line = i;
                  archivButton._column = k;
                  add(archivButton);
               }
               else if(shared.data.archivement[i][k] == 1)
               {
                  archivButtonPush2 = function():void
                  {
                     FlxG.play(SndMenuClick);
                     descriptionText.text = lang.descriptionArch[this._line][this._column];
                  };
                  archivButtonGraphic = new FlxSprite(0,0,this.Img_Archivement48);
                  archivButtonGraphic.loadGraphic(this.Img_Archivement48,false,false,25,25);
                  archivButtonGraphic.frame = _frame;
                  archivButton2 = new FlxButton(xx,yy,archivButtonPush2);
                  archivButton2.loadGraphic(archivButtonGraphic);
                  archivButton2._line = i;
                  archivButton2._column = k;
                  add(archivButton2);
               }
               xx += 31;
               _frame += 1;
               k++;
            }
            yy += 31;
            xx = 113;
            i++;
         }
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
         FlxG.state = new PlayLvl();
      }
   }
}

