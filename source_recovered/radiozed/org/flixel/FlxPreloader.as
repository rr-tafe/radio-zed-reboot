package org.flixel
{
   import OBF_1c07.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import mochi.as3.*;
   
   public dynamic class FlxPreloader extends MovieClip
   {
      
      public static var MAIN_CLASS:String = "Main";
      
      public static var GAME_OPTIONS:Object = {
         "id":"2a1320298becc537",
         "res":"640x480"
      };
      
      protected var _logo:Bitmap;
      
      protected var _text:TextField;
      
      private var buttonPlaced:Boolean = false;
      
      private var timerStart:Boolean = false;
      
      public var className:String;
      
      private var did_load:Boolean;
      
      private var splash_Button:Class;
      
      public var myURL:String;
      
      private var bob:Boolean = false;
      
      protected var _logoGlow:Bitmap;
      
      private var button1:MovieClip;
      
      protected var _height:uint;
      
      protected var _width:uint;
      
      protected var ImgLogoLight:Class;
      
      protected var _buffer:Sprite;
      
      private var zatticca:MovieClip;
      
      private var timerStop:Boolean = false;
      
      private var Img_but1:Class;
      
      private var Img_but2:Class;
      
      protected var ImgLogo:Class;
      
      protected var _init:Boolean;
      
      protected var ImgLogoCorners:Class;
      
      private var _timer:Timer;
      
      protected var _bmpBar:Bitmap;
      
      private var preloaderBADHED:Class;
      
      private var startGame:Boolean = false;
      
      public function FlxPreloader()
      {
         var tmp:Bitmap = null;
         var re:RegExp = null;
         var fmt:TextFormat = null;
         var txt:TextField = null;
         this.preloaderBADHED = FlxPreloader_preloaderBADHED;
         this.ImgLogo = FlxPreloader_ImgLogo;
         this.ImgLogoCorners = FlxPreloader_ImgLogoCorners;
         this.ImgLogoLight = FlxPreloader_ImgLogoLight;
         this.splash_Button = FlxPreloader_splash_Button;
         this.Img_but1 = FlxPreloader_Img_but1;
         this.Img_but2 = FlxPreloader_Img_but2;
         super();
         MochiBot.track(this,"79d2cfc1");
         MochiBot.track(this,"20633017");
         if(this.OBF_1d0b(["www.andkon.com","andkon.com"]))
         {
            stop();
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            try
            {
               throw new Error("Setting global debug flag...");
            }
            catch(e:Error)
            {
               re = /\[.*:[0-9]+\]/;
               FlxG.debug = re.test(e.getStackTrace());
            }
            if(!FlxG.debug && this.myURL != null && root.loaderInfo.url.indexOf(this.myURL) < 0)
            {
               tmp = new Bitmap(new BitmapData(stage.stageWidth,stage.stageHeight,true,4294967295));
               addChild(tmp);
               fmt = new TextFormat();
               fmt.color = 0;
               fmt.size = 16;
               fmt.align = "center";
               fmt.bold = true;
               fmt.font = "system";
               txt = new TextField();
               txt.width = tmp.width - 16;
               txt.height = tmp.height - 16;
               txt.y = 8;
               txt.multiline = true;
               txt.wordWrap = true;
               txt.embedFonts = true;
               txt.defaultTextFormat = fmt;
               txt.text = "?";
               addChild(txt);
               txt.addEventListener(MouseEvent.CLICK,this.OBF_1d10);
               tmp.addEventListener(MouseEvent.CLICK,this.OBF_1d10);
               return;
            }
            this._init = false;
            addEventListener(Event.ENTER_FRAME,this.OBF_1c13);
         }
      }
      
      private function OBF_1810(param1:TimerEvent) : void
      {
         addChild(this.button1);
         this._timer.stop();
      }
      
      private function OBF_1a0d() : void
      {
         this._timer = new Timer(3000);
         this._timer.addEventListener(TimerEvent.TIMER,this.OBF_1810);
         this._timer.start();
      }
      
      private function OBF_1c13(param1:Event) : void
      {
         var _loc3_:Class = null;
         var _loc4_:Object = null;
         if(!this._init)
         {
            if(stage.stageWidth <= 0 || stage.stageHeight <= 0)
            {
               return;
            }
            this.create();
            this._init = true;
         }
         graphics.clear();
         if(this.buttonPlaced == false && framesLoaded >= totalFrames)
         {
            this.OBF_1a0d();
            this.buttonPlaced = true;
         }
         if(framesLoaded >= totalFrames && this.startGame == true)
         {
            removeEventListener(Event.ENTER_FRAME,this.OBF_1c13);
            nextFrame();
            _loc3_ = Class(getDefinitionByName(this.className));
            if(_loc3_)
            {
               _loc4_ = new _loc3_();
               addChild(_loc4_ as DisplayObject);
            }
            removeChild(this._buffer);
         }
         else
         {
            this.update(root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal);
         }
      }
      
      protected function update(param1:Number) : void
      {
         this._bmpBar.scaleX = param1 * (this._width - 8);
         this._text.text = "                                         Infecting " + FlxU.floor(param1 * 100) + "%";
         if(FlxU.floor(param1 * 100) < 100)
         {
            this._text.text = "Downloading " + FlxU.floor(param1 * 100) + "%";
            this._text.text = "";
         }
         else
         {
            this._text.text = "";
         }
         this._text.setTextFormat(this._text.defaultTextFormat);
         if(param1 < 0.1)
         {
            this._logoGlow.alpha = 0;
            this._logo.alpha = 0;
         }
         else if(param1 < 0.99)
         {
            this._logoGlow.alpha = param1;
            this._logo.alpha = 0;
         }
      }
      
      public function OBF_1d0b(param1:Array) : Boolean
      {
         var _loc2_:String = loaderInfo.loaderURL;
         var _loc3_:Number = _loc2_.indexOf("://") + 3;
         var _loc4_:Number = _loc2_.indexOf("/",_loc3_);
         var _loc5_:String = _loc2_.substring(_loc3_,_loc4_);
         var _loc6_:Number = _loc5_.lastIndexOf(".") - 1;
         var _loc7_:Number = _loc5_.lastIndexOf(".",_loc6_) + 1;
         _loc5_ = _loc5_.substring(_loc7_,_loc5_.length);
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            if(_loc5_ == param1[_loc8_])
            {
               return true;
            }
            _loc8_++;
         }
         return false;
      }
      
      private function OBF_1d10(param1:MouseEvent = null) : void
      {
      }
      
      private function OBF_1a15(param1:MouseEvent) : void
      {
         var _loc3_:URLRequest = new URLRequest("http://www.andkon.com/arcade/");
         navigateToURL(_loc3_,"_blank");
      }
      
      protected function create() : void
      {
         var b:Bitmap;
         var i:uint;
         var buttonSplash_Push:Function = null;
         var j:uint = 0;
         buttonSplash_Push = function():void
         {
            startGame = true;
            removeChild(button1);
         };
         this._buffer = new Sprite();
         this._buffer.scaleX = 2;
         this._buffer.scaleY = 2;
         addChild(this._buffer);
         this._width = stage.stageWidth / this._buffer.scaleX;
         this._height = stage.stageHeight / this._buffer.scaleY;
         this._buffer.addChild(new Bitmap(new BitmapData(this._width,this._height,false,4472892)));
         b = new this.ImgLogoLight();
         b.smoothing = true;
         b.width = b.height = this._height;
         b.x = (this._width - b.width) / 2;
         this._buffer.addChild(b);
         this._bmpBar = new Bitmap(new BitmapData(1,7,false,14868183));
         this._bmpBar.x = 4;
         this._bmpBar.y = this._height - 11;
         this._buffer.addChild(this._bmpBar);
         this._text = new TextField();
         this._text.defaultTextFormat = new TextFormat("system",16,14868183);
         this._text.embedFonts = true;
         this._text.selectable = false;
         this._text.multiline = false;
         this._text.x = 2;
         this._text.y = this._bmpBar.y - 11;
         this._text.width = 640;
         this._buffer.addChild(this._text);
         this._logo = new this.ImgLogo();
         this._logo.x = (this._width - this._logo.width) / 2;
         this._logo.y = (this._height - this._logo.height) / 2;
         this._buffer.addChild(this._logo);
         this._logoGlow = new this.ImgLogo();
         this._logoGlow.smoothing = true;
         this._logoGlow.blendMode = "screen";
         this._logoGlow.x = (this._width - this._logoGlow.width) / 2;
         this._logoGlow.y = (this._height - this._logoGlow.height) / 2;
         this._buffer.addChild(this._logoGlow);
         b = new this.ImgLogoCorners();
         b.smoothing = true;
         b.width = this._width;
         b.height = this._height;
         this._buffer.addChild(b);
         b = new Bitmap(new BitmapData(this._width,this._height,false,16777215));
         i = 0;
         while(i < this._height)
         {
            j = 0;
            while(j < this._width)
            {
               b.bitmapData.setPixel(j,i,0);
               j++;
            }
            i += 2;
         }
         b.blendMode = "overlay";
         b.alpha = 0.15;
         this._buffer.addChild(b);
         this._buffer.buttonMode = true;
         this._buffer.addEventListener(MouseEvent.CLICK,this.OBF_1a15);
         this._text.x = 5;
         this._text.y = 400;
         addChild(this._text);
         this.button1 = new this.splash_Button();
         this.button1.addEventListener(MouseEvent.CLICK,buttonSplash_Push);
         this.button1.x = 258;
         this.button1.y = 400;
         this.button1.blendMode = "screen";
      }
   }
}

