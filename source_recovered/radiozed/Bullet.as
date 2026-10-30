package
{
   import org.flixel.*;
   import flash.net.SharedObject;
   
   public class Bullet extends FlxSprite
   {
      
      private var _player:Player;
      
      public var bulletInitial:Number;
      
      private var ImgBullet:Class = Bullet_ImgBullet;
      
      private var speed:Number;
      
      private var targetY:Number;
      
      private var shared:SharedObject;
      
      public var _damage:Number;
      
      private var targetX:Number;
      
      public var visibleTimer:Number = 0.1;
      
      public function Bullet(param1:Player)
      {
         this._player = param1;
         super();
         loadGraphic(this.ImgBullet,false,false,21,1);
         collideRight = false;
         collideLeft = false;
         collideTop = false;
         collideBottom = false;
         var _loc2_:Array = [0.2,0.4,0.5,0.6,0.7,0.8,0.9,1,1,1];
         var _loc3_:int = Math.random() * _loc2_.length;
         alpha = _loc2_[_loc3_];
         visible = false;
      }
      
      override public function hitLeft(param1:FlxObject, param2:Number) : void
      {
         if(param1 != this._player)
         {
            this.kill();
         }
      }
      
      override public function hitTop(param1:FlxObject, param2:Number) : void
      {
         if(param1 != this._player)
         {
            this.kill();
         }
      }
      
      override public function update() : void
      {
         if(this.visibleTimer > 0)
         {
            this.visibleTimer -= FlxG.elapsed;
         }
         else
         {
            visible = true;
         }
         if(this.x < -10 || this.x > 2000 || this.y < -10 || this.y > 600)
         {
            this.kill();
         }
         if(dead && finished)
         {
            exists = false;
         }
         else
         {
            super.update();
         }
      }
      
      override public function kill() : void
      {
         if(dead)
         {
            return;
         }
         velocity.x = 0;
         velocity.y = 0;
         dead = true;
         solid = false;
         super.kill();
      }
      
      override public function hitBottom(param1:FlxObject, param2:Number) : void
      {
         if(param1 != this._player)
         {
            this.kill();
         }
      }
      
      public function shoot(param1:int, param2:int, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc9_:Number = Math.sqrt(Math.pow(param3 - param1,2) + Math.pow(param4 - param2,2));
         if(_loc9_ < 100)
         {
            param6 = 0;
         }
         this.bulletInitial = param8;
         this._damage = param7;
         if(!(param1 < param3 && param2 < param4))
         {
            if(param1 < param3 && param2 > param4)
            {
               param4 += param6;
            }
            else if(param1 > param3 && param2 > param4)
            {
               param4 += param6;
            }
            else
            {
               param4 += param6;
               param3 += param6;
            }
         }
         else
         {
            param4 -= param6;
            param3 += param6;
         }
         param4 -= 10;
         var _loc10_:Number = Math.sqrt(Math.pow(param3 - param1,2) + Math.pow(param4 - param2,2));
         var _loc11_:Number = Math.sqrt(Math.pow(param4 - param2,2));
         var _loc12_:Number = Math.asin(_loc11_ / _loc10_);
         var _loc13_:Number = _loc12_ * 180 / Math.PI;
         if(param3 - param1 > 0)
         {
            if(param4 - param2 >= 0)
            {
               _loc13_ = _loc13_;
            }
            else
            {
               _loc13_ = -_loc13_;
            }
         }
         else if(param4 - param2 < 0)
         {
            _loc13_ = _loc13_;
         }
         else
         {
            _loc13_ = -_loc13_;
         }
         angle = _loc13_;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = param1;
         var _loc17_:int = param2 + 12;
         var _loc18_:int = param1 - param3;
         var _loc19_:int = param2 - param4;
         var _loc20_:int = Math.abs(_loc18_);
         var _loc21_:int = Math.abs(_loc19_);
         var _loc22_:int = Math.floor(_loc20_ / (_loc20_ + _loc21_) * param5);
         var _loc23_:int = Math.floor(_loc21_ / (_loc20_ + _loc21_) * param5);
         if(_loc19_ <= 0)
         {
            _loc15_ = _loc23_;
         }
         else
         {
            _loc15_ = -_loc23_;
         }
         if(_loc18_ > 0)
         {
            _loc14_ = -_loc22_;
         }
         else
         {
            _loc14_ = _loc22_;
         }
         var _loc24_:Number = _loc14_;
         var _loc25_:Number = _loc15_;
         super.reset(param1,param2 + 15);
         solid = true;
         velocity.x = _loc24_;
         velocity.y = _loc25_;
         if(velocity.y < 0)
         {
            play("up");
         }
      }
   }
}

