package
{
   import org.flixel.FlxSprite;
   import org.flixel.FlxU;
   
   public class BotArm extends FlxSprite
   {
      
      private var akm:Class = bot_arm_with_gun_akm;
      
      private var ssg:Class = bot_arm_with_gun_ssg;
      
      public var ddy:Number = 100;
      
      public var attackDelayMax:Number;
      
      public var reloadTime:Number;
      
      public var bulletDamage:Number;
      
      public var shiftX1:Number;
      
      public var shiftX2:Number;
      
      private var _bot_number:Number;
      
      public var holderReload:Boolean;
      
      public var attackDelay:Number;
      
      public var bulletNumber:Number;
      
      public var bulletNumberMax:Number;
      
      public var shiftY1:Number;
      
      public var reloadTimeMax:Number;
      
      public var ddx:Number = 100;
      
      public function BotArm(param1:Number, param2:Number, param3:Number)
      {
         super(param1,param2);
         this._bot_number = param3;
         if(this._bot_number != 1)
         {
            if(this._bot_number == 2)
            {
               this.shiftX1 = -27;
               this.shiftX2 = -28;
               this.shiftY1 = -14;
               loadGraphic(this.ssg,false,true,72,57);
            }
         }
         else
         {
            this.shiftX1 = -22;
            this.shiftX2 = -23;
            this.shiftY1 = -11;
            loadGraphic(this.akm,false,true,62,50);
         }
         collideRight = false;
         collideLeft = false;
         collideTop = false;
         collideBottom = false;
         solid = false;
         addAnimation("pew",[0,1,0],20,false);
      }
      
      override public function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.ddx > x + 15)
         {
            this.facing = RIGHT;
            _loc1_ = this.ddx - 20 - x;
            _loc2_ = this.ddy - 20 - y;
            _loc3_ = FlxU.getAngle(_loc1_,_loc2_);
            angle = _loc3_;
         }
         else
         {
            this.facing = LEFT;
            _loc1_ = this.ddx - 20 - x;
            _loc2_ = this.ddy - 20 - y;
            _loc3_ = FlxU.getAngle(_loc1_,_loc2_);
            angle = 180 + _loc3_;
         }
         super.update();
      }
   }
}

