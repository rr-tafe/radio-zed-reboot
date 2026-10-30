package org.flixel
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class FlxTilemap extends FlxObject
   {
      
      public static var ImgAuto:Class = FlxTilemap_ImgAuto;
      
      public static var ImgAutoAlt:Class = FlxTilemap_ImgAutoAlt;
      
      public static const OFF:uint = 0;
      
      public static const AUTO:uint = 1;
      
      public static const ALT:uint = 2;
      
      protected var _tileWidth:uint;
      
      protected var _screenRows:uint;
      
      protected var _data:Array;
      
      public var startingIndex:uint;
      
      protected var _pixels:BitmapData;
      
      protected var _block:FlxObject;
      
      protected var _callbacks:Array;
      
      protected var _rects:Array;
      
      protected var _tileHeight:uint;
      
      public var totalTiles:uint;
      
      protected var _screenCols:uint;
      
      public var drawIndex:uint;
      
      public var auto:uint;
      
      protected var _flashRect:Rectangle;
      
      public var heightInTiles:uint;
      
      public var widthInTiles:uint;
      
      public var collideIndex:uint;
      
      public function FlxTilemap()
      {
         super();
         this.auto = OFF;
         this.collideIndex = 1;
         this.startingIndex = 0;
         this.drawIndex = 1;
         this.widthInTiles = 0;
         this.heightInTiles = 0;
         this.totalTiles = 0;
         this._data = new Array();
         this._tileWidth = 0;
         this._tileHeight = 0;
         this._rects = null;
         this._pixels = null;
         this._block = new FlxObject();
         var _temp_1:* = this._block;
         this._block.height = 0;
         _temp_1.width = 0;
         this._block.fixed = true;
         this._callbacks = new Array();
         fixed = true;
      }
      
      public static function OBF_17(param1:Array, param2:int) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:int = param1.length / param2;
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = 0;
            while(_loc4_ < param2)
            {
               if(_loc4_ == 0)
               {
                  if(_loc3_ == 0)
                  {
                     _loc5_ += param1[0];
                  }
                  else
                  {
                     _loc5_ += "\n" + param1[_loc3_ * param2];
                  }
               }
               else
               {
                  _loc5_ += ", " + param1[_loc3_ * param2 + _loc4_];
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      public static function pngToCSV(param1:Class, param2:Boolean = false, param3:uint = 1) : String
      {
         var _loc4_:Bitmap = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc12_:Bitmap = null;
         var _loc13_:Matrix = null;
         if(param3 <= 1)
         {
            _loc4_ = new param1();
         }
         else
         {
            _loc12_ = new param1();
            _loc4_ = new Bitmap(new BitmapData(_loc12_.width * param3,_loc12_.height * param3));
            _loc13_ = new Matrix();
            _loc13_.scale(param3,param3);
            _loc4_.bitmapData.draw(_loc12_,_loc13_);
         }
         var _loc5_:BitmapData = _loc4_.bitmapData;
         var _loc10_:uint = _loc4_.width;
         var _loc11_:uint = _loc4_.height;
         _loc6_ = 0;
         while(_loc6_ < _loc11_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc10_)
            {
               _loc8_ = _loc5_.getPixel(_loc7_,_loc6_);
               if(param2 && _loc8_ > 0 || !param2 && _loc8_ == 0)
               {
                  _loc8_ = 1;
               }
               else
               {
                  _loc8_ = 0;
               }
               if(_loc7_ == 0)
               {
                  if(_loc6_ == 0)
                  {
                     _loc9_ += _loc8_;
                  }
                  else
                  {
                     _loc9_ += "\n" + _loc8_;
                  }
               }
               else
               {
                  _loc9_ += ", " + _loc8_;
               }
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc9_;
      }
      
      public function OBF_1a1c(param1:uint, param2:uint, param3:Boolean = true) : Boolean
      {
         var _loc5_:uint = 0;
         if(param1 >= this._data.length)
         {
            return false;
         }
         this._data[param1] = param2;
         if(param3)
         {
            if(this.auto == OFF)
            {
               this.OBF_1a04(param1);
               return true;
            }
            var _loc6_:int = int(param1 / this.widthInTiles) - 1;
            var _loc7_:int = _loc6_ + 3;
            var _loc8_:int = param1 % this.widthInTiles - 1;
            var _loc9_:int = _loc8_ + 3;
            _loc6_ = _loc6_;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc9_ - 3;
               while(_loc8_ < _loc9_)
               {
                  if(_loc6_ >= 0 && _loc6_ < this.heightInTiles && _loc8_ >= 0 && _loc8_ < this.widthInTiles)
                  {
                     _loc5_ = _loc6_ * this.widthInTiles + _loc8_;
                     this.OBF_16(_loc5_);
                     this.OBF_1a04(_loc5_);
                  }
                  _loc8_++;
               }
               _loc6_++;
            }
            return true;
         }
         return true;
      }
      
      public function OBF_1d13(param1:uint, param2:uint) : uint
      {
         return this.OBF_1d12(param2 * this.widthInTiles + param1);
      }
      
      public function OBF_1b03(param1:uint, param2:Function, param3:uint = 1) : void
      {
         if(param3 <= 0)
         {
            return;
         }
         var _loc4_:uint = param1;
         while(_loc4_ < param1 + param3)
         {
            this._callbacks[_loc4_] = param2;
            _loc4_++;
         }
      }
      
      override public function overlaps(param1:FlxObject) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Array = new Array();
         var _loc7_:uint = Math.floor((param1.x - x) / this._tileWidth);
         var _loc8_:uint = Math.floor((param1.y - y) / this._tileHeight);
         var _loc9_:uint = Math.ceil(param1.width / this._tileWidth) + 1;
         var _loc10_:uint = Math.ceil(param1.height / this._tileHeight) + 1;
         var _loc11_:uint = 0;
         while(_loc11_ < _loc10_)
         {
            if(_loc11_ >= this.heightInTiles)
            {
               break;
            }
            _loc3_ = (_loc8_ + _loc11_) * this.widthInTiles + _loc7_;
            _loc2_ = 0;
            while(_loc2_ < _loc9_)
            {
               if(_loc2_ >= this.widthInTiles)
               {
                  break;
               }
               _loc5_ = this._data[_loc3_ + _loc2_] as uint;
               if(_loc5_ >= this.collideIndex)
               {
                  _loc6_.push({
                     "x":x + (_loc7_ + _loc2_) * this._tileWidth,
                     "y":y + (_loc8_ + _loc11_) * this._tileHeight,
                     "data":_loc5_
                  });
               }
               _loc2_++;
            }
            _loc11_++;
         }
         var _loc12_:uint = _loc6_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc12_)
         {
            this._block.x = _loc6_[_loc4_].x;
            this._block.y = _loc6_[_loc4_].y;
            if(this._block.overlaps(param1))
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function loadMap(param1:String, param2:Class, param3:uint = 0, param4:uint = 0) : FlxTilemap
      {
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc9_:uint = 0;
         var _loc7_:Array = param1.split("\n");
         this.heightInTiles = _loc7_.length;
         var _loc8_:uint = 0;
         while(_loc8_ < this.heightInTiles)
         {
            _loc6_ = _loc7_[_loc8_].split(",");
            if(_loc6_.length <= 1)
            {
               --this.heightInTiles;
            }
            else
            {
               if(this.widthInTiles == 0)
               {
                  this.widthInTiles = _loc6_.length;
               }
               _loc5_ = 0;
               while(_loc5_ < this.widthInTiles)
               {
                  this._data.push(uint(_loc6_[_loc5_]));
                  _loc5_++;
               }
            }
            _loc8_++;
         }
         this.totalTiles = this.widthInTiles * this.heightInTiles;
         if(this.auto > OFF)
         {
            this.collideIndex = this.startingIndex = this.drawIndex = 1;
            _loc9_ = 0;
            while(_loc9_ < this.totalTiles)
            {
               this.OBF_16(_loc9_);
               _loc9_++;
            }
         }
         this._pixels = FlxG.addBitmap(param2);
         this._tileWidth = param3;
         if(this._tileWidth == 0)
         {
            this._tileWidth = this._pixels.height;
         }
         this._tileHeight = param4;
         if(this._tileHeight == 0)
         {
            this._tileHeight = this._tileWidth;
         }
         this._block.width = this._tileWidth;
         this._block.height = this._tileHeight;
         width = this.widthInTiles * this._tileWidth;
         height = this.heightInTiles * this._tileHeight;
         this._rects = new Array(this.totalTiles);
         _loc9_ = 0;
         while(_loc9_ < this.totalTiles)
         {
            this.OBF_1a04(_loc9_);
            _loc9_++;
         }
         this._screenRows = Math.ceil(FlxG.height / this._tileHeight) + 1;
         if(this._screenRows > this.heightInTiles)
         {
            this._screenRows = this.heightInTiles;
         }
         this._screenCols = Math.ceil(FlxG.width / this._tileWidth) + 1;
         if(this._screenCols > this.widthInTiles)
         {
            this._screenCols = this.widthInTiles;
         }
         this.refreshHulls();
         return this;
      }
      
      public function OBF_1b11(param1:Number, param2:Number, param3:Number, param4:Number, param5:FlxPoint, param6:Number = 1) : Boolean
      {
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc7_:Number = this._tileWidth;
         if(this._tileHeight < this._tileWidth)
         {
            _loc7_ = this._tileHeight;
         }
         _loc7_ /= param6;
         var _loc8_:Number = param3 - param1;
         var _loc9_:Number = param4 - param2;
         var _loc10_:Number = Math.sqrt(_loc8_ * _loc8_ + _loc9_ * _loc9_);
         var _loc11_:uint = Math.ceil(_loc10_ / _loc7_);
         var _loc12_:Number = _loc8_ / _loc11_;
         var _loc13_:Number = _loc9_ / _loc11_;
         var _loc14_:Number = param1 - _loc12_;
         var _loc15_:Number = param2 - _loc13_;
         var _loc18_:uint = 0;
         while(_loc18_ < _loc11_)
         {
            _loc14_ += _loc12_;
            _loc15_ += _loc13_;
            if(!(_loc14_ < 0 || _loc14_ > width || _loc15_ < 0 || _loc15_ > height))
            {
               _loc16_ = _loc14_ / this._tileWidth;
               _loc17_ = _loc15_ / this._tileHeight;
               if(this._data[_loc17_ * this.widthInTiles + _loc16_] as uint >= this.collideIndex)
               {
                  _loc16_ *= this._tileWidth;
                  _loc17_ *= this._tileHeight;
                  _loc19_ = 0;
                  _loc20_ = 0;
                  _loc22_ = _loc14_ - _loc12_;
                  _loc23_ = _loc15_ - _loc13_;
                  _loc21_ = _loc16_;
                  if(_loc8_ < 0)
                  {
                     _loc21_ += this._tileWidth;
                  }
                  _loc19_ = _loc21_;
                  _loc20_ = _loc23_ + _loc13_ * ((_loc21_ - _loc22_) / _loc12_);
                  if(!(_loc20_ > _loc17_ && _loc20_ < _loc17_ + this._tileHeight))
                  {
                     _loc21_ = _loc17_;
                     if(_loc9_ < 0)
                     {
                        _loc21_ += this._tileHeight;
                     }
                     _loc19_ = _loc22_ + _loc12_ * ((_loc21_ - _loc23_) / _loc13_);
                     _loc20_ = _loc21_;
                     if(_loc19_ > _loc16_ && _loc19_ < _loc16_ + this._tileWidth)
                     {
                        if(param5 == null)
                        {
                           param5 = new FlxPoint();
                        }
                        param5.x = _loc19_;
                        param5.y = _loc20_;
                        return true;
                     }
                     return false;
                  }
                  if(param5 == null)
                  {
                     param5 = new FlxPoint();
                  }
                  param5.x = _loc19_;
                  param5.y = _loc20_;
                  return true;
               }
            }
            _loc18_++;
         }
         return false;
      }
      
      override public function preCollide(param1:FlxObject) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         colOffsets.length = 0;
         var _loc4_:int = FlxU.floor((param1.x - x) / this._tileWidth);
         var _loc5_:int = FlxU.floor((param1.y - y) / this._tileHeight);
         var _loc6_:uint = FlxU.ceil(param1.width / this._tileWidth) + 1;
         var _loc7_:uint = FlxU.ceil(param1.height / this._tileHeight) + 1;
         var _loc8_:uint = 0;
         while(_loc8_ < _loc7_)
         {
            if(_loc8_ >= this.heightInTiles)
            {
               break;
            }
            _loc3_ = (_loc5_ + _loc8_) * this.widthInTiles + _loc4_;
            _loc2_ = 0;
            while(_loc2_ < _loc6_)
            {
               if(_loc2_ >= this.widthInTiles)
               {
                  break;
               }
               if(this._data[_loc3_ + _loc2_] as uint >= this.collideIndex)
               {
                  colOffsets.push(new FlxPoint(x + (_loc4_ + _loc2_) * this._tileWidth,y + (_loc5_ + _loc8_) * this._tileHeight));
               }
               _loc2_++;
            }
            _loc8_++;
         }
      }
      
      override public function render() : void
      {
         this.OBF_1b0a();
      }
      
      protected function OBF_1a04(param1:uint) : void
      {
         if(this._data[param1] < this.drawIndex)
         {
            this._rects[param1] = null;
            return;
         }
         var _loc2_:uint = (this._data[param1] - this.startingIndex) * this._tileWidth;
         var _loc3_:uint = 0;
         if(_loc2_ >= this._pixels.width)
         {
            _loc3_ = uint(_loc2_ / this._pixels.width) * this._tileHeight;
            _loc2_ %= this._pixels.width;
         }
         this._rects[param1] = new Rectangle(_loc2_,_loc3_,this._tileWidth,this._tileHeight);
      }
      
      override public function refreshHulls() : void
      {
         colHullX.x = 0;
         colHullX.y = 0;
         colHullX.width = this._tileWidth;
         colHullX.height = this._tileHeight;
         colHullY.x = 0;
         colHullY.y = 0;
         colHullY.width = this._tileWidth;
         colHullY.height = this._tileHeight;
      }
      
      public function OBF_1a1d(param1:uint, param2:uint, param3:uint, param4:Boolean = true) : Boolean
      {
         if(!(param1 >= this.widthInTiles || param2 >= this.heightInTiles))
         {
            return this.OBF_1a1c(param2 * this.widthInTiles + param1,param3,param4);
         }
         return false;
      }
      
      public function follow(param1:int = 0) : void
      {
         FlxG.followBounds(x + param1 * this._tileWidth,y + param1 * this._tileHeight,width - param1 * this._tileWidth,height - param1 * this._tileHeight);
      }
      
      protected function OBF_1b0a() : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         getScreenXY(_point);
         _flashPoint.x = _point.x;
         _flashPoint.y = _point.y;
         var _loc1_:int = Math.floor(-_flashPoint.x / this._tileWidth);
         var _loc2_:int = Math.floor(-_flashPoint.y / this._tileHeight);
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         if(_loc1_ > this.widthInTiles - this._screenCols)
         {
            _loc1_ = this.widthInTiles - this._screenCols;
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this.heightInTiles - this._screenRows)
         {
            _loc2_ = this.heightInTiles - this._screenRows;
         }
         var _loc3_:int = _loc2_ * this.widthInTiles + _loc1_;
         _flashPoint.x += _loc1_ * this._tileWidth;
         _flashPoint.y += _loc2_ * this._tileHeight;
         var _loc4_:int = _flashPoint.x;
         var _loc7_:uint = 0;
         while(_loc7_ < this._screenRows)
         {
            _loc6_ = uint(_loc3_);
            _loc5_ = 0;
            while(_loc5_ < this._screenCols)
            {
               this._flashRect = this._rects[_loc6_++] as Rectangle;
               if(this._flashRect != null)
               {
                  FlxG.buffer.copyPixels(this._pixels,this._flashRect,_flashPoint,null,null,true);
               }
               _flashPoint.x += this._tileWidth;
               _loc5_++;
            }
            _loc3_ += this.widthInTiles;
            _flashPoint.x = _loc4_;
            _flashPoint.y += this._tileHeight;
            _loc7_++;
         }
      }
      
      protected function OBF_16(param1:uint) : void
      {
         if(this._data[param1] == 0)
         {
            return;
         }
         this._data[param1] = 0;
         if(param1 - this.widthInTiles < 0 || this._data[param1 - this.widthInTiles] > 0)
         {
            this._data[param1] += 1;
         }
         if(param1 % this.widthInTiles >= this.widthInTiles - 1 || this._data[param1 + 1] > 0)
         {
            this._data[param1] += 2;
         }
         if(param1 + this.widthInTiles >= this.totalTiles || this._data[param1 + this.widthInTiles] > 0)
         {
            this._data[param1] += 4;
         }
         if(param1 % this.widthInTiles <= 0 || this._data[param1 - 1] > 0)
         {
            this._data[param1] += 8;
         }
         if(this.auto == ALT && this._data[param1] == 15)
         {
            if(param1 % this.widthInTiles > 0 && param1 + this.widthInTiles < this.totalTiles && this._data[param1 + this.widthInTiles - 1] <= 0)
            {
               this._data[param1] = 1;
            }
            if(param1 % this.widthInTiles > 0 && param1 - this.widthInTiles >= 0 && this._data[param1 - this.widthInTiles - 1] <= 0)
            {
               this._data[param1] = 2;
            }
            if(param1 % this.widthInTiles < this.widthInTiles && param1 - this.widthInTiles >= 0 && this._data[param1 - this.widthInTiles + 1] <= 0)
            {
               this._data[param1] = 4;
            }
            if(param1 % this.widthInTiles < this.widthInTiles && param1 + this.widthInTiles < this.totalTiles && this._data[param1 + this.widthInTiles + 1] <= 0)
            {
               this._data[param1] = 8;
            }
         }
         this._data[param1] += 1;
      }
      
      public function OBF_1d12(param1:uint) : uint
      {
         return this._data[param1] as uint;
      }
   }
}

