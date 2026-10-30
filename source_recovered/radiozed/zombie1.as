package
{
   import org.flixel.*;
   import flash.net.SharedObject;
   
   public class zombie1 extends FlxSprite
   {
      
      protected var _player:Player;
      
      private var deadFix:Boolean = false;
      
      private var yy:Number;
      
      private var _zombie:zombie1;
      
      protected var _height:int;
      
      protected var _doorsDown:FlxGroup = new FlxGroup();
      
      private var timer:Number = 1;
      
      private var attack:Boolean = true;
      
      private var deadTime:Number = 60;
      
      private var shared:SharedObject = SharedObject.getLocal("reloaded");
      
      private var ImgZombie00:Class = zombie1_ImgZombie00;
      
      private var ImgZombie01:Class = zombie1_ImgZombie01;
      
      private var ImgZombie02:Class = zombie1_ImgZombie02;
      
      private var ImgZombie03:Class = zombie1_ImgZombie03;
      
      private var ImgZombie04:Class = zombie1_ImgZombie04;
      
      private var ImgZombie05:Class = zombie1_ImgZombie05;
      
      private var ImgZombie06:Class = zombie1_ImgZombie06;
      
      private var ImgZombie07:Class = zombie1_ImgZombie07;
      
      private var ImgZombie08:Class = zombie1_ImgZombie08;
      
      private var ImgZombie09:Class = zombie1_ImgZombie09;
      
      private var floorNumber:Number = 0;
      
      private var ImgZombie10:Class = zombie1_ImgZombie10;
      
      private var ImgZombie11:Class = zombie1_ImgZombie11;
      
      private var ImgZombie12:Class = zombie1_ImgZombie12;
      
      private var ImgZombie13:Class = zombie1_ImgZombie13;
      
      private var ImgZombie14:Class = zombie1_ImgZombie14;
      
      private var ImgZombie15:Class = zombie1_ImgZombie15;
      
      private var ImgZombie16:Class = zombie1_ImgZombie16;
      
      private var ImgZombie17:Class = zombie1_ImgZombie17;
      
      protected var _gibs:FlxEmitter;
      
      private var param:Params = new Params();
      
      private var SndDie1:Class = zombie1_SndDie1;
      
      private var SndDie2:Class = zombie1_SndDie2;
      
      private var SndDie3:Class = zombie1_SndDie3;
      
      private var dx:Number;
      
      private var zombieDead:Boolean = false;
      
      private var SndGrow1:Class = zombie1_SndGrow1;
      
      private var SndGrow2:Class = zombie1_SndGrow2;
      
      private var SndGrow3:Class = zombie1_SndGrow3;
      
      protected var _doorsUp:FlxGroup = new FlxGroup();
      
      private var _targets:FlxGroup = new FlxGroup();
      
      private var targetX:Number;
      
      private var attack2:Boolean = false;
      
      private var ImgGibs:Class = zombie1_ImgGibs;
      
      protected var _y:int;
      
      private var _radio:Radio;
      
      public function zombie1(param1:Number, param2:Number, param3:FlxEmitter, param4:Player, param5:Radio, param6:FlxGroup, param7:FlxGroup, param8:FlxGroup)
      {
         this._radio = param5;
         this._targets = param8;
         this._doorsUp = param7;
         this._doorsDown = param6;
         this._gibs = param3;
         super(param1,param2);
         this._player = param4;
         var _loc9_:int = Math.random() * 18;
         if(_loc9_ != 0)
         {
            if(_loc9_ == 1)
            {
               this.OBF_1917();
            }
            else if(_loc9_ == 2)
            {
               this.OBF_1916();
            }
            else if(_loc9_ != 3)
            {
               if(_loc9_ == 4)
               {
                  this.OBF_1914();
               }
               else if(_loc9_ == 5)
               {
                  this.OBF_1913();
               }
               else if(_loc9_ == 6)
               {
                  this.OBF_1912();
               }
               else if(_loc9_ == 7)
               {
                  this.OBF_1911();
               }
               else if(_loc9_ != 8)
               {
                  if(_loc9_ == 9)
                  {
                     this.OBF_190f();
                  }
                  else if(_loc9_ == 10)
                  {
                     this.OBF_190e();
                  }
                  else if(_loc9_ == 11)
                  {
                     this.OBF_190d();
                  }
                  else if(_loc9_ != 12)
                  {
                     if(_loc9_ == 13)
                     {
                        this.OBF_190b();
                     }
                     else if(_loc9_ == 14)
                     {
                        this.OBF_190a();
                     }
                     else if(_loc9_ == 15)
                     {
                        this.OBF_1909();
                     }
                     else if(_loc9_ != 16)
                     {
                        if(_loc9_ == 17)
                        {
                           this.OBF_1907();
                        }
                     }
                     else
                     {
                        this.OBF_1908();
                     }
                  }
                  else
                  {
                     this.OBF_190c();
                  }
               }
               else
               {
                  this.OBF_1910();
               }
            }
            else
            {
               this.OBF_1915();
            }
         }
         else
         {
            this.OBF_1918();
         }
         addAnimation("attack",[24,25,26,27],5);
         addAnimation("stop",[28]);
         var _loc10_:int = Math.random() * 50;
         if(_loc10_ == 1)
         {
            FlxG.play(this.SndGrow1,1);
         }
         else if(_loc10_ == 2)
         {
            FlxG.play(this.SndGrow2,1);
         }
         else if(_loc10_ == 3)
         {
            FlxG.play(this.SndGrow3,0.5);
         }
      }
      
      override public function hurt(param1:Number) : void
      {
         this._gibs.at(this);
         this._gibs.quantity = 3;
         this._gibs.start(true,1,3);
         super.hurt(param1);
      }
      
      override public function kill() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SharedObject = null;
         var _loc3_:int = 0;
         if(this.zombieDead == false)
         {
            if(dead)
            {
               return;
            }
            _loc1_ = Math.random() * 20;
            if(_loc1_ == 1)
            {
               FlxG.play(this.SndDie1,1);
            }
            else if(_loc1_ != 2)
            {
               if(_loc1_ == 3)
               {
                  FlxG.play(this.SndDie3,0.5);
               }
            }
            else
            {
               FlxG.play(this.SndDie2,1);
            }
            this.zombieDead = true;
            this._gibs.at(this);
            this._gibs.quantity = 50;
            this._gibs.start(true,4,50);
            _loc2_ = SharedObject.getLocal("reloaded");
            facing = LEFT;
            acceleration.x = 0;
            angle = 90;
            _loc3_ = Math.random() * 2;
            if(_loc3_ != 0)
            {
               facing = RIGHT;
               angle = 270;
               offset.y = -14;
            }
            else
            {
               facing = LEFT;
               offset.y = -15;
            }
            this.yy = y;
            play("stop");
            y -= 11;
            solid = false;
         }
      }
      
      private function OBF_1918() : void
      {
         loadGraphic(this.ImgZombie00,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1917() : void
      {
         loadGraphic(this.ImgZombie01,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1916() : void
      {
         loadGraphic(this.ImgZombie02,true,true,17,32);
         var _loc1_:Array = [20,25,27,30,37,40];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1915() : void
      {
         loadGraphic(this.ImgZombie03,true,true,17,32);
         var _loc1_:Array = [20,25,27,30,37,40];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1914() : void
      {
         loadGraphic(this.ImgZombie04,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1913() : void
      {
         loadGraphic(this.ImgZombie05,true,true,17,32);
         var _loc1_:Array = [20,25,27,30,37,40];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1912() : void
      {
         loadGraphic(this.ImgZombie06,true,true,17,32);
         var _loc1_:Array = [20,25,27,30,37,40];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1911() : void
      {
         loadGraphic(this.ImgZombie07,true,true,17,32);
         var _loc1_:Array = [20,25,27,30,37,40];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1910() : void
      {
         loadGraphic(this.ImgZombie08,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_190f() : void
      {
         loadGraphic(this.ImgZombie09,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_190e() : void
      {
         loadGraphic(this.ImgZombie10,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_190d() : void
      {
         loadGraphic(this.ImgZombie11,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_190c() : void
      {
         loadGraphic(this.ImgZombie12,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_190b() : void
      {
         loadGraphic(this.ImgZombie13,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_190a() : void
      {
         loadGraphic(this.ImgZombie14,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1908() : void
      {
         loadGraphic(this.ImgZombie16,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      private function OBF_1907() : void
      {
         loadGraphic(this.ImgZombie17,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
      
      override public function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.zombieDead == false)
         {
            if(this.timer > 0 && this.attack == false)
            {
               this.timer -= FlxG.elapsed;
            }
            else
            {
               this.attack = true;
            }
            _loc1_ = Math.sqrt(Math.pow(this._player.x - this.x,2) + Math.pow(this._player.y - this.y,2));
            if(_loc1_ < 50)
            {
               this.targetX = this._player.x;
            }
            else if(this._radio.y <= this.y - 50)
            {
               if(this._radio.y < this.y)
               {
                  _loc2_ = 0;
                  while(_loc2_ < this._doorsUp.members.length)
                  {
                     if(this._doorsUp.members[_loc2_].y == this.y)
                     {
                        this.targetX = this._doorsUp.members[_loc2_].x;
                        if(this.x > this.targetX - 5 && this.x < this.targetX + 5)
                        {
                           this.y -= 80;
                           this.floorNumber += 1;
                        }
                     }
                     _loc2_++;
                  }
               }
            }
            else
            {
               this.targetX = this._radio.x;
            }
            this.dx = x - this.targetX;
            if(this.attack2 == false)
            {
               acceleration.x = 0;
               if(this.dx < 0)
               {
                  acceleration.x += drag.x;
                  facing = RIGHT;
               }
               else if(this.dx > 0)
               {
                  acceleration.x -= drag.x;
                  facing = LEFT;
               }
               if(this.overlaps(this._radio) == true && this._radio.health > 0)
               {
                  if(this._radio.x < this.x)
                  {
                     facing = LEFT;
                  }
                  else
                  {
                     facing = RIGHT;
                  }
                  acceleration.x = 0;
                  velocity.x = 0;
                  if(this.attack == true)
                  {
                     this.attack = false;
                     this.timer = 1;
                     this._radio.hurt(1);
                  }
               }
               else
               {
                  _loc3_ = 0;
                  while(_loc3_ < this._targets.members.length)
                  {
                     if(this.overlaps(this._targets.members[_loc3_]) && this._targets.members[_loc3_].health > 0)
                     {
                        acceleration.x = 0;
                        if(this._targets.members[_loc3_].x > this.x)
                        {
                           facing = RIGHT;
                        }
                        else
                        {
                           facing = LEFT;
                        }
                        if(this.attack == true)
                        {
                           this.attack = false;
                           this.timer = 1;
                           if(this._targets.members[_loc3_] is Player)
                           {
                              this._targets.members[_loc3_].hurt(8);
                              this._gibs.at(this._targets.members[_loc3_]);
                              this._gibs.quantity = 40;
                              this._gibs.start(true,4,40);
                           }
                           else
                           {
                              this._targets.members[_loc3_].hurt(1);
                           }
                        }
                     }
                     _loc3_++;
                  }
               }
            }
            if(onFloor)
            {
               if(velocity.x > 0)
               {
                  play("walk");
               }
               else if(velocity.x < 0)
               {
                  play("walk");
               }
               else
               {
                  play("attack");
               }
            }
         }
         if(!(this.y >= this.yy && this.zombieDead == true && this.deadFix == false))
         {
            if(this.deadFix == true && this.deadTime > 0)
            {
               this.deadTime -= FlxG.elapsed;
               if(this.deadTime < 1 && !flickering())
               {
                  flicker(1);
               }
            }
            else if(this.deadTime <= 0)
            {
               super.kill();
            }
         }
         else
         {
            this.deadFix = true;
            this.acceleration.y = 0;
            acceleration.y = 0;
            maxVelocity.y = 0;
            this.solid = true;
            this.fixed = true;
            this.y = this.yy;
         }
         super.update();
      }
      
      private function OBF_1909() : void
      {
         loadGraphic(this.ImgZombie15,true,true,17,32);
         var _loc1_:Array = [10,16,14,17,18,19,20,30];
         var _loc2_:int = Math.random() * _loc1_.length;
         var _loc3_:Number = Number(_loc1_[_loc2_]);
         maxVelocity.x = _loc3_;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         fixed = false;
         health = 100;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],maxVelocity.x / 2);
      }
   }
}

