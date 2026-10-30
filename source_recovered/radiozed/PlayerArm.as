package
{
   import org.flixel.FlxG;
   import org.flixel.FlxSprite;
   import org.flixel.FlxU;
   
   public class PlayerArm extends FlxSprite
   {
      
      private var akm:Class = arm_with_pistol_akm;
      
      private var eagle:Class = arm_with_pistol_eagle;
      
      private var ssg:Class = arm_with_pistol_ssg;
      
      public var reloadTime:Number;
      
      public var bulletDamage:Number;
      
      private var glock:Class = arm_with_pistol_glock;
      
      public var bulletNumber:Number;
      
      public var attackDelay:Number;
      
      public var dist:Number;
      
      private var m249:Class = arm_with_pistol_m249;
      
      private var steyr:Class = arm_with_pistol_steyr;
      
      public var attackDelayMax:Number;
      
      private var m16:Class = arm_with_pistol_m16;
      
      public var shiftX2:Number;
      
      public var shiftX1:Number;
      
      public var holderReload:Boolean;
      
      private var G36:Class = arm_with_pistol_G36;
      
      private var uzi:Class = arm_with_pistol_uzi;
      
      public var bulletNumberMax:Number;
      
      public var shiftY1:Number;
      
      public var reloadTimeMax:Number;
      
      public function PlayerArm(param1:Number, param2:Number)
      {
         super(param1,param2);
         collideRight = false;
         collideLeft = false;
         collideTop = false;
         collideBottom = false;
         solid = false;
         addAnimation("pew",[0,1,0],20,false);
      }
      
      public function weapon_eagle(param1:Number) : void
      {
         this.shiftX1 = -17;
         this.shiftX2 = -16;
         this.shiftY1 = -11;
         loadGraphic(this.eagle,false,true,50,50);
         this.holderReload = true;
         this.reloadTime = 5;
         this.reloadTimeMax = 5;
         this.bulletNumber = 8;
         this.bulletNumberMax = 8;
         if(param1 == 0)
         {
            this.attackDelay = 0;
            this.attackDelayMax = 0;
            this.bulletDamage = 15;
         }
         else
         {
            this.attackDelay = 0;
            this.attackDelayMax = 0;
            this.bulletDamage = 21;
         }
         facing = 1;
      }
      
      public function weapon_glock(param1:Number) : void
      {
         this.shiftX1 = -17;
         this.shiftX2 = -16;
         this.shiftY1 = -11;
         loadGraphic(this.glock,false,true,50,50);
         this.holderReload = true;
         this.reloadTime = 4;
         this.reloadTimeMax = 4;
         this.bulletNumber = 15;
         this.bulletNumberMax = 15;
         if(param1 != 0)
         {
            this.attackDelay = 0;
            this.attackDelayMax = 0;
            this.bulletDamage = 15;
         }
         else
         {
            this.attackDelay = 0;
            this.attackDelayMax = 0;
            this.bulletDamage = 10;
         }
         facing = 1;
      }
      
      public function weapon_m16(param1:Number) : void
      {
         this.shiftX1 = -22;
         this.shiftX2 = -23;
         this.shiftY1 = -11;
         loadGraphic(this.m16,false,true,62,50);
         this.holderReload = true;
         this.reloadTime = 6;
         this.reloadTimeMax = 6;
         this.bulletNumber = 30;
         this.bulletNumberMax = 30;
         if(param1 == 0)
         {
            this.attackDelay = 0.14;
            this.attackDelayMax = 0.14;
            this.bulletDamage = 15;
         }
         else
         {
            this.attackDelay = 0.14;
            this.attackDelayMax = 0.14;
            this.bulletDamage = 18;
         }
         facing = 1;
      }
      
      public function weapon_uzi(param1:Number) : void
      {
         this.shiftX1 = -17;
         this.shiftX2 = -16;
         this.shiftY1 = -11;
         loadGraphic(this.uzi,false,true,50,50);
         this.holderReload = true;
         this.reloadTime = 5;
         this.reloadTimeMax = 5;
         this.bulletNumber = 40;
         this.bulletNumberMax = 40;
         if(param1 == 0)
         {
            this.attackDelay = 0.09;
            this.attackDelayMax = 0.09;
            this.bulletDamage = 6;
         }
         else
         {
            this.attackDelay = 0.09;
            this.attackDelayMax = 0.09;
            this.bulletDamage = 10;
         }
         facing = 1;
      }
      
      public function weapon_G36(param1:Number) : void
      {
         this.shiftX1 = -17;
         this.shiftX2 = -16;
         this.shiftY1 = -11;
         loadGraphic(this.G36,false,true,52,50);
         this.holderReload = true;
         this.reloadTime = 6;
         this.reloadTimeMax = 6;
         this.bulletNumber = 35;
         this.bulletNumberMax = 35;
         if(param1 == 0)
         {
            this.attackDelay = 0.15;
            this.attackDelayMax = 0.15;
            this.bulletDamage = 8;
         }
         else
         {
            this.attackDelay = 0.15;
            this.attackDelayMax = 0.15;
            this.bulletDamage = 12;
         }
         facing = 1;
      }
      
      override public function update() : void
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         var da:Number = NaN;
         var distance:Function = function(param1:Number, param2:Number, param3:Number, param4:Number):Number
         {
            return Math.sqrt(Math.pow(param3 - param1,2) + Math.pow(param4 - param2,2));
         };
         this.dist = distance(FlxG.mouse.x,FlxG.mouse.y,x + 20,y + 20);
         if(this.dist <= 5)
         {
            angle = 0;
         }
         else if(FlxG.mouse.x > x + 19)
         {
            this.facing = RIGHT;
            dx = FlxG.mouse.x - 20 - x;
            dy = FlxG.mouse.y - 20 - y;
            da = FlxU.getAngle(dx,dy);
            angle = da;
         }
         else
         {
            this.facing = LEFT;
            dx = FlxG.mouse.x - 20 - x;
            dy = FlxG.mouse.y - 20 - y;
            da = FlxU.getAngle(dx,dy);
            angle = 180 + da;
         }
         super.update();
      }
      
      public function weapon_steyr(param1:Number) : void
      {
         this.shiftX1 = -22;
         this.shiftX2 = -23;
         this.shiftY1 = -11;
         loadGraphic(this.steyr,false,true,62,50);
         this.holderReload = true;
         this.reloadTime = 4;
         this.reloadTimeMax = 4;
         this.bulletNumber = 30;
         this.bulletNumberMax = 30;
         if(param1 != 0)
         {
            this.attackDelay = 0.15;
            this.attackDelayMax = 0.15;
            this.bulletDamage = 15;
         }
         else
         {
            this.attackDelay = 0.15;
            this.attackDelayMax = 0.15;
            this.bulletDamage = 10;
         }
         facing = 1;
      }
      
      public function weapon_akm(param1:Number) : void
      {
         this.shiftX1 = -22;
         this.shiftX2 = -23;
         this.shiftY1 = -11;
         loadGraphic(this.akm,false,true,62,50);
         this.holderReload = true;
         this.reloadTime = 7;
         this.reloadTimeMax = 7;
         this.bulletNumber = 30;
         this.bulletNumberMax = 30;
         if(param1 != 0)
         {
            this.attackDelay = 0.2;
            this.attackDelayMax = 0.2;
            this.bulletDamage = 16;
         }
         else
         {
            this.attackDelay = 0.2;
            this.attackDelayMax = 0.2;
            this.bulletDamage = 13;
         }
         facing = 1;
      }
      
      public function weapon_ssg(param1:Number) : void
      {
         this.shiftX1 = -27;
         this.shiftX2 = -28;
         this.shiftY1 = -14;
         loadGraphic(this.ssg,false,true,72,57);
         this.holderReload = true;
         this.reloadTime = 5;
         this.reloadTimeMax = 5;
         this.bulletNumber = 6;
         this.bulletNumberMax = 6;
         if(param1 != 0)
         {
            this.attackDelay = 1;
            this.attackDelayMax = 1;
            this.bulletDamage = 100;
         }
         else
         {
            this.attackDelay = 1;
            this.attackDelayMax = 1;
            this.bulletDamage = 70;
         }
         facing = 1;
      }
      
      public function weapon_m249(param1:Number) : void
      {
         this.shiftX1 = -27;
         this.shiftX2 = -28;
         this.shiftY1 = -14;
         loadGraphic(this.m249,false,true,72,57);
         this.holderReload = true;
         this.reloadTime = 16;
         this.reloadTimeMax = 16;
         this.bulletNumber = 100;
         this.bulletNumberMax = 100;
         if(param1 == 0)
         {
            this.attackDelay = 0.08;
            this.attackDelayMax = 0.08;
            this.bulletDamage = 15;
         }
         else
         {
            this.attackDelay = 0.08;
            this.attackDelayMax = 0.08;
            this.bulletDamage = 25;
         }
         facing = 1;
      }
   }
}

