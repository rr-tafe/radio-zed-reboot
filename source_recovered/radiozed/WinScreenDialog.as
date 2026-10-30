package
{
   import org.flixel.FlxButton;
   import org.flixel.FlxG;
   import org.flixel.FlxSprite;
   import org.flixel.FlxState;
   import org.flixel.FlxText;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.Mouse;
   
   public class WinScreenDialog extends FlxState
   {
      
      private var SndMenuClick:Class;
      
      private var start:FlxButton;
      
      protected var shared:SharedObject;
      
      private var ImgCursor:Class;
      
      private var dialog_img:Class;
      
      private var backGround_Img:Class;
      
      private var ImgButton:Class;
      
      private var _cursor:FlxSprite;
      
      private var Img_main_menu_button_light:Class;
      
      public function WinScreenDialog(param1:Number = 0)
      {
         var bobText:String;
         var dialog:FlxSprite;
         var backGround:FlxSprite;
         var _score:FlxText;
         var menu_button_Continue:FlxButton;
         var menu_button_Graphic_Light:FlxSprite;
         var menu_button_Graphic:FlxSprite;
         var scoreText:String;
         var menuText:FlxText;
         var menu_button_PlayGame:FlxButton;
         var bob:FlxText;
         var menu_button_PlayGame_Push:Function = null;
         var menu_button_Continue_Push:Function = null;
         var score:Number = param1;
         this.ImgCursor = winScreen_dialog_ImgCursor;
         this.ImgButton = winScreen_dialog_ImgButton;
         this.dialog_img = winScreen_dialog_dialog_img;
         this.backGround_Img = winScreen_dialog_backGround_Img;
         this.Img_main_menu_button_light = winScreen_dialog_Img_main_menu_button_light;
         this.SndMenuClick = winScreen_dialog_SndMenuClick;
         super();
         menu_button_PlayGame_Push = function():void
         {
            FlxG.play(SndMenuClick);
            FlxG.state = new Menu();
         };
         menu_button_Continue_Push = function():void
         {
            FlxG.play(SndMenuClick);
            var _loc2_:URLRequest = new URLRequest("http://www.andkon.com/arcade/");
            navigateToURL(_loc2_,"_blank");
         };
         this.shared = SharedObject.getLocal("reloaded");
         backGround = new FlxSprite(0,0,this.backGround_Img);
         backGround.x = 0;
         backGround.y = 0;
         backGround.solid = false;
         add(backGround);
         dialog = new FlxSprite(0,0,this.dialog_img);
         dialog.x = 255;
         dialog.y = 430;
         dialog.solid = false;
         add(dialog);
         menuText = new FlxText(290,433,FlxG.width,"You survived!").setFormat(null,8,11052705,"left",2309720);
         add(menuText);
         bobText = " Menu              More";
         bob = new FlxText(270,449,FlxG.width,bobText).setFormat(null,8,14868183,"left",2309720);
         add(bob);
         menu_button_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Graphic.alpha = 0;
         menu_button_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         scoreText = "Final score: " + String(score);
         _score = new FlxText(0,190,FlxG.width,scoreText).setFormat(null,32,16777215,"center",2309720);
         add(_score);
         menu_button_PlayGame = new FlxButton(256,449,menu_button_PlayGame_Push);
         menu_button_PlayGame.loadGraphic(menu_button_Graphic,menu_button_Graphic_Light);
         add(menu_button_PlayGame);
         menu_button_Graphic = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Graphic.alpha = 0;
         menu_button_Graphic_Light = new FlxSprite(0,0,this.Img_main_menu_button_light);
         menu_button_Continue = new FlxButton(322,449,menu_button_Continue_Push);
         menu_button_Continue.loadGraphic(menu_button_Graphic,menu_button_Graphic_Light);
         add(menu_button_Continue);
      }
      
      override public function update() : void
      {
         Mouse.show();
         super.update();
      }
   }
}

