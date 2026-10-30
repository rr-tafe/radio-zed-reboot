package
{
   import org.flixel.FlxEmitter;
   import org.flixel.FlxG;
   import org.flixel.FlxGroup;
   import org.flixel.FlxSprite;
   
   public class Spawner extends FlxSprite
   {
      
      private var _player:Player;
      
      protected var _doorsUp:FlxGroup = new FlxGroup();
      
      private var _targets:FlxGroup = new FlxGroup();
      
      private var zombLimitNow:Number = 0;
      
      private var _timer:Number;
      
      protected var _doorsDown:FlxGroup = new FlxGroup();
      
      private var zombLimit:Number;
      
      private var _gibs:FlxEmitter;
      
      private var speedArr:Array = [10,16,14,17,18,19,20,30];
      
      private var ImgThis:Class = Spawner_ImgThis;
      
      private var _bots:FlxGroup;
      
      private var _thisTimeLimit:Number;
      
      private var _radio:Radio;
      
      public function Spawner(param1:int, param2:int, param3:FlxGroup, param4:FlxEmitter, param5:Player, param6:Radio, param7:FlxGroup, param8:FlxGroup, param9:Number, param10:FlxGroup, param11:Number)
      {
         super(param1,param2);
         this._thisTimeLimit = param11;
         this._targets = param10;
         this._radio = param6;
         loadGraphic(this.ImgThis,false,true,16,16);
         alpha = 0;
         this.zombLimit = param9;
         this._doorsUp = param8;
         this._doorsDown = param7;
         this._gibs = param4;
         this._bots = param3;
         this._player = param5;
         this._timer = Math.random() * 20;
         solid = false;
      }
      
      override public function hurt(param1:Number) : void
      {
      }
      
      override public function update() : void
      {
         this._timer += FlxG.elapsed;
         var _loc1_:uint = this._thisTimeLimit;
         if(onScreen())
         {
            _loc1_ = this._thisTimeLimit;
         }
         if(this._timer > _loc1_)
         {
            this._timer = 0;
            if(this.zombLimitNow < this.zombLimit)
            {
               this.OBF_1d03();
               this.zombLimitNow += 1;
            }
         }
         super.update();
      }
      
      override public function kill() : void
      {
         active = false;
         exists = true;
         solid = false;
      }
      
      protected function OBF_1d03() : void
      {
         var _loc1_:zombie1 = new zombie1(x + width / 2,y + height / 2,this._gibs,this._player,this._radio,this._doorsDown,this._doorsUp,this._targets);
         _loc1_.x -= _loc1_.width / 2;
         _loc1_.y -= _loc1_.height / 2;
         this._bots.add(_loc1_);
      }
   }
}

