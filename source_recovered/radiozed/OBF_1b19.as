package
{
   import org.flixel.FlxPreloader;
   import flash.events.Event;
   
   [SWF(width="640", height="480", backgroundColor="#000000", frameRate="30")]
   public dynamic class OBF_1b19 extends FlxPreloader
   {
      
      public function OBF_1b19()
      {
         addEventListener(Event.ENTER_FRAME,this.test);
         className = "Zombie_game";
         super();
      }
      
      private function test(param1:Event) : void
      {
      }
   }
}

