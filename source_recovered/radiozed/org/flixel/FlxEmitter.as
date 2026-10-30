package org.flixel
{
   public class FlxEmitter extends FlxGroup
   {
      
      public var maxRotation:Number;
      
      public var delay:Number;
      
      public var quantity:uint;
      
      protected var _timer:Number;
      
      public var gravity:Number;
      
      public var particleDrag:FlxPoint;
      
      public var maxParticleSpeed:FlxPoint;
      
      public var on:Boolean;
      
      protected var _explode:Boolean;
      
      protected var _particle:uint;
      
      public var minParticleSpeed:FlxPoint;
      
      public var minRotation:Number;
      
      protected var _counter:uint;
      
      public function FlxEmitter(param1:Number = 0, param2:Number = 0)
      {
         super();
         x = param1;
         y = param2;
         width = 0;
         height = 0;
         this.minParticleSpeed = new FlxPoint(-100,-100);
         this.maxParticleSpeed = new FlxPoint(100,100);
         this.minRotation = -360;
         this.maxRotation = 360;
         this.gravity = 400;
         this.particleDrag = new FlxPoint();
         this.delay = 0.1;
         this.quantity = 0;
         this._counter = 0;
         this._explode = true;
         exists = false;
         this.on = false;
      }
      
      public function OBF_1b02(param1:Number = 0, param2:Number = 0) : void
      {
         this.minRotation = param1;
         this.maxRotation = param2;
      }
      
      override public function update() : void
      {
         super.update();
         this.OBF_1a08();
      }
      
      public function setYSpeed(param1:Number = 0, param2:Number = 0) : void
      {
         this.minParticleSpeed.y = param1;
         this.maxParticleSpeed.y = param2;
      }
      
      public function stop(param1:Number = 3) : void
      {
         this._explode = true;
         this.delay = param1;
         if(this.delay < 0)
         {
            this.delay = -param1;
         }
         this.on = false;
      }
      
      public function OBF_1b01(param1:uint, param2:uint) : void
      {
         width = param1;
         height = param2;
      }
      
      public function at(param1:FlxObject) : void
      {
         x = param1.x + param1.origin.x;
         y = param1.y + param1.origin.y;
      }
      
      override protected function updateMembers() : void
      {
         var _loc1_:FlxObject = null;
         var _loc2_:uint = members.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_] as FlxObject;
            if(_loc1_ != null && _loc1_.exists && _loc1_.active)
            {
               _loc1_.update();
            }
            _loc3_++;
         }
      }
      
      public function start(param1:Boolean = true, param2:Number = 0, param3:uint = 0) : void
      {
         if(members.length <= 0)
         {
            FlxG.log("WARNING: there are no sprites loaded in your emitter.\nAdd some to FlxEmitter.members or use FlxEmitter.createSprites().");
            return;
         }
         this._explode = param1;
         if(!this._explode)
         {
            this._counter = 0;
         }
         if(!exists)
         {
            this._particle = 0;
         }
         exists = true;
         visible = true;
         active = true;
         dead = false;
         this.on = true;
         this._timer = 0;
         if(this.quantity == 0)
         {
            this.quantity = param3;
         }
         if(param2 != 0)
         {
            this.delay = param2;
         }
         if(this.delay < 0)
         {
            this.delay = -this.delay;
         }
      }
      
      protected function OBF_1a08() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this._explode)
         {
            this._timer += FlxG.elapsed;
            if(this.delay > 0 && this._timer > this.delay)
            {
               this.kill();
               return;
            }
            if(this.on)
            {
               this.on = false;
               _loc2_ = members.length;
               if(this.quantity > 0)
               {
                  _loc2_ = this.quantity;
               }
               _loc2_ += this._particle;
               _loc1_ = this._particle;
               while(_loc1_ < _loc2_)
               {
                  this.OBF_1e1c();
                  _loc1_++;
               }
            }
            return;
         }
         if(!this.on)
         {
            return;
         }
         this._timer += FlxG.elapsed;
         while(this._timer > this.delay && (this.quantity <= 0 || this._counter < this.quantity))
         {
            this._timer -= this.delay;
            this.OBF_1e1c();
         }
      }
      
      override public function kill() : void
      {
         super.kill();
         this.on = false;
      }
      
      public function setXSpeed(param1:Number = 0, param2:Number = 0) : void
      {
         this.minParticleSpeed.x = param1;
         this.maxParticleSpeed.x = param2;
      }
      
      public function createSprites(param1:Class, param2:uint = 50, param3:uint = 16, param4:Boolean = true, param5:Number = 0) : FlxEmitter
      {
         var _loc6_:uint = 0;
         var _loc7_:FlxSprite = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         members = new Array();
         var _loc8_:uint = 1;
         if(param4)
         {
            _loc7_ = new FlxSprite(0,0,param1);
            _loc8_ = _loc7_.width / _loc7_.height;
         }
         var _loc11_:uint = 0;
         while(_loc11_ < param2)
         {
            _loc7_ = new FlxSprite();
            if(!param4)
            {
               if(param3 > 0)
               {
                  _loc7_.loadRotatedGraphic(param1,param3);
               }
               else
               {
                  _loc7_.loadGraphic(param1);
               }
            }
            else
            {
               _loc6_ = FlxU.random() * _loc8_;
               if(param3 > 0)
               {
                  _loc7_.loadRotatedGraphic(param1,param3,_loc6_);
               }
               else
               {
                  _loc7_.loadGraphic(param1,true);
                  _loc7_.frame = _loc6_;
               }
            }
            if(param5 > 0)
            {
               _loc9_ = _loc7_.width;
               _loc10_ = _loc7_.height;
               _loc7_.width *= param5;
               _loc7_.height *= param5;
               _loc7_.offset.x = (_loc9_ - _loc7_.width) / 2;
               _loc7_.offset.y = (_loc10_ - _loc7_.height) / 2;
               _loc7_.solid = true;
            }
            else
            {
               _loc7_.solid = false;
            }
            _loc7_.exists = false;
            _loc7_.scrollFactor = scrollFactor;
            add(_loc7_);
            _loc11_++;
         }
         return this;
      }
      
      public function OBF_1e1c() : void
      {
         ++this._counter;
         var _loc1_:FlxSprite = members[this._particle] as FlxSprite;
         _loc1_.visible = true;
         _loc1_.exists = true;
         _loc1_.active = true;
         _loc1_.x = x - (_loc1_.width >> 1) + FlxU.random() * width;
         _loc1_.y = y - (_loc1_.height >> 1) + FlxU.random() * height;
         _loc1_.velocity.x = this.minParticleSpeed.x;
         if(this.minParticleSpeed.x != this.maxParticleSpeed.x)
         {
            _loc1_.velocity.x += FlxU.random() * (this.maxParticleSpeed.x - this.minParticleSpeed.x);
         }
         _loc1_.velocity.y = this.minParticleSpeed.y;
         if(this.minParticleSpeed.y != this.maxParticleSpeed.y)
         {
            _loc1_.velocity.y += FlxU.random() * (this.maxParticleSpeed.y - this.minParticleSpeed.y);
         }
         _loc1_.acceleration.y = this.gravity;
         _loc1_.angularVelocity = this.minRotation;
         if(this.minRotation != this.maxRotation)
         {
            _loc1_.angularVelocity += FlxU.random() * (this.maxRotation - this.minRotation);
         }
         if(_loc1_.angularVelocity != 0)
         {
            _loc1_.angle = FlxU.random() * 360 - 180;
         }
         _loc1_.drag.x = this.particleDrag.x;
         _loc1_.drag.y = this.particleDrag.y;
         _loc1_.visible = true;
         ++this._particle;
         if(this._particle >= members.length)
         {
            this._particle = 0;
         }
         _loc1_.onEmit();
      }
   }
}

