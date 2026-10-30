package org.flixel
{
   import org.flixel.data.OBF_1e13;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FlxSprite extends FlxObject
   {
      
      public static const LEFT:uint = 0;
      
      public static const RIGHT:uint = 1;
      
      public static const UP:uint = 2;
      
      public static const DOWN:uint = 3;
      
      protected var _mtx:Matrix;
      
      protected var _caf:uint;
      
      public var finished:Boolean;
      
      protected var _animations:Array;
      
      protected var _ct:ColorTransform;
      
      public var offset:FlxPoint;
      
      protected var _callback:Function;
      
      protected var _curAnim:OBF_1e13;
      
      protected var _framePixels:BitmapData;
      
      protected var _flipped:uint;
      
      public var scale:FlxPoint;
      
      protected var _pixels:BitmapData;
      
      protected var _bakedRotation:Number;
      
      public var blend:String;
      
      public var frameWidth:uint;
      
      protected var _flashRect2:Rectangle;
      
      protected var _alpha:Number;
      
      protected var _flashPointZero:Point;
      
      protected var _curFrame:uint;
      
      public var frameHeight:uint;
      
      protected var _flashRect:Rectangle;
      
      protected var _frameTimer:Number;
      
      protected var _facing:uint;
      
      public var antialiasing:Boolean;
      
      protected var _color:uint;
      
      public function FlxSprite(param1:Number = 0, param2:Number = 0, param3:Class = null)
      {
         super();
         x = param1;
         y = param2;
         this._flashRect = new Rectangle();
         this._flashRect2 = new Rectangle();
         this._flashPointZero = new Point();
         if(param3 != null)
         {
            this.loadGraphic(param3);
         }
         else
         {
            this.createGraphic(8,8);
         }
         this.offset = new FlxPoint();
         this.scale = new FlxPoint(1,1);
         this._alpha = 1;
         this._color = 16777215;
         this.blend = null;
         this.antialiasing = false;
         this.finished = false;
         this._facing = RIGHT;
         this._animations = new Array();
         this._flipped = 0;
         this._curAnim = null;
         this._curFrame = 0;
         this._caf = 0;
         this._frameTimer = 0;
         this._mtx = new Matrix();
         this._callback = null;
      }
      
      protected function OBF_1b0b() : void
      {
         this.getScreenXY(_point);
         _flashPoint.x = _point.x;
         _flashPoint.y = _point.y;
         if((angle == 0 || this._bakedRotation > 0) && this.scale.x == 1 && this.scale.y == 1 && this.blend == null)
         {
            FlxG.buffer.copyPixels(this._framePixels,this._flashRect,_flashPoint,null,null,true);
            return;
         }
         this._mtx.identity();
         this._mtx.translate(-origin.x,-origin.y);
         this._mtx.scale(this.scale.x,this.scale.y);
         if(angle != 0)
         {
            this._mtx.rotate(Math.PI * 2 * (angle / 360));
         }
         this._mtx.translate(_point.x + origin.x,_point.y + origin.y);
         FlxG.buffer.draw(this._framePixels,this._mtx,null,this.blend,null,this.antialiasing);
      }
      
      public function OBF_1e14(param1:uint) : void
      {
         this._pixels.fillRect(this._flashRect2,param1);
         this.calcFrame();
      }
      
      public function addAnimation(param1:String, param2:Array, param3:Number = 0, param4:Boolean = true) : void
      {
         this._animations.push(new OBF_1e13(param1,param2,param3,param4));
      }
      
      override public function overlapsPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean
      {
         param1 -= FlxU.floor(FlxG.scroll.x);
         param2 -= FlxU.floor(FlxG.scroll.y);
         this.getScreenXY(_point);
         if(!param3)
         {
            if(param1 <= _point.x || param1 >= _point.x + this.frameWidth || param2 <= _point.y || param2 >= _point.y + this.frameHeight)
            {
               return false;
            }
            return true;
         }
         return this._framePixels.hitTest(new Point(0,0),255,new Point(param1 - _point.x,param2 - _point.y));
      }
      
      override public function render() : void
      {
         this.OBF_1b0b();
      }
      
      protected function calcFrame() : void
      {
         var _loc1_:uint = this._caf * this.frameWidth;
         var _loc2_:uint = 0;
         var _loc3_:uint = !this._flipped ? uint(this._pixels.width) : this._flipped;
         if(_loc1_ >= _loc3_)
         {
            _loc2_ = uint(_loc1_ / _loc3_) * this.frameHeight;
            _loc1_ %= _loc3_;
         }
         if(Boolean(this._flipped) && this._facing == LEFT)
         {
            _loc1_ = (this._flipped << 1) - _loc1_ - this.frameWidth;
         }
         this._flashRect.x = _loc1_;
         this._flashRect.y = _loc2_;
         this._framePixels.copyPixels(this._pixels,this._flashRect,this._flashPointZero);
         var _temp_2:* = this._flashRect;
         this._flashRect.y = 0;
         _temp_2.x = 0;
         if(this._ct != null)
         {
            this._framePixels.colorTransform(this._flashRect,this._ct);
         }
         if(this._callback != null)
         {
            this._callback(this._curAnim.name,this._curFrame,this._caf);
         }
      }
      
      internal function unsafeBind(param1:BitmapData) : void
      {
         this._pixels = this._framePixels = param1;
      }
      
      public function loadGraphic(param1:Class, param2:Boolean = false, param3:Boolean = false, param4:uint = 0, param5:uint = 0, param6:Boolean = false) : FlxSprite
      {
         this._bakedRotation = 0;
         this._pixels = FlxG.addBitmap(param1,param3,param6);
         if(param3)
         {
            this._flipped = this._pixels.width >> 1;
         }
         else
         {
            this._flipped = 0;
         }
         if(param4 == 0)
         {
            if(param2)
            {
               param4 = uint(this._pixels.height);
            }
            else if(this._flipped <= 0)
            {
               param4 = uint(this._pixels.width);
            }
            else
            {
               param4 = this._pixels.width / 2;
            }
         }
         width = this.frameWidth = param4;
         if(param5 == 0)
         {
            if(param2)
            {
               param5 = width;
            }
            else
            {
               param5 = uint(this._pixels.height);
            }
         }
         height = this.frameHeight = param5;
         this.OBF_1b08();
         return this;
      }
      
      public function get OBF_1b1d() : BitmapData
      {
         return this._pixels;
      }
      
      public function set facing(param1:uint) : void
      {
         var _loc2_:Boolean = this._facing != param1;
         this._facing = param1;
         if(_loc2_)
         {
            this.calcFrame();
         }
      }
      
      protected function OBF_1b08() : void
      {
         this._flashRect.x = 0;
         this._flashRect.y = 0;
         this._flashRect.width = this.frameWidth;
         this._flashRect.height = this.frameHeight;
         this._flashRect2.x = 0;
         this._flashRect2.y = 0;
         this._flashRect2.width = this._pixels.width;
         this._flashRect2.height = this._pixels.height;
         if(this._framePixels == null || this._framePixels.width != width || this._framePixels.height != height)
         {
            this._framePixels = new BitmapData(width,height);
         }
         origin.x = this.frameWidth / 2;
         origin.y = this.frameHeight / 2;
         this._framePixels.copyPixels(this._pixels,this._flashRect,this._flashPointZero);
         this._caf = 0;
         refreshHulls();
      }
      
      override public function getScreenXY(param1:FlxPoint = null) : FlxPoint
      {
         if(param1 == null)
         {
            param1 = new FlxPoint();
         }
         param1.x = FlxU.floor(x + FlxU.roundingError) + FlxU.floor(FlxG.scroll.x * scrollFactor.x) - this.offset.x;
         param1.y = FlxU.floor(y + FlxU.roundingError) + FlxU.floor(FlxG.scroll.y * scrollFactor.y) - this.offset.y;
         return param1;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 == this._alpha)
         {
            return;
         }
         this._alpha = param1;
         if(!(this._alpha != 1 || this._color != 16777215))
         {
            this._ct = null;
         }
         else
         {
            this._ct = new ColorTransform(Number(this._color >> 16) / 255,Number(this._color >> 8 & 0xFF) / 255,Number(this._color & 0xFF) / 255,this._alpha);
         }
         this.calcFrame();
      }
      
      protected function OBF_1a09() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         if(this._bakedRotation)
         {
            _loc1_ = this._caf;
            _loc2_ = angle % 360;
            if(_loc2_ < 0)
            {
               _loc2_ += 360;
            }
            this._caf = _loc2_ / this._bakedRotation;
            if(_loc1_ != this._caf)
            {
               this.calcFrame();
            }
            return;
         }
         if(this._curAnim != null && this._curAnim.delay > 0 && (this._curAnim.looped || !this.finished))
         {
            this._frameTimer += FlxG.elapsed;
            if(this._frameTimer > this._curAnim.delay)
            {
               this._frameTimer -= this._curAnim.delay;
               if(this._curFrame == this._curAnim.frames.length - 1)
               {
                  if(this._curAnim.looped)
                  {
                     this._curFrame = 0;
                  }
                  this.finished = true;
               }
               else
               {
                  ++this._curFrame;
               }
               this._caf = this._curAnim.frames[this._curFrame];
               this.calcFrame();
            }
         }
      }
      
      public function draw(param1:FlxSprite, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:BitmapData = param1._framePixels;
         if((param1.angle == 0 || param1._bakedRotation > 0) && param1.scale.x == 1 && param1.scale.y == 1 && param1.blend == null)
         {
            _flashPoint.x = param2;
            _flashPoint.y = param3;
            this._flashRect2.width = _loc4_.width;
            this._flashRect2.height = _loc4_.height;
            this._pixels.copyPixels(_loc4_,this._flashRect2,_flashPoint,null,null,true);
            this._flashRect2.width = this._pixels.width;
            this._flashRect2.height = this._pixels.height;
            this.calcFrame();
            return;
         }
         this._mtx.identity();
         this._mtx.translate(-param1.origin.x,-param1.origin.y);
         this._mtx.scale(param1.scale.x,param1.scale.y);
         if(param1.angle != 0)
         {
            this._mtx.rotate(Math.PI * 2 * (param1.angle / 360));
         }
         this._mtx.translate(param2 + param1.origin.x,param3 + param1.origin.y);
         this._pixels.draw(_loc4_,this._mtx,null,param1.blend,null,param1.antialiasing);
         this.calcFrame();
      }
      
      public function loadRotatedGraphic(param1:Class, param2:uint = 16, param3:int = -1, param4:Boolean = false, param5:Boolean = false) : FlxSprite
      {
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc7_:FlxSprite = new FlxSprite().loadGraphic(param1,param3 >= 0);
         if(param3 >= 0)
         {
            _loc7_.frame = param3;
         }
         _loc7_.antialiasing = param4;
         var _loc8_:uint = _loc7_.width;
         if(_loc7_.height > _loc8_)
         {
            _loc8_ = _loc7_.height;
         }
         if(param5)
         {
            _loc8_ *= 1.5;
         }
         var _loc9_:uint = Math.ceil(param2 / 4);
         width = _loc8_ * _loc9_;
         height = _loc8_ * 4;
         var _loc10_:String = String(param1) + ":" + param3 + ":" + width + "x" + height;
         var _loc11_:Boolean = FlxG.checkBitmapCache(_loc10_);
         this.createGraphic(width,height,0,true,_loc10_);
         this._bakedRotation = 360 / param2;
         if(!_loc11_)
         {
            _loc14_ = _loc7_.width / 2;
            _loc15_ = _loc7_.height / 2;
            _loc16_ = _loc8_ / 2;
            _loc17_ = _loc8_ / 2;
            _loc12_ = 0;
            while(_loc12_ < 4)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc9_)
               {
                  this.draw(_loc7_,_loc16_ + _loc8_ * _loc13_ - _loc14_,_loc17_ - _loc15_);
                  _loc7_.angle += this._bakedRotation;
                  _loc13_++;
               }
               _loc17_ += _loc8_;
               _loc12_++;
            }
         }
         this.frameWidth = this.frameHeight = width = height = _loc8_;
         this.OBF_1b08();
         return this;
      }
      
      public function set color(param1:uint) : void
      {
         param1 &= 16777215;
         if(this._color == param1)
         {
            return;
         }
         this._color = param1;
         if(this._alpha != 1 || this._color != 16777215)
         {
            this._ct = new ColorTransform(Number(this._color >> 16) / 255,Number(this._color >> 8 & 0xFF) / 255,Number(this._color & 0xFF) / 255,this._alpha);
         }
         else
         {
            this._ct = null;
         }
         this.calcFrame();
      }
      
      override public function update() : void
      {
         OBF_1a06();
         this.OBF_1a09();
         OBF_1a07();
      }
      
      public function onEmit() : void
      {
      }
      
      public function createGraphic(param1:uint, param2:uint, param3:uint = 4294967295, param4:Boolean = false, param5:String = null) : FlxSprite
      {
         this._bakedRotation = 0;
         this._pixels = FlxG.createBitmap(param1,param2,param3,param4,param5);
         width = this.frameWidth = this._pixels.width;
         height = this.frameHeight = this._pixels.height;
         this.OBF_1b08();
         return this;
      }
      
      public function play(param1:String, param2:Boolean = false) : void
      {
         if(!param2 && this._curAnim != null && param1 == this._curAnim.name)
         {
            return;
         }
         this._curFrame = 0;
         this._caf = 0;
         this._frameTimer = 0;
         var _loc3_:uint = this._animations.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._animations[_loc4_].name == param1)
            {
               this._curAnim = this._animations[_loc4_];
               if(this._curAnim.delay <= 0)
               {
                  this.finished = true;
               }
               else
               {
                  this.finished = false;
               }
               this._caf = this._curAnim.frames[this._curFrame];
               this.calcFrame();
               return;
            }
            _loc4_++;
         }
      }
      
      public function OBF_1d(param1:Function) : void
      {
         this._callback = param1;
      }
      
      public function set OBF_1b1d(param1:BitmapData) : void
      {
         this._pixels = param1;
         width = this.frameWidth = this._pixels.width;
         height = this.frameHeight = this._pixels.height;
         this.OBF_1b08();
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function get facing() : uint
      {
         return this._facing;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set frame(param1:uint) : void
      {
         this._curAnim = null;
         this._caf = param1;
         this.calcFrame();
      }
      
      public function get frame() : uint
      {
         return this._caf;
      }
      
      public function OBF_1b13() : void
      {
         this._curAnim = null;
         this._caf = int(FlxU.random() * (this._pixels.width / this.frameWidth));
         this.calcFrame();
      }
   }
}

