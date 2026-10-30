package org.flixel
{
   import org.flixel.data.FlxPause;
   import org.flixel.data.OBF_1e11;
   import OBF_1c0a.MouseWheelTrap;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.*;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Mouse;
   import flash.utils.getTimer;
   
   public class FlxGame extends Sprite
   {
      
      internal var _bmpFront:Bitmap;
      
      protected var SndFlixel:Class = FlxGame_SndFlixel;
      
      internal var _state:FlxState;
      
      protected var SndBeep:Class = FlxGame_SndBeep;
      
      internal var _console:OBF_1e11;
      
      protected var testt:String = "FlxGame_testt";
      
      internal var _created:Boolean;
      
      internal var _zoom:uint;
      
      internal var _gameXOffset:int;
      
      internal var _elapsed:Number;
      
      internal var _flipped:Boolean;
      
      internal var _total:uint;
      
      internal var _soundTrayBars:Array;
      
      public var useDefaultHotKeys:Boolean;
      
      protected var junk:String = "FlxGame_junk";
      
      internal var _zeroPoint:Point;
      
      internal var _bmpBack:Bitmap;
      
      internal var _iState:Class;
      
      internal var _paused:Boolean;
      
      internal var _gameYOffset:int;
      
      internal var _buffer:Sprite;
      
      internal const MAX_ELAPSED:Number = 0.0333;
      
      internal var _soundTray:Sprite;
      
      internal var _frame:Class;
      
      internal var _r:Rectangle;
      
      public var pause:FlxGroup;
      
      internal var _soundTrayTimer:Number;
      
      public function FlxGame(param1:uint, param2:uint, param3:Class, param4:uint = 2)
      {
         super();
         if(stage)
         {
            this.OBF_1d0e();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.OBF_1d0e);
         }
         Mouse.hide();
         this._zoom = param4;
         FlxState.bgColor = 4278190080;
         FlxG.setGameData(this,param1,param2,param4);
         this._elapsed = 0;
         this._total = 0;
         this.pause = new FlxPause();
         this._state = null;
         this._iState = param3;
         this._zeroPoint = new Point();
         this.useDefaultHotKeys = true;
         this._frame = null;
         this._gameXOffset = 0;
         this._gameYOffset = 0;
         this._paused = false;
         this._created = false;
         addEventListener(Event.ENTER_FRAME,this.OBF_1c13);
      }
      
      public function OBF_1c02() : void
      {
         if(x != 0 || y != 0)
         {
            x = 0;
            y = 0;
         }
         if(!this._flipped)
         {
            this._bmpBack.bitmapData.copyPixels(this._bmpFront.bitmapData,this._r,this._zeroPoint);
         }
         else
         {
            this._bmpFront.bitmapData.copyPixels(this._bmpBack.bitmapData,this._r,this._zeroPoint);
         }
         Mouse.show();
         this._paused = true;
         stage.frameRate = 10;
      }
      
      public function OBF_1a0a() : void
      {
         if(!FlxG.panel.visible)
         {
            Mouse.hide();
         }
         FlxG.resetInput();
         this._paused = false;
         stage.frameRate = 60;
      }
      
      private function OBF_1d0e(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.OBF_1d0e);
         MouseWheelTrap.setup(stage);
      }
      
      protected function OBF_1c12(param1:Event = null) : void
      {
         if(FlxG.pause)
         {
            FlxG.pause = false;
         }
      }
      
      protected function OBF_1c10(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(!(param1.keyCode == 192 || param1.keyCode == 220))
         {
            if(this.useDefaultHotKeys)
            {
               _loc2_ = int(param1.keyCode);
               _loc3_ = String.fromCharCode(param1.charCode);
               switch(_loc2_)
               {
                  case 48:
                  case 96:
                     FlxG.mute = !FlxG.mute;
                     this.OBF_1a19();
                     return;
                  case 109:
                  case 189:
                     FlxG.mute = false;
                     FlxG.volume -= 0.1;
                     this.OBF_1a19();
                     return;
                  case 107:
                  case 187:
                     FlxG.mute = false;
                     FlxG.volume += 0.1;
                     this.OBF_1a19();
                     return;
                  case 80:
                     FlxG.pause = !FlxG.pause;
               }
            }
            FlxG.keys.handleKeyUp(param1);
            return;
         }
         this._console.toggle();
      }
      
      protected function OBF_1c(param1:Class, param2:uint, param3:uint) : FlxGame
      {
         this._frame = param1;
         this._gameXOffset = param2;
         this._gameYOffset = param3;
         return this;
      }
      
      public function OBF_1a0f(param1:FlxState) : void
      {
         FlxG.unfollow();
         FlxG.resetInput();
         FlxG.destroySounds();
         FlxG.flash.stop();
         FlxG.fade.stop();
         FlxG.quake.stop();
         this._buffer.x = 0;
         this._buffer.y = 0;
         this._buffer.addChild(param1);
         if(this._state != null)
         {
            this._state.destroy();
            this._buffer.swapChildren(param1,this._state);
            this._buffer.removeChild(this._state);
         }
         this._state = param1;
         this._state.create();
      }
      
      protected function OBF_1c13(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:OBF_1e02 = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Bitmap = null;
         var _loc8_:TextField = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Bitmap = null;
         var _loc4_:uint = uint(getTimer());
         this._elapsed = (_loc4_ - this._total) / 1000;
         if(this._created)
         {
            this._console.lastElapsed = this._elapsed;
         }
         this._total = _loc4_;
         FlxG.elapsed = this._elapsed;
         if(FlxG.elapsed > this.MAX_ELAPSED)
         {
            FlxG.elapsed = this.MAX_ELAPSED;
         }
         FlxG.elapsed *= FlxG.timeScale;
         if(this._soundTray != null)
         {
            if(this._soundTrayTimer > 0)
            {
               this._soundTrayTimer -= this._elapsed;
            }
            else if(this._soundTray.y > -this._soundTray.height)
            {
               this._soundTray.y -= this._elapsed * FlxG.height * 2;
               if(this._soundTray.y <= -this._soundTray.height)
               {
                  this._soundTray.visible = false;
                  _loc3_ = new OBF_1e02();
                  if(_loc3_.OBF_14("flixel"))
                  {
                     if(_loc3_.data.sound == null)
                     {
                        _loc3_.data.sound = new Object();
                     }
                     _loc3_.data.mute = FlxG.mute;
                     _loc3_.data.volume = FlxG.volume;
                     _loc3_.OBF_1e01();
                  }
               }
            }
         }
         if(this._created)
         {
            FlxG.panel.update();
            this._console.update();
            FlxG.updateInput();
            FlxG.updateSounds();
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.showDefaultContextMenu = false;
            if(this._paused)
            {
               this.pause.update();
               if(!this._flipped)
               {
                  FlxG.buffer.copyPixels(this._bmpBack.bitmapData,this._r,this._zeroPoint);
               }
               else
               {
                  FlxG.buffer.copyPixels(this._bmpFront.bitmapData,this._r,this._zeroPoint);
               }
               this.pause.render();
            }
            else
            {
               if(!this._flipped)
               {
                  FlxG.buffer = this._bmpBack.bitmapData;
               }
               else
               {
                  FlxG.buffer = this._bmpFront.bitmapData;
               }
               FlxState.screen.unsafeBind(FlxG.buffer);
               this._state.preProcess();
               FlxG.doFollow();
               this._state.update();
               if(FlxG.flash.exists)
               {
                  FlxG.flash.update();
               }
               if(FlxG.fade.exists)
               {
                  FlxG.fade.update();
               }
               FlxG.quake.update();
               this._buffer.x = FlxG.quake.x;
               this._buffer.y = FlxG.quake.y;
               this._state.render();
               if(FlxG.flash.exists)
               {
                  FlxG.flash.render();
               }
               if(FlxG.fade.exists)
               {
                  FlxG.fade.render();
               }
               if(FlxG.panel.visible)
               {
                  FlxG.panel.render();
               }
               if(FlxG.mouse.cursor != null)
               {
                  if(FlxG.mouse.cursor.active)
                  {
                     FlxG.mouse.cursor.update();
                  }
                  if(FlxG.mouse.cursor.visible)
                  {
                     FlxG.mouse.cursor.render();
                  }
               }
               this._state.postProcess();
               this._bmpBack.visible = !(this._bmpFront.visible = this._flipped);
               this._flipped = !this._flipped;
            }
         }
         else if(root != null)
         {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.frameRate = 60;
            this._buffer = new Sprite();
            this._buffer.scaleX = this._zoom;
            this._buffer.scaleY = this._zoom;
            addChild(this._buffer);
            this._bmpBack = new Bitmap(new BitmapData(FlxG.width,FlxG.height,true,FlxState.bgColor));
            this._bmpBack.x = this._gameXOffset;
            this._bmpBack.y = this._gameYOffset;
            this._buffer.addChild(this._bmpBack);
            this._bmpFront = new Bitmap(new BitmapData(this._bmpBack.width,this._bmpBack.height,true,FlxState.bgColor));
            this._bmpFront.x = this._bmpBack.x;
            this._bmpFront.y = this._bmpBack.y;
            this._buffer.addChild(this._bmpFront);
            this._flipped = false;
            this._r = new Rectangle(0,0,this._bmpFront.width,this._bmpFront.height);
            this._console = new OBF_1e11(this._gameXOffset,this._gameYOffset,this._zoom);
            _loc5_ = FlxG.LIBRARY_NAME + " v" + FlxG.LIBRARY_MAJOR_VERSION + "." + FlxG.LIBRARY_MINOR_VERSION;
            if(FlxG.debug)
            {
               _loc5_ += " [debug]";
            }
            else
            {
               _loc5_ += " [release]";
            }
            _loc6_ = "";
            _loc2_ = 0;
            while(_loc2_ < _loc5_.length + 32)
            {
               _loc6_ += "-";
               _loc2_++;
            }
            FlxG.log(_loc5_);
            FlxG.log(_loc6_);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,FlxG.keys.handleKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.OBF_1c10);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,FlxG.mouse.handleMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP,FlxG.mouse.handleMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_OUT,FlxG.mouse.handleMouseOut);
            stage.addEventListener(MouseEvent.MOUSE_OVER,FlxG.mouse.handleMouseOver);
            stage.addEventListener(Event.DEACTIVATE,this.OBF_1c11);
            stage.addEventListener(Event.ACTIVATE,this.OBF_1c12);
            this._soundTray = new Sprite();
            this._soundTray.visible = false;
            this._soundTray.scaleX = 2;
            this._soundTray.scaleY = 2;
            _loc7_ = new Bitmap(new BitmapData(80,30,true,14868183));
            this._soundTray.x = (this._gameXOffset + FlxG.width / 2) * this._zoom - _loc7_.width / 2 * this._soundTray.scaleX;
            this._soundTray.addChild(_loc7_);
            _loc8_ = new TextField();
            _loc8_.width = _loc7_.width;
            _loc8_.height = _loc7_.height;
            _loc8_.multiline = true;
            _loc8_.wordWrap = true;
            _loc8_.selectable = false;
            _loc8_.embedFonts = true;
            _loc8_.antiAliasType = AntiAliasType.NORMAL;
            _loc8_.gridFitType = GridFitType.PIXEL;
            _loc8_.defaultTextFormat = new TextFormat("system",8,14868183,null,null,null,null,null,"center");
            this._soundTray.addChild(_loc8_);
            _loc8_.text = "VOLUME";
            _loc8_.y = 16;
            _loc9_ = 10;
            _loc10_ = 14;
            this._soundTrayBars = new Array();
            _loc2_ = 0;
            while(_loc2_ < 10)
            {
               _loc7_ = new Bitmap(new BitmapData(4,_loc2_ + 1,false,14868183));
               _loc7_.x = _loc9_;
               _loc7_.y = _loc10_;
               this._soundTrayBars.push(this._soundTray.addChild(_loc7_));
               _loc9_ += 6;
               _loc10_--;
               _loc2_++;
            }
            addChild(this._soundTray);
            if(this._frame != null)
            {
               _loc11_ = new this._frame();
               _loc11_.scaleX = this._zoom;
               _loc11_.scaleY = this._zoom;
               addChild(_loc11_);
            }
            _loc3_ = new OBF_1e02();
            if(_loc3_.OBF_14("flixel") && _loc3_.data.sound != null)
            {
               if(_loc3_.data.volume != null)
               {
                  FlxG.volume = _loc3_.data.volume;
               }
               if(_loc3_.data.mute != null)
               {
                  FlxG.mute = _loc3_.data.mute;
               }
               this.OBF_1a19(true);
            }
            this._created = true;
            this.OBF_1a0f(new this._iState());
         }
      }
      
      public function OBF_1a19(param1:Boolean = false) : void
      {
         if(!param1)
         {
            FlxG.play(this.SndBeep);
         }
         this._soundTrayTimer = 1;
         this._soundTray.y = this._gameYOffset * this._zoom;
         this._soundTray.visible = true;
         var _loc2_:uint = Math.round(FlxG.volume * 10);
         if(FlxG.mute)
         {
            _loc2_ = 0;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this._soundTrayBars.length)
         {
            if(_loc3_ >= _loc2_)
            {
               this._soundTrayBars[_loc3_].alpha = 0.5;
            }
            else
            {
               this._soundTrayBars[_loc3_].alpha = 1;
            }
            _loc3_++;
         }
      }
      
      private function OBF_1c0e(param1:MouseEvent) : void
      {
      }
      
      protected function OBF_1c11(param1:Event = null) : void
      {
         FlxG.pause = true;
      }
   }
}

