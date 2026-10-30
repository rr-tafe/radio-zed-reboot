package
{
   import org.flixel.*;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class Shop extends FlxState
   {
      
      private var ImgWeapon5_2_light:Class;
      
      private var ImgStat_Button:Class;
      
      private var weaponButtons_Light:Array;
      
      private var ImgWeapon7_2_light:Class;
      
      private var ImgWeapon9_2_light:Class;
      
      private var ImgButtonBuy2_light:Class;
      
      private var SndMenuClick:Class;
      
      private var barricadesRepairButtons_Light:Array;
      
      private var _active:Boolean = false;
      
      private var ImgWeapon7_1:Class;
      
      private var ImgWeapon7_2:Class;
      
      private var ImgWeapon3_1_block:Class;
      
      private var ImgWeapon5_1_block:Class;
      
      private var ImgWeapon7_1_block:Class;
      
      private var ImgWeapon9_1_block:Class;
      
      private var ImgButtonBuyBarricad3_block:Class;
      
      private var ImgSponsorLogo:Class;
      
      private var ImgButtonBuyBarricad1_light:Class;
      
      private var ImgButtonRepairBarricad2_light:Class;
      
      private var ImgButtonBlock1:Class;
      
      private var ImgButtonBlock2:Class;
      
      private var ImgButtonBlock3:Class;
      
      private var start:FlxButton;
      
      private var ImgWeapon6_1:Class;
      
      private var ImgWeapon6_2:Class;
      
      private var ImgWeapon2_2_block:Class;
      
      private var _cursor:FlxSprite;
      
      private var ImgWeapon4_2_block:Class;
      
      private var barricadesButtons:Array;
      
      private var ImgWeapon6_2_block:Class;
      
      private var ImgWeapon8_2_block:Class;
      
      private var ImgButtonRepairBarricad1_block:Class;
      
      private var param:Params;
      
      private var ImgStat_Button_light:Class;
      
      private var barricadesButtons_Block:Array;
      
      private var ImgWeapon5_1:Class;
      
      private var ImgWeapon5_2:Class;
      
      private var Img_button_start_menu:Class;
      
      private var ImgWeaponCheck:Class;
      
      private var ImgButton:Class;
      
      private var ImgWeapon3_1_light:Class;
      
      private var ImgWeapon5_1_light:Class;
      
      private var ImgButtonBuy1:Class;
      
      private var ImgButtonBuy2:Class;
      
      private var ImgButtonBuy3:Class;
      
      private var ImgWeapon9_1_light:Class;
      
      private var ImgButtonBuyBarricad3_light:Class;
      
      private var ImgWeapon7_1_light:Class;
      
      private var ImgButtonBuy1_light:Class;
      
      private var ImgCursor:Class;
      
      private var ImgSponsorLogo_light:Class;
      
      private var ImgWeapon4_1:Class;
      
      private var ImgWeapon4_2:Class;
      
      private var ImgButtonBuyBarricad2_block:Class;
      
      private var ImgWeapon2_2_light:Class;
      
      private var ImgWeapon4_2_light:Class;
      
      private var ImgWeapon6_2_light:Class;
      
      private var ImgWeapon8_2_light:Class;
      
      private var shopBack:Class;
      
      private var ImgButtonRepairBarricad1_light:Class;
      
      private var ImgButtonRepairBarricad3_block:Class;
      
      private var ImgButtonBuyBarricad1:Class;
      
      private var ImgButtonBuyBarricad2:Class;
      
      private var ImgWeapon3_1:Class;
      
      private var ImgWeapon3_2:Class;
      
      private var ImgButtonBuyBarricad3:Class;
      
      private var barricadesButtons_Light:Array;
      
      private var backGround_Img:Class;
      
      private var ImgWeapon2_1_block:Class;
      
      private var ImgButtonRepairBarricad2:Class;
      
      private var ImgWeapon4_1_block:Class;
      
      private var ImgWeapon6_1_block:Class;
      
      private var ImgWeapon8_1_block:Class;
      
      private var ImgButtonRepairBarricad1:Class;
      
      private var ImgButtonRepairBarricad3:Class;
      
      private var ImgButtonCheck:Class;
      
      private var ImgButtonBuy3_light:Class;
      
      private var ImgWeapon2_1:Class;
      
      private var ImgWeapon2_2:Class;
      
      private var ImgWeapon1_2_block:Class;
      
      private var ImgWeapon3_2_block:Class;
      
      private var ImgWeapon5_2_block:Class;
      
      private var ImgWeapon7_2_block:Class;
      
      private var ImgWeapon9_2_block:Class;
      
      private var ImgButtonBuyBarricad2_light:Class;
      
      private var ImgButtonRepairBarricad3_light:Class;
      
      private var weaponButtons_Block:Array;
      
      private var barricadesRepairButtons_Block:Array;
      
      private var ImgWeapon1_2:Class;
      
      private var barricadesRepairButtons:Array;
      
      private var ImgWeapon9_1:Class;
      
      private var ImgWeapon9_2:Class;
      
      private var ImgWeapon2_1_light:Class;
      
      private var ImgWeapon4_1_light:Class;
      
      private var Img_main_menu_button_light:Class;
      
      private var ImgWeapon6_1_light:Class;
      
      private var ImgButtonBuyBarricad1_block:Class;
      
      private var ImgWeapon8_1_light:Class;
      
      private var weaponButtons:Array;
      
      private var ImgButtonRepairBarricad2_block:Class;
      
      private var ImgWeapon8_1:Class;
      
      private var ImgWeapon8_2:Class;
      
      private var lang:Texts;
      
      private var ImgWeapon1_2_light:Class;
      
      private var ImgWeapon3_2_light:Class;
      
      public function Shop()
      {
         var xx:Number;
         var bot1_damage:FlxText;
         var sponsorLogo_Graphic_light:FlxSprite;
         var moneyText:FlxText;
         var shop:FlxSprite;
         var bot1_speed:FlxText;
         var Bot1Name:FlxText;
         var yy:Number;
         var barricadeLvls:FlxText;
         var player_zHunter:FlxText;
         var backToMenu:FlxButton;
         var weaponsBuyUp:FlxText;
         var player_recharge:FlxText;
         var rx:Number;
         var ry:Number;
         var StatButtonGraphic:FlxSprite;
         var repairLeft:FlxText;
         var levels123Bot1:FlxText;
         var backGround:FlxSprite;
         var player_luck:FlxText;
         var upgradeLeft:FlxText;
         var bot2_speed:FlxText;
         var bot1_accuracy:FlxText;
         var by:Number;
         var yyy:Number;
         var levels123Bot2:FlxText;
         var barricadeButtonPush:Function;
         var levels123:FlxText;
         var upgradeRight:FlxText;
         var i:int;
         var bot2_accuracy:FlxText;
         var sponsorLogo_Graphic:FlxSprite;
         var weaponText:FlxText;
         var achievementsText:FlxText;
         var player_speed:FlxText;
         var startBack:FlxSprite;
         var bx:Number;
         var ach42:Function;
         var player_damage:FlxText;
         var repairRight:FlxText;
         var skillsGuns:FlxText;
         var Bot2Name:FlxText;
         var player_accuracy:FlxText;
         var weapon4:FlxText;
         var weapon5:FlxText;
         var player_life:FlxText;
         var weapon7:FlxText;
         var weapon2:FlxText;
         var start_Graphic_Light:FlxSprite;
         var weapon1:FlxText;
         var barricadeHealth:FlxText;
         var weapon6:FlxText;
         var statButton:FlxButton;
         var startText:FlxText;
         var weapon8:FlxText;
         var weapon9:FlxText;
         var barricadeText:FlxText;
         var plSkills_X:Number;
         var plSkills_Y:Number;
         var weapon3:FlxText;
         var repairPrice:FlxText;
         var skillButtonPush:Function;
         var Bot2SkillButtonPush:Function;
         var Bot1SkillButtonPush:Function;
         var bot2_damage:FlxText;
         var sponsorLogo:FlxButton;
         var wx:Number;
         var wy:Number;
         var start_Graphic:FlxSprite;
         var weaponButtonPush:Function;
         var barricadeRepairButtonPush:Function;
         var StatButtonGraphicLight:FlxSprite;
         var specialPoints:FlxText;
         var characterText:FlxText;
         var shared:SharedObject = null;
         var sponsorLogo_Push:Function = null;
         var backToMenuPush:Function = null;
         var buttonGraphic:FlxSprite = null;
         var buttonGraphicLight:FlxSprite = null;
         var statButtonPush:Function = null;
         var k:int = 0;
         var skillButton:FlxButton = null;
         var weaponButton:FlxButton = null;
         var barricadeButton:FlxButton = null;
         var barricadeRepairButton:FlxButton = null;
         this.shopBack = Shop_shopBack;
         this.ImgCursor = Shop_ImgCursor;
         this.ImgButton = Shop_ImgButton;
         this.ImgButtonCheck = Shop_ImgButtonCheck;
         this.ImgButtonBuy1 = Shop_ImgButtonBuy1;
         this.ImgButtonBuy2 = Shop_ImgButtonBuy2;
         this.ImgButtonBuy3 = Shop_ImgButtonBuy3;
         this.ImgButtonBlock1 = Shop_ImgButtonBlock1;
         this.ImgButtonBlock2 = Shop_ImgButtonBlock2;
         this.ImgButtonBlock3 = Shop_ImgButtonBlock3;
         this.ImgButtonBuy1_light = Shop_ImgButtonBuy1_light;
         this.ImgButtonBuy2_light = Shop_ImgButtonBuy2_light;
         this.ImgButtonBuy3_light = Shop_ImgButtonBuy3_light;
         this.ImgWeapon1_2 = Shop_ImgWeapon1_2;
         this.ImgWeapon1_2_light = Shop_ImgWeapon1_2_light;
         this.ImgWeapon1_2_block = Shop_ImgWeapon1_2_block;
         this.ImgWeapon2_1 = Shop_ImgWeapon2_1;
         this.ImgWeapon2_1_light = Shop_ImgWeapon2_1_light;
         this.ImgWeapon2_1_block = Shop_ImgWeapon2_1_block;
         this.ImgWeapon2_2 = Shop_ImgWeapon2_2;
         this.ImgWeapon2_2_light = Shop_ImgWeapon2_2_light;
         this.ImgWeapon2_2_block = Shop_ImgWeapon2_2_block;
         this.ImgWeapon3_1 = Shop_ImgWeapon3_1;
         this.ImgWeapon3_1_light = Shop_ImgWeapon3_1_light;
         this.ImgWeapon3_1_block = Shop_ImgWeapon3_1_block;
         this.ImgWeapon3_2 = Shop_ImgWeapon3_2;
         this.ImgWeapon3_2_light = Shop_ImgWeapon3_2_light;
         this.ImgWeapon3_2_block = Shop_ImgWeapon3_2_block;
         this.ImgWeapon4_1 = Shop_ImgWeapon4_1;
         this.ImgWeapon4_1_light = Shop_ImgWeapon4_1_light;
         this.ImgWeapon4_1_block = Shop_ImgWeapon4_1_block;
         this.ImgWeapon4_2 = Shop_ImgWeapon4_2;
         this.ImgWeapon4_2_light = Shop_ImgWeapon4_2_light;
         this.ImgWeapon4_2_block = Shop_ImgWeapon4_2_block;
         this.ImgWeapon5_1 = Shop_ImgWeapon5_1;
         this.ImgWeapon5_1_light = Shop_ImgWeapon5_1_light;
         this.ImgWeapon5_1_block = Shop_ImgWeapon5_1_block;
         this.ImgWeapon5_2 = Shop_ImgWeapon5_2;
         this.ImgWeapon5_2_light = Shop_ImgWeapon5_2_light;
         this.ImgWeapon5_2_block = Shop_ImgWeapon5_2_block;
         this.ImgWeapon6_1 = Shop_ImgWeapon6_1;
         this.ImgWeapon6_1_light = Shop_ImgWeapon6_1_light;
         this.ImgWeapon6_1_block = Shop_ImgWeapon6_1_block;
         this.ImgWeapon6_2 = Shop_ImgWeapon6_2;
         this.ImgWeapon6_2_light = Shop_ImgWeapon6_2_light;
         this.ImgWeapon6_2_block = Shop_ImgWeapon6_2_block;
         this.ImgWeapon7_1 = Shop_ImgWeapon7_1;
         this.ImgWeapon7_1_light = Shop_ImgWeapon7_1_light;
         this.ImgWeapon7_1_block = Shop_ImgWeapon7_1_block;
         this.ImgWeapon7_2 = Shop_ImgWeapon7_2;
         this.ImgWeapon7_2_light = Shop_ImgWeapon7_2_light;
         this.ImgWeapon7_2_block = Shop_ImgWeapon7_2_block;
         this.ImgWeapon8_1 = Shop_ImgWeapon8_1;
         this.ImgWeapon8_1_light = Shop_ImgWeapon8_1_light;
         this.ImgWeapon8_1_block = Shop_ImgWeapon8_1_block;
         this.ImgWeapon8_2 = Shop_ImgWeapon8_2;
         this.ImgWeapon8_2_light = Shop_ImgWeapon8_2_light;
         this.ImgWeapon8_2_block = Shop_ImgWeapon8_2_block;
         this.ImgWeapon9_1 = Shop_ImgWeapon9_1;
         this.ImgWeapon9_1_light = Shop_ImgWeapon9_1_light;
         this.ImgWeapon9_1_block = Shop_ImgWeapon9_1_block;
         this.ImgWeapon9_2 = Shop_ImgWeapon9_2;
         this.ImgWeapon9_2_light = Shop_ImgWeapon9_2_light;
         this.ImgWeapon9_2_block = Shop_ImgWeapon9_2_block;
         this.ImgWeaponCheck = Shop_ImgWeaponCheck;
         this.ImgButtonBuyBarricad1 = Shop_ImgButtonBuyBarricad1;
         this.ImgButtonBuyBarricad2 = Shop_ImgButtonBuyBarricad2;
         this.ImgButtonBuyBarricad3 = Shop_ImgButtonBuyBarricad3;
         this.ImgButtonBuyBarricad1_block = Shop_ImgButtonBuyBarricad1_block;
         this.ImgButtonBuyBarricad2_block = Shop_ImgButtonBuyBarricad2_block;
         this.ImgButtonBuyBarricad3_block = Shop_ImgButtonBuyBarricad3_block;
         this.ImgButtonBuyBarricad1_light = Shop_ImgButtonBuyBarricad1_light;
         this.ImgButtonBuyBarricad2_light = Shop_ImgButtonBuyBarricad2_light;
         this.ImgButtonBuyBarricad3_light = Shop_ImgButtonBuyBarricad3_light;
         this.ImgButtonRepairBarricad1 = Shop_ImgButtonRepairBarricad1;
         this.ImgButtonRepairBarricad2 = Shop_ImgButtonRepairBarricad2;
         this.ImgButtonRepairBarricad3 = Shop_ImgButtonRepairBarricad3;
         this.ImgButtonRepairBarricad1_block = Shop_ImgButtonRepairBarricad1_block;
         this.ImgButtonRepairBarricad2_block = Shop_ImgButtonRepairBarricad2_block;
         this.ImgButtonRepairBarricad3_block = Shop_ImgButtonRepairBarricad3_block;
         this.ImgButtonRepairBarricad1_light = Shop_ImgButtonRepairBarricad1_light;
         this.ImgButtonRepairBarricad2_light = Shop_ImgButtonRepairBarricad2_light;
         this.ImgButtonRepairBarricad3_light = Shop_ImgButtonRepairBarricad3_light;
         this.ImgStat_Button_light = Shop_ImgStat_Button_light;
         this.ImgStat_Button = Shop_ImgStat_Button;
         this.Img_button_start_menu = Shop_Img_button_start_menu;
         this.Img_main_menu_button_light = Shop_Img_main_menu_button_light;
         this.backGround_Img = Shop_backGround_Img;
         this.SndMenuClick = Shop_SndMenuClick;
         this.ImgSponsorLogo = Shop_ImgSponsorLogo;
         this.ImgSponsorLogo_light = Shop_ImgSponsorLogo_light;
         this.barricadesButtons = [[this.ImgButtonBuyBarricad1,this.ImgButtonBuyBarricad2,this.ImgButtonBuyBarricad3],[this.ImgButtonBuyBarricad1,this.ImgButtonBuyBarricad2,this.ImgButtonBuyBarricad3]];
         this.barricadesButtons_Light = [[this.ImgButtonBuyBarricad1_light,this.ImgButtonBuyBarricad2_light,this.ImgButtonBuyBarricad3_light],[this.ImgButtonBuyBarricad1_light,this.ImgButtonBuyBarricad2_light,this.ImgButtonBuyBarricad3_light]];
         this.barricadesButtons_Block = [[this.ImgButtonBuyBarricad1_block,this.ImgButtonBuyBarricad2_block,this.ImgButtonBuyBarricad3_block],[this.ImgButtonBuyBarricad1_block,this.ImgButtonBuyBarricad2_block,this.ImgButtonBuyBarricad3_block]];
         this.barricadesRepairButtons = [[this.ImgButtonRepairBarricad1,this.ImgButtonRepairBarricad2,this.ImgButtonRepairBarricad3],[this.ImgButtonRepairBarricad1,this.ImgButtonRepairBarricad2,this.ImgButtonRepairBarricad3]];
         this.barricadesRepairButtons_Light = [[this.ImgButtonRepairBarricad1_light,this.ImgButtonRepairBarricad2_light,this.ImgButtonRepairBarricad3_light],[this.ImgButtonRepairBarricad1_light,this.ImgButtonRepairBarricad2_light,this.ImgButtonRepairBarricad3_light]];
         this.barricadesRepairButtons_Block = [[this.ImgButtonRepairBarricad1_block,this.ImgButtonRepairBarricad2_block,this.ImgButtonRepairBarricad3_block],[this.ImgButtonRepairBarricad1_block,this.ImgButtonRepairBarricad2_block,this.ImgButtonRepairBarricad3_block]];
         this.weaponButtons = [[this.ImgWeapon1_2,this.ImgWeapon1_2],[this.ImgWeapon2_1,this.ImgWeapon2_2],[this.ImgWeapon3_1,this.ImgWeapon3_2],[this.ImgWeapon4_1,this.ImgWeapon4_2],[this.ImgWeapon5_1,this.ImgWeapon5_2],[this.ImgWeapon6_1,this.ImgWeapon6_2],[this.ImgWeapon7_1,this.ImgWeapon7_2],[this.ImgWeapon8_1,this.ImgWeapon8_2],[this.ImgWeapon9_1,this.ImgWeapon9_2]];
         this.weaponButtons_Light = [[this.ImgWeapon1_2_light,this.ImgWeapon1_2_light],[this.ImgWeapon2_1_light,this.ImgWeapon2_2_light],[this.ImgWeapon3_1_light,this.ImgWeapon3_2_light],[this.ImgWeapon4_1_light,this.ImgWeapon4_2_light],[this.ImgWeapon5_1_light,this.ImgWeapon5_2_light],[this.ImgWeapon6_1_light,this.ImgWeapon6_2_light],[this.ImgWeapon7_1_light,this.ImgWeapon7_2_light],[this.ImgWeapon8_1_light,this.ImgWeapon8_2_light],[this.ImgWeapon9_1_light,this.ImgWeapon9_2_light]];
         this.weaponButtons_Block = [[this.ImgWeapon1_2_block,this.ImgWeapon1_2_block],[this.ImgWeapon2_1_block,this.ImgWeapon2_2_block],[this.ImgWeapon3_1_block,this.ImgWeapon3_2_block],[this.ImgWeapon4_1_block,this.ImgWeapon4_2_block],[this.ImgWeapon5_1_block,this.ImgWeapon5_2_block],[this.ImgWeapon6_1_block,this.ImgWeapon6_2_block],[this.ImgWeapon7_1_block,this.ImgWeapon7_2_block],[this.ImgWeapon8_1_block,this.ImgWeapon8_2_block],[this.ImgWeapon9_1_block,this.ImgWeapon9_2_block]];
         this.lang = new Texts();
         this.param = new Params();
         super();
         ach42 = function():void
         {
            var _loc1_:Boolean = false;
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            if(shared.data.archivement[6][5] == 0)
            {
               _loc1_ = true;
               _loc2_ = 0;
               while(_loc2_ < shared.data.archivement.length)
               {
                  _loc3_ = 0;
                  while(_loc3_ < shared.data.archivement[_loc2_].length)
                  {
                     if(shared.data.archivement[_loc2_][_loc3_] == 0)
                     {
                        if(_loc2_ != 6 && _loc3_ != 5)
                        {
                           _loc1_ = false;
                           break;
                        }
                     }
                     _loc3_++;
                  }
                  _loc2_++;
               }
               if(_loc1_ == true)
               {
                  shared.data.archivement[6][5] = 1;
                  shared.data.score += 42;
               }
            }
         };
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
         statButtonPush = function():void
         {
            FlxG.play(SndMenuClick);
            FlxG.state = new ShopStatistics();
         };
         shared = SharedObject.getLocal("reloaded");
         this.param.achievements();
         ach42();
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
         specialPoints = new FlxText(120,416,FlxG.width,this.lang.special_points + String(shared.data.sp)).setFormat(null,8,14868183,"left",2309720);
         add(specialPoints);
         skillsGuns = new FlxText(145,72,FlxG.width,this.lang.skillsGuns).setFormat(null,16,14868183,"left",2309720);
         add(skillsGuns);
         achievementsText = new FlxText(337,72,FlxG.width,this.lang.achievements).setFormat(null,16,11052705,"left",2309720);
         add(achievementsText);
         characterText = new FlxText(120,106,FlxG.width,this.lang.character);
         characterText.color = 14868183;
         characterText.size = 8;
         characterText.shadow = 2309720;
         add(characterText);
         yyy = 16;
         plSkills_Y = 126;
         plSkills_X = 120;
         player_life = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.life).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         player_damage = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.damage).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         player_accuracy = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.accuracy).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         player_speed = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.speed).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         player_recharge = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.recharge).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         player_zHunter = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.zHunter).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         player_luck = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.luck).setFormat(null,8,14868183,"left",2309720);
         add(player_life);
         add(player_damage);
         add(player_accuracy);
         add(player_speed);
         add(player_recharge);
         add(player_zHunter);
         add(player_luck);
         levels123 = new FlxText(209,113,FlxG.width,this.lang.levels123).setFormat(null,8,14868183,"left",2309720);
         add(levels123);
         xx = 211;
         yy = 126;
         i = 0;
         while(i < 7)
         {
            k = 0;
            while(k < 3)
            {
               skillButtonPush = function():void
               {
                  if(shared.data.playerSkills[this._line][this._column] == 1)
                  {
                     FlxG.play(SndMenuClick);
                     if(this._column == 0 && shared.data.sp >= 5)
                     {
                        shared.data.sp -= 5;
                        shared.data.playerSkills[this._line][this._column] = 2;
                        FlxG.state = new Shop();
                     }
                     else if(this._column == 1 && shared.data.sp >= 10)
                     {
                        shared.data.sp -= 10;
                        shared.data.playerSkills[this._line][this._column] = 2;
                        FlxG.state = new Shop();
                     }
                     else if(this._column == 2 && shared.data.sp >= 15)
                     {
                        shared.data.sp -= 15;
                        shared.data.playerSkills[this._line][this._column] = 2;
                        FlxG.state = new Shop();
                     }
                  }
               };
               if(shared.data.playerSkills[i][k] == 0 || shared.data.playerSkills[i][k] == 1)
               {
                  if(k != 0)
                  {
                     if(k != 1)
                     {
                        if(k == 2)
                        {
                           if(shared.data.sp >= 15 && shared.data.playerSkills[i][k - 1] == 2)
                           {
                              buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy3);
                              buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy3_light);
                              shared.data.playerSkills[i][k] = 1;
                           }
                           else
                           {
                              buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock3);
                              buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock3);
                              shared.data.playerSkills[i][k] = 0;
                           }
                        }
                     }
                     else if(!(shared.data.sp >= 10 && shared.data.playerSkills[i][k - 1] == 2))
                     {
                        buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock2);
                        buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock2);
                        shared.data.playerSkills[i][k] = 0;
                     }
                     else
                     {
                        buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy2);
                        buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy2_light);
                        shared.data.playerSkills[i][k] = 1;
                     }
                  }
                  else if(shared.data.sp >= 5)
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy1);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy1_light);
                     shared.data.playerSkills[i][k] = 1;
                  }
                  else
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock1);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock1);
                     shared.data.playerSkills[i][k] = 0;
                  }
               }
               else if(shared.data.playerSkills[i][k] == 2)
               {
                  buttonGraphic = new FlxSprite(0,0,this.ImgButtonCheck);
                  buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonCheck);
               }
               skillButton = new FlxButton(xx,yy,skillButtonPush);
               skillButton.loadGraphic(buttonGraphic,buttonGraphicLight);
               skillButton._line = i;
               skillButton._column = k;
               add(skillButton);
               xx += 31;
               k++;
            }
            xx = 211;
            yy += 16;
            i++;
         }
         Bot1Name = new FlxText(120,255,FlxG.width,this.lang.bot1Name).setFormat(null,8,14868183,"left",2309720);
         add(Bot1Name);
         levels123Bot1 = new FlxText(209,260,FlxG.width,this.lang.levels123).setFormat(null,8,14868183,"left",2309720);
         add(levels123Bot1);
         plSkills_Y = 273;
         plSkills_X = 120;
         bot1_speed = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.speed).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         bot1_damage = new FlxText(plSkills_X,plSkills_Y,FlxG.width,"Damage").setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         bot1_accuracy = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.accuracy).setFormat(null,8,14868183,"left",2309720);
         add(bot1_speed);
         add(bot1_damage);
         add(bot1_accuracy);
         xx = 211;
         yy = 273;
         i = 0;
         while(i < 3)
         {
            k = 0;
            while(k < 3)
            {
               Bot1SkillButtonPush = function():void
               {
                  if(shared.data.bot1Skills[this._line][this._column] == 1)
                  {
                     FlxG.play(SndMenuClick);
                     if(this._column == 0 && shared.data.sp >= 5)
                     {
                        shared.data.sp -= 5;
                        shared.data.bot1Skills[this._line][this._column] = 2;
                        FlxG.state = new Shop();
                     }
                     else if(this._column == 1 && shared.data.sp >= 10)
                     {
                        shared.data.sp -= 10;
                        shared.data.bot1Skills[this._line][this._column] = 2;
                        FlxG.state = new Shop();
                     }
                     else if(this._column == 2 && shared.data.sp >= 15)
                     {
                        shared.data.sp -= 15;
                        shared.data.bot1Skills[this._line][this._column] = 2;
                        FlxG.state = new Shop();
                     }
                  }
               };
               if(!(shared.data.bot1Skills[i][k] == 0 || shared.data.bot1Skills[i][k] == 1))
               {
                  if(shared.data.bot1Skills[i][k] == 2)
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonCheck);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonCheck);
                  }
               }
               else if(k == 0)
               {
                  if(shared.data.sp >= 5)
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy1);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy1_light);
                     shared.data.bot1Skills[i][k] = 1;
                  }
                  else
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock1);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock1);
                     shared.data.bot1Skills[i][k] = 0;
                  }
               }
               else if(k != 1)
               {
                  if(k == 2)
                  {
                     if(shared.data.sp >= 15 && shared.data.bot1Skills[i][k - 1] == 2)
                     {
                        buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy3);
                        buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy3_light);
                        shared.data.bot1Skills[i][k] = 1;
                     }
                     else
                     {
                        buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock3);
                        buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock3);
                        shared.data.bot1Skills[i][k] = 0;
                     }
                  }
               }
               else if(!(shared.data.sp >= 10 && shared.data.bot1Skills[i][k - 1] == 2))
               {
                  buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock2);
                  buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock2);
                  shared.data.bot1Skills[i][k] = 0;
               }
               else
               {
                  buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy2);
                  buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy2_light);
                  shared.data.bot1Skills[i][k] = 1;
               }
               skillButton = new FlxButton(xx,yy,Bot1SkillButtonPush);
               skillButton.loadGraphic(buttonGraphic,buttonGraphicLight);
               skillButton._line = i;
               skillButton._column = k;
               add(skillButton);
               xx += 31;
               k++;
            }
            xx = 211;
            yy += 16;
            i++;
         }
         Bot2Name = new FlxText(120,338,FlxG.width,this.lang.bot2Name).setFormat(null,8,14868183,"left",2309720);
         add(Bot2Name);
         levels123Bot2 = new FlxText(209,343,FlxG.width,this.lang.levels123).setFormat(null,8,14868183,"left",2309720);
         add(levels123Bot2);
         plSkills_Y = 356;
         plSkills_X = 120;
         bot2_speed = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.speed).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         bot2_damage = new FlxText(plSkills_X,plSkills_Y,FlxG.width,"Damage").setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         bot2_accuracy = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.accuracy).setFormat(null,8,14868183,"left",2309720);
         add(bot2_speed);
         add(bot2_damage);
         add(bot2_accuracy);
         xx = 211;
         yy = 356;
         i = 0;
         while(i < 3)
         {
            k = 0;
            while(k < 3)
            {
               Bot2SkillButtonPush = function():void
               {
                  if(shared.data.bot2Skills[this._line][this._column] == 1)
                  {
                     FlxG.play(SndMenuClick);
                     if(this._column == 0 && shared.data.sp >= 5)
                     {
                        shared.data.sp -= 5;
                        shared.data.bot2Skills[this._line][this._column] = 2;
                        FlxG.state = new Shop();
                     }
                     else if(!(this._column == 1 && shared.data.sp >= 10))
                     {
                        if(this._column == 2 && shared.data.sp >= 15)
                        {
                           shared.data.sp -= 15;
                           shared.data.bot2Skills[this._line][this._column] = 2;
                           FlxG.state = new Shop();
                        }
                     }
                     else
                     {
                        shared.data.sp -= 10;
                        shared.data.bot2Skills[this._line][this._column] = 2;
                        FlxG.state = new Shop();
                     }
                  }
               };
               if(!(shared.data.bot2Skills[i][k] == 0 || shared.data.bot2Skills[i][k] == 1))
               {
                  if(shared.data.bot2Skills[i][k] == 2)
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonCheck);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonCheck);
                  }
               }
               else if(k == 0)
               {
                  if(shared.data.sp >= 5)
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy1);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy1_light);
                     shared.data.bot2Skills[i][k] = 1;
                  }
                  else
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock1);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock1);
                     shared.data.bot2Skills[i][k] = 0;
                  }
               }
               else if(k == 1)
               {
                  if(shared.data.sp >= 10 && shared.data.bot2Skills[i][k - 1] == 2)
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy2);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy2_light);
                     shared.data.bot2Skills[i][k] = 1;
                  }
                  else
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock2);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock2);
                     shared.data.bot2Skills[i][k] = 0;
                  }
               }
               else if(k == 2)
               {
                  if(!(shared.data.sp >= 15 && shared.data.bot2Skills[i][k - 1] == 2))
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBlock3);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBlock3);
                     shared.data.bot2Skills[i][k] = 0;
                  }
                  else
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgButtonBuy3);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgButtonBuy3_light);
                     shared.data.bot2Skills[i][k] = 1;
                  }
               }
               skillButton = new FlxButton(xx,yy,Bot2SkillButtonPush);
               skillButton.loadGraphic(buttonGraphic,buttonGraphicLight);
               skillButton._line = i;
               skillButton._column = k;
               add(skillButton);
               xx += 31;
               k++;
            }
            xx = 211;
            yy += 16;
            i++;
         }
         moneyText = new FlxText(353,416,FlxG.width,this.lang.money + String(shared.data.money) + "$").setFormat(null,8,14868183,"left",2309720);
         add(moneyText);
         weaponText = new FlxText(353,106,FlxG.width,this.lang.weapon).setFormat(null,8,14868183,"left",2309720);
         add(weaponText);
         plSkills_Y = 126;
         plSkills_X = 353;
         weapon1 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon1).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         weapon2 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon2).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         weapon3 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon3).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         weapon4 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon4).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         weapon5 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon5).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         weapon6 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon6).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         weapon7 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon7).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         weapon8 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon8).setFormat(null,8,14868183,"left",2309720);
         plSkills_Y += yyy;
         weapon9 = new FlxText(plSkills_X,plSkills_Y,FlxG.width,this.lang.weapon9).setFormat(null,8,14868183,"left",2309720);
         add(weapon1);
         add(weapon2);
         add(weapon3);
         add(weapon4);
         add(weapon5);
         add(weapon6);
         add(weapon7);
         add(weapon8);
         add(weapon9);
         weaponsBuyUp = new FlxText(485,113,FlxG.width,this.lang.weaponsBuyUpgr).setFormat(null,8,14868183,"left",2309720);
         add(weaponsBuyUp);
         wx = 480;
         wy = 126;
         i = 0;
         while(i < 9)
         {
            k = 0;
            while(k < 2)
            {
               weaponButtonPush = function():void
               {
                  if(shared.data.playerWeapons[this._line][this._column] == 1 && shared.data.money > param.weapon_price[this._line][this._column])
                  {
                     shared.data.money -= param.weapon_price[this._line][this._column];
                     shared.data.playerWeapons[this._line][this._column] = 2;
                     FlxG.play(SndMenuClick);
                     FlxG.state = new Shop();
                  }
               };
               if(shared.data.playerWeapons[i][k] == 0 || shared.data.playerWeapons[i][k] == 1)
               {
                  if(shared.data.money <= this.param.weapon_price[i][k])
                  {
                     buttonGraphic = new FlxSprite(0,0,this.weaponButtons_Block[i][k]);
                     buttonGraphicLight = new FlxSprite(0,0,this.weaponButtons_Block[i][k]);
                  }
                  else if(k == 0)
                  {
                     buttonGraphic = new FlxSprite(0,0,this.weaponButtons[i][k]);
                     buttonGraphicLight = new FlxSprite(0,0,this.weaponButtons_Light[i][k]);
                     shared.data.playerWeapons[i][k] = 1;
                  }
                  else if(k == 1)
                  {
                     if(shared.data.playerWeapons[i][k - 1] == 2)
                     {
                        buttonGraphic = new FlxSprite(0,0,this.weaponButtons[i][k]);
                        buttonGraphicLight = new FlxSprite(0,0,this.weaponButtons_Light[i][k]);
                        shared.data.playerWeapons[i][k] = 1;
                     }
                     else
                     {
                        buttonGraphic = new FlxSprite(0,0,this.weaponButtons_Block[i][k]);
                        buttonGraphicLight = new FlxSprite(0,0,this.weaponButtons_Block[i][k]);
                        shared.data.playerWeapons[i][k] = 0;
                     }
                  }
               }
               else if(shared.data.playerWeapons[i][k] == 2)
               {
                  buttonGraphic = new FlxSprite(0,0,this.ImgWeaponCheck);
                  buttonGraphicLight = new FlxSprite(0,0,this.ImgWeaponCheck);
               }
               weaponButton = new FlxButton(wx,wy,weaponButtonPush);
               weaponButton.loadGraphic(buttonGraphic,buttonGraphicLight);
               weaponButton._line = i;
               weaponButton._column = k;
               add(weaponButton);
               wx += 38;
               k++;
            }
            wx = 480;
            wy += 16;
            i++;
         }
         barricadeText = new FlxText(353,295,FlxG.width,this.lang.barricade).setFormat(null,8,14868183,"left",2309720);
         add(barricadeText);
         barricadeHealth = new FlxText(420,295,FlxG.width,this.lang.left + String(shared.data.leftBarricade) + "/" + String(shared.data.leftBarricade_Max) + "  " + this.lang.right + String(shared.data.rightBarricade) + "/" + String(shared.data.rightBarricade_Max)).setFormat(null,8,14868183,"left",2309720);
         add(barricadeHealth);
         barricadeLvls = new FlxText(441,310,FlxG.width,this.lang.levels123Barricades).setFormat(null,8,14868183,"left",2309720);
         add(barricadeLvls);
         upgradeRight = new FlxText(353,321,FlxG.width,this.lang.upgradeRight).setFormat(null,8,14868183,"left",2309720);
         add(upgradeRight);
         upgradeLeft = new FlxText(353,upgradeRight.y + 16,FlxG.width,this.lang.upgradeLeft).setFormat(null,8,14868183,"left",2309720);
         add(upgradeLeft);
         bx = 442;
         by = 323;
         i = 0;
         while(i < 2)
         {
            k = 0;
            while(k < 3)
            {
               barricadeButtonPush = function():void
               {
                  if(shared.data.barricadesUpgrade[this._line][this._column] == 1 && shared.data.money > param.barricade_price[this._line][this._column])
                  {
                     shared.data.money -= param.barricade_price[this._line][this._column];
                     shared.data.barricadesUpgrade[this._line][this._column] = 2;
                     if(this._line == 0)
                     {
                        shared.data.rightBarricade_lvl += 1;
                        if(shared.data.rightBarricade_lvl != 0)
                        {
                           if(shared.data.rightBarricade_lvl == 1)
                           {
                              shared.data.rightBarricade_Max = 150;
                              shared.data.rightBarricade += 50;
                           }
                           else if(shared.data.rightBarricade_lvl == 2)
                           {
                              shared.data.rightBarricade_Max = 200;
                              shared.data.rightBarricade += 50;
                           }
                           else if(shared.data.rightBarricade_lvl == 3)
                           {
                              shared.data.rightBarricade_Max = 250;
                              shared.data.rightBarricade += 50;
                           }
                        }
                        else
                        {
                           shared.data.rightBarricade_Max = 100;
                        }
                     }
                     else if(this._line == 1)
                     {
                        shared.data.leftBarricade_lvl += 1;
                        if(shared.data.leftBarricade_lvl == 0)
                        {
                           shared.data.leftBarricade_Max = 100;
                        }
                        else if(shared.data.leftBarricade_lvl != 1)
                        {
                           if(shared.data.leftBarricade_lvl == 2)
                           {
                              shared.data.leftBarricade_Max = 200;
                              shared.data.leftBarricade += 50;
                           }
                           else if(shared.data.leftBarricade_lvl == 3)
                           {
                              shared.data.leftBarricade_Max = 250;
                              shared.data.leftBarricade += 50;
                           }
                        }
                        else
                        {
                           shared.data.leftBarricade_Max = 150;
                           shared.data.leftBarricade += 50;
                        }
                     }
                     FlxG.play(SndMenuClick);
                     FlxG.state = new Shop();
                  }
               };
               if(!(shared.data.barricadesUpgrade[i][k] == 0 || shared.data.barricadesUpgrade[i][k] == 1))
               {
                  if(shared.data.barricadesUpgrade[i][k] == 2)
                  {
                     buttonGraphic = new FlxSprite(0,0,this.ImgWeaponCheck);
                     buttonGraphicLight = new FlxSprite(0,0,this.ImgWeaponCheck);
                  }
               }
               else if(shared.data.money <= this.param.barricade_price[i][k])
               {
                  buttonGraphic = new FlxSprite(0,0,this.barricadesButtons_Block[i][k]);
                  buttonGraphicLight = new FlxSprite(0,0,this.barricadesButtons_Block[i][k]);
               }
               else if(k == 0)
               {
                  buttonGraphic = new FlxSprite(0,0,this.barricadesButtons[i][k]);
                  buttonGraphicLight = new FlxSprite(0,0,this.barricadesButtons_Light[i][k]);
                  shared.data.barricadesUpgrade[i][k] = 1;
               }
               else if(k != 1)
               {
                  if(k == 2)
                  {
                     if(shared.data.barricadesUpgrade[i][k - 1] == 2)
                     {
                        buttonGraphic = new FlxSprite(0,0,this.barricadesButtons[i][k]);
                        buttonGraphicLight = new FlxSprite(0,0,this.barricadesButtons_Light[i][k]);
                        shared.data.barricadesUpgrade[i][k] = 1;
                     }
                     else
                     {
                        buttonGraphic = new FlxSprite(0,0,this.barricadesButtons_Block[i][k]);
                        buttonGraphicLight = new FlxSprite(0,0,this.barricadesButtons_Block[i][k]);
                        shared.data.barricadesUpgrade[i][k] = 0;
                     }
                  }
               }
               else if(shared.data.barricadesUpgrade[i][k - 1] == 2)
               {
                  buttonGraphic = new FlxSprite(0,0,this.barricadesButtons[i][k]);
                  buttonGraphicLight = new FlxSprite(0,0,this.barricadesButtons_Light[i][k]);
                  shared.data.barricadesUpgrade[i][k] = 1;
               }
               else
               {
                  buttonGraphic = new FlxSprite(0,0,this.barricadesButtons_Block[i][k]);
                  buttonGraphicLight = new FlxSprite(0,0,this.barricadesButtons_Block[i][k]);
                  shared.data.barricadesUpgrade[i][k] = 0;
               }
               barricadeButton = new FlxButton(bx,by,barricadeButtonPush);
               barricadeButton.loadGraphic(buttonGraphic,buttonGraphicLight);
               barricadeButton._line = i;
               barricadeButton._column = k;
               add(barricadeButton);
               bx += 38;
               k++;
            }
            bx = 442;
            by += 16;
            i++;
         }
         repairRight = new FlxText(353,370,FlxG.width,this.lang.repairRight).setFormat(null,8,14868183,"left",2309720);
         add(repairRight);
         repairLeft = new FlxText(353,repairRight.y + 16,FlxG.width,this.lang.repairLeft).setFormat(null,8,14868183,"left",2309720);
         add(repairLeft);
         repairPrice = new FlxText(447,359,FlxG.width,this.lang.repairPrice).setFormat(null,8,14868183,"left",2309720);
         add(repairPrice);
         rx = 442;
         ry = 372;
         i = 0;
         while(i < 2)
         {
            k = 0;
            while(k < 3)
            {
               barricadeRepairButtonPush = function():void
               {
                  if(!(this._line == 0 && shared.data.rightBarricade < shared.data.rightBarricade_Max))
                  {
                     if(this._line == 1 && shared.data.leftBarricade < shared.data.leftBarricade_Max)
                     {
                        if(shared.data.money >= param.barricadeRepair_price[this._line][this._column])
                        {
                           shared.data.money -= param.barricadeRepair_price[this._line][this._column];
                           if(this._line == 1)
                           {
                              if(this._column == 0)
                              {
                                 shared.data.leftBarricade += Math.floor(shared.data.leftBarricade_Max * 0.1);
                              }
                              if(this._column == 1)
                              {
                                 shared.data.leftBarricade += Math.floor(shared.data.leftBarricade_Max * 0.3);
                              }
                              if(this._column == 2)
                              {
                                 shared.data.leftBarricade = shared.data.leftBarricade_Max;
                              }
                              if(shared.data.leftBarricade > shared.data.leftBarricade_Max)
                              {
                                 shared.data.leftBarricade = shared.data.leftBarricade_Max;
                              }
                           }
                        }
                        FlxG.play(SndMenuClick);
                        FlxG.state = new Shop();
                     }
                  }
                  else
                  {
                     if(shared.data.money >= param.barricadeRepair_price[this._line][this._column])
                     {
                        shared.data.money -= param.barricadeRepair_price[this._line][this._column];
                        if(this._line == 0)
                        {
                           if(this._column == 0)
                           {
                              shared.data.rightBarricade += Math.floor(shared.data.rightBarricade_Max * 0.1);
                           }
                           if(this._column == 1)
                           {
                              shared.data.rightBarricade += Math.floor(shared.data.rightBarricade_Max * 0.3);
                           }
                           if(this._column == 2)
                           {
                              shared.data.rightBarricade = shared.data.rightBarricade_Max;
                           }
                           if(shared.data.rightBarricade > shared.data.rightBarricade_Max)
                           {
                              shared.data.rightBarricade = shared.data.rightBarricade_Max;
                           }
                        }
                     }
                     FlxG.play(SndMenuClick);
                     FlxG.state = new Shop();
                  }
               };
               if(i == 0)
               {
                  if(k == 0)
                  {
                     if(!(shared.data.money > this.param.barricadeRepair_price[i][k] && shared.data.rightBarricade < shared.data.rightBarricade_Max))
                     {
                        buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                        buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                     }
                     else
                     {
                        buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons[i][k]);
                        buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Light[i][k]);
                     }
                  }
                  else if(k != 1)
                  {
                     if(k == 2)
                     {
                        if(!(shared.data.money > this.param.barricadeRepair_price[i][k] && shared.data.rightBarricade < shared.data.rightBarricade_Max))
                        {
                           buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                           buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                        }
                        else
                        {
                           buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons[i][k]);
                           buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Light[i][k]);
                        }
                     }
                  }
                  else if(!(shared.data.money > this.param.barricadeRepair_price[i][k] && shared.data.rightBarricade < shared.data.rightBarricade_Max))
                  {
                     buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                     buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                  }
                  else
                  {
                     buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons[i][k]);
                     buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Light[i][k]);
                  }
               }
               else if(i == 1)
               {
                  if(k == 0)
                  {
                     if(!(shared.data.money > this.param.barricadeRepair_price[i][k] && shared.data.leftBarricade < shared.data.leftBarricade_Max))
                     {
                        buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                        buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                     }
                     else
                     {
                        buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons[i][k]);
                        buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Light[i][k]);
                     }
                  }
                  else if(k != 1)
                  {
                     if(k == 2)
                     {
                        if(!(shared.data.money > this.param.barricadeRepair_price[i][k] && shared.data.leftBarricade < shared.data.leftBarricade_Max))
                        {
                           buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                           buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                        }
                        else
                        {
                           buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons[i][k]);
                           buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Light[i][k]);
                        }
                     }
                  }
                  else if(!(shared.data.money > this.param.barricadeRepair_price[i][k] && shared.data.leftBarricade < shared.data.leftBarricade_Max))
                  {
                     buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                     buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Block[i][k]);
                  }
                  else
                  {
                     buttonGraphic = new FlxSprite(0,0,this.barricadesRepairButtons[i][k]);
                     buttonGraphicLight = new FlxSprite(0,0,this.barricadesRepairButtons_Light[i][k]);
                  }
               }
               barricadeRepairButton = new FlxButton(rx,ry,barricadeRepairButtonPush);
               barricadeRepairButton.loadGraphic(buttonGraphic,buttonGraphicLight);
               barricadeRepairButton._line = i;
               barricadeRepairButton._column = k;
               add(barricadeRepairButton);
               rx += 38;
               k++;
            }
            rx = 442;
            ry += 16;
            i++;
         }
         statButton = new FlxButton(320,63,statButtonPush);
         StatButtonGraphic = new FlxSprite(0,0,this.ImgStat_Button);
         StatButtonGraphicLight = new FlxSprite(0,0,this.ImgStat_Button_light);
         statButton.loadGraphic(StatButtonGraphic,StatButtonGraphicLight);
         add(statButton);
         this._cursor = new FlxSprite(0,0,this.ImgCursor);
         this._cursor.solid = false;
         add(this._cursor);
      }
      
      private function OBF_1a14() : void
      {
         FlxG.state = new PlayLvl();
      }
      
      override public function update() : void
      {
         this._cursor.x = FlxG.mouse.x;
         this._cursor.y = FlxG.mouse.y;
         super.update();
      }
   }
}

