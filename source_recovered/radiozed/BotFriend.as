package
{
   import org.flixel.*;
   
   public class BotFriend extends FlxSprite
   {
      
      protected var _player:Player;
      
      protected var _y:int;
      
      private var _reloadTimeMax:Number;
      
      public var ddy:Number;
      
      private var ImgBot1:Class = Bot_friend_ImgBot1;
      
      private var ImgBot2:Class = Bot_friend_ImgBot2;
      
      public var thisDef:Number;
      
      public var _arm:BotArm;
      
      public var rightDefBoolean:Boolean = false;
      
      private var _reloadTime:Number;
      
      private var _dispersion:Number;
      
      private var dx:Number;
      
      private var param:Params = new Params();
      
      private var _bulletVel:int;
      
      protected var _doorsUp:FlxGroup = new FlxGroup();
      
      private var _holderReload:Boolean;
      
      protected var _height:int;
      
      protected var _doorsDown:FlxGroup = new FlxGroup();
      
      public var rightDef:Number = 666;
      
      public var leftDefBoolean:Boolean = false;
      
      public var _zombies:FlxGroup;
      
      public var _bulletNumberMax:Number;
      
      private var SndAk:Class = Bot_friend_SndAk;
      
      public var _bulletNumber:Number;
      
      private var SndSvg:Class = Bot_friend_SndSvg;
      
      public var shiftX2:Number;
      
      public var shiftX1:Number;
      
      private var _curBullet:uint;
      
      private var _number:Number;
      
      private var _attackDelay:Number;
      
      private var _attackDelayMax:Number;
      
      public var _bulletDamage:Number;
      
      private var ImgGibs:Class = Bot_friend_ImgGibs;
      
      private var _bullets:Array;
      
      public var shiftY1:Number;
      
      public var leftDef:Number = 393;
      
      public var ddx:Number;
      
      public function BotFriend(param1:Number, param2:Number, param3:Player, param4:Array, param5:BotArm, param6:Number = 0, param7:Number = 393, param8:Number = 666)
      {
         this.thisDef = this.leftDef;
         this.leftDef = param7;
         this.rightDef = param8;
         this._player = param3;
         this._arm = param5;
         this._number = param6;
         super(param1,param2);
         health = 100;
         if(param6 == 1)
         {
            loadGraphic(this.ImgBot1,true,true,17,32);
            this.shiftX1 = -22;
            this.shiftX2 = -23;
            this.shiftY1 = -11;
            this._holderReload = false;
            this._reloadTime = 5;
            this._reloadTimeMax = 5;
            this._bulletNumber = 30;
            this._bulletNumberMax = 30;
            this._attackDelay = 0.2;
            this._attackDelayMax = 0.2;
            this._bulletDamage = this.param.bot1_damage;
            this._dispersion = this.param.bot1_accuracy;
            maxVelocity.x = this.param.bot1_speed;
         }
         else if(param6 == 2)
         {
            loadGraphic(this.ImgBot2,true,true,17,32);
            this.shiftX1 = -27;
            this.shiftX2 = -28;
            this.shiftY1 = -14;
            this._holderReload = false;
            this._reloadTime = 5;
            this._reloadTimeMax = 5;
            this._bulletNumber = 6;
            this._bulletNumberMax = 6;
            this._attackDelay = 1;
            this._attackDelayMax = 1;
            this._bulletDamage = this.param.bot2_damage;
            this._dispersion = this.param.bot2_accuracy;
            maxVelocity.x = this.param.bot2_speed;
         }
         collideRight = false;
         collideLeft = false;
         collideTop = false;
         acceleration.y = 400;
         drag.x = 1000;
         fixed = false;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
         addAnimation("idle",[0],0);
         this._bullets = param4;
         this._curBullet = 0;
         this._bulletVel = 1100;
      }
      
      override public function hurt(param1:Number) : void
      {
         super.hurt(param1);
      }
      
      public function shoot(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this._holderReload == true && this._attackDelay <= 0)
         {
            this._arm.ddx = param1;
            this._arm.ddy = param2;
            this._attackDelay = this._attackDelayMax;
            --this._bulletNumber;
            if(this._bulletNumber <= 0)
            {
               this._holderReload = false;
               this._reloadTime = this._reloadTimeMax;
            }
            _loc3_ = this._dispersion;
            _loc3_ = Math.random() * _loc3_;
            _loc4_ = Math.random() * 1;
            if(_loc4_ > 0.5)
            {
               _loc3_ = -_loc3_;
            }
            this._bullets[this._curBullet].visibleTimer = 0.001;
            this._bullets[this._curBullet].visible = false;
            this._arm.play("pew",true);
            if(this._number != 1)
            {
               if(this._number == 2)
               {
                  FlxG.play(this.SndSvg,0.5);
               }
            }
            else
            {
               FlxG.play(this.SndAk,0.5);
            }
            _loc5_ = 2;
            this._bullets[this._curBullet].shoot(x,y,param1,param2,this._bulletVel,_loc3_,this._bulletDamage,_loc5_);
            if(++this._curBullet >= this._bullets.length)
            {
               this._curBullet = 0;
            }
         }
      }
      
      override public function update() : void
      {
         this.dx = Math.sqrt(Math.pow(x - this.thisDef,2));
         acceleration.x = 0;
         if(this.x < this.thisDef && this.dx > 5)
         {
            acceleration.x += drag.x;
            facing = RIGHT;
            this.ddx = this.x + 100;
            this.ddy = this.y + 5;
         }
         else if(this.x > this.thisDef && this.dx > 5)
         {
            acceleration.x -= drag.x;
            facing = LEFT;
            this.ddx = this.x - 100;
            this.ddy = this.y + 5;
         }
         if(acceleration.x > 0)
         {
            this.ddx = this.x + 100;
            this.ddy = this.y + 5;
            this._arm.ddx = this.ddx;
            this._arm.ddy = this.ddy;
         }
         else if(acceleration.x < 0)
         {
            this.ddx = this.x - 100;
            this.ddy = this.y + 5;
            this._arm.ddx = this.ddx;
            this._arm.ddy = this.ddy;
         }
         if(velocity.x <= 0)
         {
            if(velocity.x < 0)
            {
               play("walk");
            }
            else
            {
               play("idle");
            }
         }
         else
         {
            play("walk");
         }
         if(!(this._reloadTime > 0 && this._holderReload == false))
         {
            if(this._reloadTime < 0 && this._holderReload == false)
            {
               this._holderReload = true;
               this._bulletNumber = this._bulletNumberMax;
            }
         }
         else
         {
            this._reloadTime -= FlxG.elapsed;
         }
         if(this._attackDelay > 0)
         {
            this._attackDelay -= FlxG.elapsed;
         }
         super.update();
         if(facing == LEFT)
         {
            this._arm.x = this.x + this.shiftX1;
         }
         else
         {
            this._arm.x = this.x + this.shiftX2;
         }
         this._arm.y = this.y + this.shiftY1;
      }
      
      override public function kill() : void
      {
         if(dead)
         {
            return;
         }
         this._arm.kill();
      }
   }
}

