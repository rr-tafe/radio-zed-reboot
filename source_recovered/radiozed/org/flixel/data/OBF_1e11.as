package org.flixel.data
{
   import org.flixel.FlxG;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class OBF_1e11 extends Sprite
   {
      
      protected var _lines:Array;
      
      public var lastElapsed:Number;
      
      protected var _text:TextField;
      
      protected var _fpsUpdate:Boolean;
      
      protected var _console:Sprite;
      
      protected var _Y:Number;
      
      protected const MAX_CONSOLE_LINES:uint = 256;
      
      protected var _curFPS:uint;
      
      protected var _fps:Array;
      
      protected var _bx:int;
      
      protected var _by:int;
      
      protected var _fpsDisplay:TextField;
      
      protected var _YT:Number;
      
      protected var _byt:int;
      
      public function OBF_1e11(param1:uint, param2:uint, param3:uint)
      {
         super();
         visible = false;
         x = param1 * param3;
         this._by = param2 * param3;
         this._byt = this._by - FlxG.height * param3;
         this._YT = this._Y = y = this._byt;
         var _loc4_:Bitmap = new Bitmap(new BitmapData(FlxG.width * param3,FlxG.height * param3,true,2130706432));
         addChild(_loc4_);
         this._fps = new Array(8);
         this._curFPS = 0;
         this._fpsUpdate = true;
         this._text = new TextField();
         this._text.width = _loc4_.width;
         this._text.height = _loc4_.height;
         this._text.multiline = true;
         this._text.wordWrap = true;
         this._text.embedFonts = true;
         this._text.antiAliasType = AntiAliasType.NORMAL;
         this._text.gridFitType = GridFitType.PIXEL;
         this._text.defaultTextFormat = new TextFormat("system",8,16777215);
         addChild(this._text);
         this._fpsDisplay = new TextField();
         this._fpsDisplay.width = _loc4_.width;
         this._fpsDisplay.height = 20;
         this._fpsDisplay.multiline = true;
         this._fpsDisplay.wordWrap = true;
         this._fpsDisplay.embedFonts = true;
         this._fpsDisplay.antiAliasType = AntiAliasType.NORMAL;
         this._fpsDisplay.gridFitType = GridFitType.PIXEL;
         this._fpsDisplay.defaultTextFormat = new TextFormat("system",16,16777215,true,null,null,null,null,"right");
         addChild(this._fpsDisplay);
         this._lines = new Array();
      }
      
      public function log(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         if(param1 == null)
         {
            param1 = "NULL";
         }
         trace(param1);
         this._lines.push(param1);
         if(this._lines.length <= this.MAX_CONSOLE_LINES)
         {
            this._text.appendText(param1 + "\n");
         }
         else
         {
            this._lines.shift();
            _loc2_ = "";
            _loc3_ = 0;
            while(_loc3_ < this._lines.length)
            {
               _loc2_ += this._lines[_loc3_] + "\n";
               _loc3_++;
            }
            this._text.text = _loc2_;
         }
         this._text.scrollV = this._text.height;
      }
      
      public function update() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(visible)
         {
            this._fps[this._curFPS] = 1 / this.lastElapsed;
            if(++this._curFPS >= this._fps.length)
            {
               this._curFPS = 0;
            }
            this._fpsUpdate = !this._fpsUpdate;
            if(this._fpsUpdate)
            {
               _loc1_ = 0;
               _loc2_ = 0;
               while(_loc2_ < this._fps.length)
               {
                  _loc1_ += this._fps[_loc2_];
                  _loc2_++;
               }
               this._fpsDisplay.text = Math.floor(_loc1_ / this._fps.length) + " fps";
            }
         }
         if(this._Y >= this._YT)
         {
            if(this._Y > this._YT)
            {
               this._Y -= FlxG.height * 10 * FlxG.elapsed;
            }
         }
         else
         {
            this._Y += FlxG.height * 10 * FlxG.elapsed;
         }
         if(this._Y <= this._by)
         {
            if(this._Y < this._byt)
            {
               this._Y = this._byt;
               visible = false;
            }
         }
         else
         {
            this._Y = this._by;
         }
         y = Math.floor(this._Y);
      }
      
      public function toggle() : void
      {
         if(this._YT == this._by)
         {
            this._YT = this._byt;
         }
         else
         {
            this._YT = this._by;
            visible = true;
         }
      }
   }
}

