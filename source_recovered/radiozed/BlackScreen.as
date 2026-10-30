package
{
   import org.flixel.FlxG;
   import org.flixel.FlxSprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BlackScreen extends FlxSprite
   {
      
      private var SndFail:Class = blackScreen_SndFail;
      
      private var blackScreenImg:Class = blackScreen_blackScreenImg;
      
      private var oneTimer:Timer = new Timer(10);
      
      public function BlackScreen()
      {
         super(0,0);
         solid = false;
         loadGraphic(this.blackScreenImg);
         alpha = 0.01;
         scale.x = 640;
         scale.y = 480;
         var _temp_1:* = scrollFactor;
         scrollFactor.y = 0;
         _temp_1.x = 0;
      }
      
      private function OBF_1a0c(param1:TimerEvent) : void
      {
         alpha += 0.01;
         if(alpha > 0.98)
         {
            this.oneTimer.stop();
            this.oneTimer.removeEventListener(TimerEvent.TIMER,this.OBF_1a0c);
         }
      }
      
      public function startTick() : void
      {
         FlxG.play(this.SndFail);
         this.oneTimer.addEventListener(TimerEvent.TIMER,this.OBF_1a0c);
         this.oneTimer.start();
      }
      
      override public function update() : void
      {
         super.update();
      }
   }
}

