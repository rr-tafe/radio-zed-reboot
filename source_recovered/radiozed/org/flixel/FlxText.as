package org.flixel
{
   import flash.display.BitmapData;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FlxText extends FlxSprite
   {
      
      protected var _tf:TextField;
      
      protected var _regen:Boolean;
      
      protected var _shadow:uint;
      
      public function FlxText(param1:Number, param2:Number, param3:uint, param4:String = null)
      {
         super(param1,param2);
         createGraphic(param3,1);
         if(param4 == null)
         {
            param4 = "";
         }
         this._tf = new TextField();
         this._tf.width = param3;
         this._tf.embedFonts = true;
         this._tf.selectable = false;
         this._tf.sharpness = 100;
         this._tf.multiline = true;
         this._tf.wordWrap = true;
         this._tf.text = param4;
         var _loc5_:TextFormat = new TextFormat("system",8,16777215);
         this._tf.defaultTextFormat = _loc5_;
         this._tf.setTextFormat(_loc5_);
         if(param4.length > 0)
         {
            this._tf.height = 10;
         }
         else
         {
            this._tf.height = 1;
         }
         this._regen = true;
         this._shadow = 0;
         solid = false;
         this.calcFrame();
      }
      
      public function get shadow() : uint
      {
         return this._shadow;
      }
      
      public function get size() : Number
      {
         return this._tf.defaultTextFormat.size as Number;
      }
      
      override public function get color() : uint
      {
         return this._tf.defaultTextFormat.color as uint;
      }
      
      override public function set color(param1:uint) : void
      {
         var _loc2_:TextFormat = this.OBF_1e1d();
         _loc2_.color = param1;
         this._tf.defaultTextFormat = _loc2_;
         this._tf.setTextFormat(_loc2_);
         this._regen = true;
         this.calcFrame();
      }
      
      public function set shadow(param1:uint) : void
      {
         this._shadow = param1;
         this.calcFrame();
      }
      
      public function set size(param1:Number) : void
      {
         var _loc2_:TextFormat = this.OBF_1e1d();
         _loc2_.size = param1;
         this._tf.defaultTextFormat = _loc2_;
         this._tf.setTextFormat(_loc2_);
         this._regen = true;
         this.calcFrame();
      }
      
      public function get alignment() : String
      {
         return this._tf.defaultTextFormat.align;
      }
      
      protected function OBF_1e1d() : TextFormat
      {
         var _loc1_:TextFormat = this._tf.defaultTextFormat;
         return new TextFormat(_loc1_.font,_loc1_.size,_loc1_.color,_loc1_.bold,_loc1_.italic,_loc1_.underline,_loc1_.url,_loc1_.target,_loc1_.align);
      }
      
      public function get text() : String
      {
         return this._tf.text;
      }
      
      public function get font() : String
      {
         return this._tf.defaultTextFormat.font;
      }
      
      public function set alignment(param1:String) : void
      {
         var _loc2_:TextFormat = this.OBF_1e1d();
         _loc2_.align = param1;
         this._tf.defaultTextFormat = _loc2_;
         this._tf.setTextFormat(_loc2_);
         this.calcFrame();
      }
      
      public function set font(param1:String) : void
      {
         var _loc2_:TextFormat = this.OBF_1e1d();
         _loc2_.font = param1;
         this._tf.defaultTextFormat = _loc2_;
         this._tf.setTextFormat(_loc2_);
         this._regen = true;
         this.calcFrame();
      }
      
      override protected function calcFrame() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this._tf == null || this._tf.text == null || this._tf.text.length <= 0)
         {
            _pixels.fillRect(_flashRect,0);
            return;
         }
         if(this._regen)
         {
            _loc3_ = uint(this._tf.numLines);
            height = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               height += this._tf.getLineMetrics(_loc4_).height;
               _loc4_++;
            }
            height += 4;
            _pixels = new BitmapData(width,height,true,0);
            frameHeight = height;
            this._tf.height = height * 1.2;
            _flashRect.x = 0;
            _flashRect.y = 0;
            _flashRect.width = width;
            _flashRect.height = height;
            this._regen = false;
         }
         else
         {
            _pixels.fillRect(_flashRect,0);
         }
         var _loc1_:TextFormat = this._tf.defaultTextFormat;
         var _loc2_:TextFormat = _loc1_;
         _mtx.identity();
         if(_loc1_.align == "center" && this._tf.numLines == 1)
         {
            _loc2_ = new TextFormat(_loc1_.font,_loc1_.size,_loc1_.color,null,null,null,null,null,"left");
            this._tf.setTextFormat(_loc2_);
            _mtx.translate(Math.floor((width - this._tf.getLineMetrics(0).width) / 2),0);
         }
         if(this._shadow > 0)
         {
            this._tf.setTextFormat(new TextFormat(_loc2_.font,_loc2_.size,this._shadow,null,null,null,null,null,_loc2_.align));
            _mtx.translate(1,1);
            _pixels.draw(this._tf,_mtx,_ct);
            _mtx.translate(-1,-1);
            this._tf.setTextFormat(new TextFormat(_loc2_.font,_loc2_.size,_loc2_.color,null,null,null,null,null,_loc2_.align));
         }
         _pixels.draw(this._tf,_mtx,_ct);
         this._tf.setTextFormat(new TextFormat(_loc1_.font,_loc1_.size,_loc1_.color,null,null,null,null,null,_loc1_.align));
         _framePixels = new BitmapData(_pixels.width,_pixels.height,true,0);
         _framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
         if(solid)
         {
            refreshHulls();
         }
      }
      
      public function setFormat(param1:String = null, param2:Number = 8, param3:uint = 16777215, param4:String = null, param5:uint = 0) : FlxText
      {
         if(param1 == null)
         {
            param1 = "";
         }
         var _loc6_:TextFormat = this.OBF_1e1d();
         _loc6_.font = param1;
         _loc6_.size = param2;
         _loc6_.color = param3;
         _loc6_.align = param4;
         this._tf.defaultTextFormat = _loc6_;
         this._tf.setTextFormat(_loc6_);
         this._shadow = param5;
         this._regen = true;
         this.calcFrame();
         return this;
      }
      
      public function set text(param1:String) : void
      {
         this._tf.text = param1;
         this._regen = true;
         this.calcFrame();
      }
   }
}

