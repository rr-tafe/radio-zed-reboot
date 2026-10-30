package
{
   import org.flixel.*;
   import flash.events.*;
   import flash.net.SharedObject;
   
   public class Player extends FlxSprite
   {
      
      private var _down:Boolean;
      
      private var Snd4_6:Class = Player_Snd4_6;
      
      public var allBullet:Number = 0;
      
      private var weaponGui:Class = Player_weaponGui;
      
      private var _doorUp:DoorUp;
      
      private var weaponNumber:Number = 0;
      
      private var Snd6:Class = Player_Snd6;
      
      private var weapon_bullets:Array = [15,8,40,35,30,30,30,8,100];
      
      private var _pos:Number;
      
      private var SndAk47:Class = Player_SndAk47;
      
      private var healthBar:FlxText;
      
      private var _weaponGui:FlxSprite;
      
      public var _shiftX1:Number;
      
      private var _pistol:PlayerArm;
      
      private var yy:Number;
      
      public var _shiftX2:Number;
      
      private var _reloadTime:Number;
      
      private var deadFix:Boolean = false;
      
      private var Snd357:Class = Player_Snd357;
      
      private var param:Params = new Params();
      
      private var Snd9mm:Class = Player_Snd9mm;
      
      private var _up:Boolean;
      
      private var _bulletVel:int;
      
      private var posMark:Boolean = true;
      
      public var _shiftY1:Number;
      
      private var _holderReload:Boolean;
      
      private var SndM16:Class = Player_SndM16;
      
      public var _bulletNumber:Number;
      
      public var _bulletNumberMax:Number;
      
      private var SndSvg:Class = Player_SndSvg;
      
      private var _attackDelay:Number;
      
      private var _curBullet:uint;
      
      protected var shared:SharedObject = SharedObject.getLocal("reloaded");
      
      public var maxHealth:Number;
      
      private var _attackDelayMax:Number;
      
      private var Snd5_7mm:Class = Player_Snd5_7mm;
      
      public var _bulletDamage:Number;
      
      private var _bullets:Array;
      
      private var ImgPlayer:Class = Player_ImgPlayer;
      
      private var SndMGun:Class = Player_SndMGun;
      
      private var _reloadTimeMax:Number;
      
      public function Player(param1:Number, param2:Number, param3:Array, param4:PlayerArm, param5:Boolean = false)
      {
         this._pistol = param4;
         this.posMark = param5;
         super(param1,param2);
         loadGraphic(this.ImgPlayer,true,true,17,32);
         maxVelocity.x = this.param.player_speed;
         acceleration.y = 400;
         drag.x = maxVelocity.x * 4;
         width = 14;
         height = 32;
         offset.x = 0;
         offset.y = 0;
         this.maxHealth = this.param.player_health;
         health = this.param.player_health;
         addAnimation("idle",[this._pos],0,false);
         addAnimation("idle2",[0],0,false);
         addAnimation("walk",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,15,16,17,18,19,20,22,25,26],maxVelocity.x / 3);
         addAnimation("flail",[29],5,false);
         addAnimation("jump",[27,28,29],5,false);
         addAnimation("dead",[30]);
         this._bullets = param3;
         this._curBullet = 0;
         this._bulletVel = 1100;
         this._bulletDamage = 1;
         if(this.shared.data.playerWeapons[0][1] == 2)
         {
            this._pistol.weapon_glock(1);
         }
         else
         {
            this._pistol.weapon_glock(0);
         }
         this._weaponGui = new FlxSprite(1,20);
         this._weaponGui.loadGraphic(this.weaponGui,false,false,45,15);
         var _temp_1:* = this._weaponGui.scrollFactor;
         this._weaponGui.scrollFactor.y = 0;
         _temp_1.x = 0;
         FlxG.state.add(this._weaponGui);
         FlxG.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.OBF_191b,false,0,true);
         this.OBF_191c();
      }
      
      override public function hurt(param1:Number) : void
      {
         super.hurt(param1);
      }
      
      private function OBF_191d() : void
      {
         if(this.shared.data.playerWeapons[this.weaponNumber][0] == 2)
         {
            this.OBF_1a0e();
         }
         else
         {
            --this.weaponNumber;
            this.OBF_191d();
         }
      }
      
      private function OBF_191c() : void
      {
         this._holderReload = this._pistol.holderReload;
         this._reloadTime = this._pistol.reloadTime * this.param.player_recharge;
         this._reloadTimeMax = this._pistol.reloadTimeMax * this.param.player_recharge;
         this._bulletNumber = this.weapon_bullets[this.weaponNumber];
         this._bulletNumberMax = this._pistol.bulletNumberMax;
         this._attackDelay = this._pistol.attackDelay;
         this._attackDelayMax = this._pistol.attackDelayMax;
         this._bulletDamage = this._pistol.bulletDamage * this.param.player_damage;
         this._shiftX1 = this._pistol.shiftX1;
         this._shiftX2 = this._pistol.shiftX2;
         this._shiftY1 = this._pistol.shiftY1;
         if(this.weapon_bullets[this.weaponNumber] <= 0)
         {
            this._holderReload = false;
            this._reloadTime = this._reloadTimeMax;
         }
      }
      
      private function OBF_1a01() : void
      {
         if(this.shared.data.playerWeapons[this.weaponNumber][0] == 2)
         {
            this.OBF_1a0e();
         }
         else if(this.weaponNumber != 8)
         {
            this.weaponNumber += 1;
            this.OBF_1a01();
         }
         else
         {
            this.weaponNumber = 0;
            this.OBF_1a01();
         }
      }
      
      private function OBF_1a0e() : void
      {
         if(this.weaponNumber == 0)
         {
            if(this.shared.data.playerWeapons[0][1] != 2)
            {
               this._pistol.weapon_glock(0);
            }
            else
            {
               this._pistol.weapon_glock(1);
            }
            this._weaponGui.frame = 0;
         }
         else if(this.weaponNumber == 1)
         {
            if(this.shared.data.playerWeapons[1][1] != 2)
            {
               this._pistol.weapon_eagle(0);
            }
            else
            {
               this._pistol.weapon_eagle(1);
            }
            this._weaponGui.frame = 1;
         }
         else if(this.weaponNumber == 2)
         {
            if(this.shared.data.playerWeapons[2][1] != 2)
            {
               this._pistol.weapon_uzi(0);
            }
            else
            {
               this._pistol.weapon_uzi(1);
            }
            this._weaponGui.frame = 2;
         }
         else if(this.weaponNumber != 3)
         {
            if(this.weaponNumber != 4)
            {
               if(this.weaponNumber != 5)
               {
                  if(this.weaponNumber != 6)
                  {
                     if(this.weaponNumber == 7)
                     {
                        if(this.shared.data.playerWeapons[7][1] != 2)
                        {
                           this._pistol.weapon_ssg(0);
                        }
                        else
                        {
                           this._pistol.weapon_ssg(1);
                        }
                        this._weaponGui.frame = 7;
                     }
                     else if(this.weaponNumber == 8)
                     {
                        if(this.shared.data.playerWeapons[8][1] != 2)
                        {
                           this._pistol.weapon_m249(0);
                        }
                        else
                        {
                           this._pistol.weapon_m249(1);
                        }
                        this._weaponGui.frame = 8;
                     }
                  }
                  else
                  {
                     if(this.shared.data.playerWeapons[6][1] == 2)
                     {
                        this._pistol.weapon_m16(1);
                     }
                     else
                     {
                        this._pistol.weapon_m16(0);
                     }
                     this._weaponGui.frame = 6;
                  }
               }
               else
               {
                  if(this.shared.data.playerWeapons[5][1] == 2)
                  {
                     this._pistol.weapon_akm(1);
                  }
                  else
                  {
                     this._pistol.weapon_akm(0);
                  }
                  this._weaponGui.frame = 5;
               }
            }
            else
            {
               if(this.shared.data.playerWeapons[4][1] == 2)
               {
                  this._pistol.weapon_steyr(1);
               }
               else
               {
                  this._pistol.weapon_steyr(0);
               }
               this._weaponGui.frame = 4;
            }
         }
         else
         {
            if(this.shared.data.playerWeapons[3][1] == 2)
            {
               this._pistol.weapon_G36(1);
            }
            else
            {
               this._pistol.weapon_G36(0);
            }
            this._weaponGui.frame = 3;
         }
         this.OBF_191c();
      }
      
      override public function kill() : void
      {
         if(dead)
         {
            return;
         }
         health = 0;
         FlxG.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.OBF_191b,false);
         this._pistol.kill();
         dead = true;
         acceleration.x = 0;
         if(facing == LEFT)
         {
            angle = 90;
            offset.y = -15;
         }
         else
         {
            angle = 270;
            offset.y = -15;
         }
         play("dead");
         y -= 15;
      }
      
      override public function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(dead == true && this.deadFix == false && this.y >= this.yy)
         {
            this.deadFix = true;
            this.acceleration.y = 0;
            acceleration.y = 0;
            maxVelocity.y = 0;
            this.solid = true;
            this.fixed = true;
            this.y = this.yy;
         }
         if(dead == false)
         {
            if(this.posMark == true)
            {
               this.posMark = false;
               facing = LEFT;
            }
            else
            {
               acceleration.x = 0;
               if((FlxG.keys.A || FlxG.keys.LEFT) && this.x > 170)
               {
                  facing = LEFT;
                  acceleration.x -= drag.x;
               }
               else if((FlxG.keys.D || FlxG.keys.RIGHT) && this.x < 900)
               {
                  facing = RIGHT;
                  acceleration.x += drag.x;
               }
               if(onFloor)
               {
                  this.yy = y;
                  if(FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("W") || FlxG.keys.justPressed("SPACE"))
                  {
                     velocity.y = -acceleration.y * 0.31;
                     play("jump");
                  }
                  else if(velocity.x <= 0)
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
               }
               else if(velocity.y >= 0)
               {
                  play("flail");
               }
               else
               {
                  play("jump");
               }
               if(FlxG.mouse.x >= this.x + 3)
               {
                  facing = RIGHT;
               }
               else
               {
                  facing = LEFT;
               }
            }
            if(this._reloadTime > 0 && this._holderReload == false)
            {
               this._reloadTime -= FlxG.elapsed;
            }
            else if(this._reloadTime < 0 && this._holderReload == false)
            {
               this._holderReload = true;
               this._bulletNumber = this._bulletNumberMax;
               this.weapon_bullets[this.weaponNumber] = this._bulletNumber;
            }
            if(this._attackDelay > 0)
            {
               this._attackDelay -= FlxG.elapsed;
            }
            if(FlxG.mouse.pressed() && this._holderReload == true && this._attackDelay <= 0 && this.weaponNumber != 0 && this.weaponNumber != 1 && this._pistol.dist > 5 || FlxG.mouse.justPressed() && this._holderReload == true && this._attackDelay <= 0 && this._pistol.dist > 5)
            {
               this._attackDelay = this._attackDelayMax;
               --this._bulletNumber;
               this.weapon_bullets[this.weaponNumber] = this.weapon_bullets[this.weaponNumber] - 1;
               if(this._bulletNumber <= 0)
               {
                  this._holderReload = false;
                  this._reloadTime = this._reloadTimeMax;
               }
               _loc1_ = this.param.player_accuracy;
               _loc1_ = Math.random() * _loc1_;
               _loc2_ = Math.random() * 1;
               if(_loc2_ > 0.5)
               {
                  _loc1_ = -_loc1_;
               }
               _loc3_ = 1;
               FlxG.quake.start(0.005,0.1);
               this._bullets[this._curBullet].visibleTimer = 0.00001;
               this._bullets[this._curBullet].visible = false;
               this._pistol.play("pew",true);
               if(this.weaponNumber == 0)
               {
                  FlxG.play(this.Snd9mm);
                  this.shared.data.bulletShot[0] += 1;
               }
               else if(this.weaponNumber == 1)
               {
                  FlxG.play(this.Snd5_7mm,0.5);
                  this.shared.data.bulletShot[1] += 1;
               }
               else if(this.weaponNumber == 2)
               {
                  FlxG.play(this.Snd6);
                  this.shared.data.bulletShot[2] += 1;
               }
               else if(this.weaponNumber == 3)
               {
                  FlxG.play(this.SndM16);
                  this.shared.data.bulletShot[3] += 1;
               }
               else if(this.weaponNumber == 4)
               {
                  FlxG.play(this.Snd4_6);
                  this.shared.data.bulletShot[4] += 1;
               }
               else if(this.weaponNumber == 5)
               {
                  FlxG.play(this.Snd357);
                  this.shared.data.bulletShot[5] += 1;
               }
               else if(this.weaponNumber == 6)
               {
                  FlxG.play(this.SndM16);
                  this.shared.data.bulletShot[6] += 1;
               }
               else if(this.weaponNumber == 7)
               {
                  FlxG.play(this.SndSvg);
                  this.shared.data.bulletShot[7] += 1;
               }
               else if(this.weaponNumber == 8)
               {
                  FlxG.play(this.SndMGun);
                  this.shared.data.bulletShot[8] += 1;
               }
               this._bullets[this._curBullet].shoot(x,y,FlxG.mouse.x,FlxG.mouse.y,this._bulletVel,_loc1_,this._bulletDamage,_loc3_);
               this.allBullet += 1;
               if(++this._curBullet >= this._bullets.length)
               {
                  this._curBullet = 0;
               }
            }
            if(FlxG.keys.justPressed("R") && this._holderReload == true)
            {
               this._bulletNumber = 0;
               this._holderReload = false;
               this._reloadTime = this._reloadTimeMax;
            }
            if(FlxG.keys.justPressed("ONE"))
            {
               if(this.shared.data.playerWeapons[0][1] == 2)
               {
                  this._pistol.weapon_glock(1);
               }
               else
               {
                  this._pistol.weapon_glock(0);
               }
               this._weaponGui.frame = 0;
               this.weaponNumber = 0;
               this.OBF_191c();
            }
            else if(FlxG.keys.justPressed("TWO") && this.shared.data.playerWeapons[1][0] == 2)
            {
               if(this.shared.data.playerWeapons[1][1] == 2)
               {
                  this._pistol.weapon_eagle(1);
               }
               else
               {
                  this._pistol.weapon_eagle(0);
               }
               this._weaponGui.frame = 1;
               this.weaponNumber = 1;
               this.OBF_191c();
            }
            else if(!(FlxG.keys.justPressed("THREE") && this.shared.data.playerWeapons[2][0] == 2))
            {
               if(!(FlxG.keys.justPressed("FOUR") && this.shared.data.playerWeapons[3][0] == 2))
               {
                  if(FlxG.keys.justPressed("FIVE") && this.shared.data.playerWeapons[4][0] == 2)
                  {
                     if(this.shared.data.playerWeapons[4][1] != 2)
                     {
                        this._pistol.weapon_steyr(0);
                     }
                     else
                     {
                        this._pistol.weapon_steyr(1);
                     }
                     this._weaponGui.frame = 4;
                     this.weaponNumber = 4;
                     this.OBF_191c();
                  }
                  else if(FlxG.keys.justPressed("SIX") && this.shared.data.playerWeapons[5][0] == 2)
                  {
                     if(this.shared.data.playerWeapons[5][1] != 2)
                     {
                        this._pistol.weapon_akm(0);
                     }
                     else
                     {
                        this._pistol.weapon_akm(1);
                     }
                     this._weaponGui.frame = 5;
                     this.weaponNumber = 5;
                     this.OBF_191c();
                  }
                  else if(FlxG.keys.justPressed("SEVEN") && this.shared.data.playerWeapons[6][0] == 2)
                  {
                     if(this.shared.data.playerWeapons[6][1] != 2)
                     {
                        this._pistol.weapon_m16(0);
                     }
                     else
                     {
                        this._pistol.weapon_m16(1);
                     }
                     this._weaponGui.frame = 6;
                     this.weaponNumber = 6;
                     this.OBF_191c();
                  }
                  else if(FlxG.keys.justPressed("EIGHT") && this.shared.data.playerWeapons[7][0] == 2)
                  {
                     if(this.shared.data.playerWeapons[7][1] != 2)
                     {
                        this._pistol.weapon_ssg(0);
                     }
                     else
                     {
                        this._pistol.weapon_ssg(1);
                     }
                     this._weaponGui.frame = 7;
                     this.weaponNumber = 7;
                     this.OBF_191c();
                  }
                  else if(!(FlxG.keys.justPressed("NINE") && this.shared.data.playerWeapons[8][0] == 2))
                  {
                     if(!FlxG.keys.justPressed("Q"))
                     {
                        if(FlxG.keys.justPressed("E"))
                        {
                           if(this.weaponNumber != 8)
                           {
                              this.weaponNumber += 1;
                           }
                           else
                           {
                              this.weaponNumber = 0;
                           }
                           this.OBF_1a01();
                        }
                     }
                     else
                     {
                        if(this.weaponNumber != 0)
                        {
                           --this.weaponNumber;
                        }
                        else
                        {
                           this.weaponNumber = 8;
                        }
                        this.OBF_191d();
                     }
                  }
                  else
                  {
                     if(this.shared.data.playerWeapons[8][1] == 2)
                     {
                        this._pistol.weapon_m249(1);
                     }
                     else
                     {
                        this._pistol.weapon_m249(0);
                     }
                     this._weaponGui.frame = 8;
                     this.weaponNumber = 8;
                     this.OBF_191c();
                  }
               }
               else
               {
                  if(this.shared.data.playerWeapons[3][1] == 2)
                  {
                     this._pistol.weapon_G36(1);
                  }
                  else
                  {
                     this._pistol.weapon_G36(0);
                  }
                  this._weaponGui.frame = 3;
                  this.weaponNumber = 3;
                  this.OBF_191c();
               }
            }
            else
            {
               if(this.shared.data.playerWeapons[2][1] == 2)
               {
                  this._pistol.weapon_uzi(1);
               }
               else
               {
                  this._pistol.weapon_uzi(0);
               }
               this._weaponGui.frame = 2;
               this.weaponNumber = 2;
               this.OBF_191c();
            }
         }
         super.update();
         if(facing != LEFT)
         {
            this._pistol.x = this.x + this._shiftX2;
         }
         else
         {
            this._pistol.x = this.x + this._shiftX1;
         }
         this._pistol.y = this.y + this._shiftY1;
         if(this._pistol.facing != LEFT)
         {
            facing = RIGHT;
         }
         else
         {
            facing = LEFT;
         }
      }
      
      private function OBF_191b(param1:MouseEvent) : void
      {
         if(param1.delta < 0)
         {
            if(this.weaponNumber != 0)
            {
               --this.weaponNumber;
            }
            else
            {
               this.weaponNumber = 8;
            }
            this.OBF_191d();
         }
         else
         {
            if(this.weaponNumber != 8)
            {
               this.weaponNumber += 1;
            }
            else
            {
               this.weaponNumber = 0;
            }
            this.OBF_1a01();
         }
      }
   }
}

