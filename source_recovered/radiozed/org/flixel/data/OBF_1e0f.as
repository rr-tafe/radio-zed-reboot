package org.flixel.data
{
   import org.flixel.FlxG;
   import org.flixel.FlxSprite;
   
   public class OBF_1e0f extends FlxSprite
   {
      
      protected var _delay:Number;
      
      protected var _complete:Function;
      
      public function OBF_1e0f()
      {
         super();
         createGraphic(FlxG.width,FlxG.height,0,true);
         scrollFactor.x = 0;
         scrollFactor.y = 0;
         exists = false;
      }
      
      override public function update() : void
      {
         alpha += FlxG.elapsed / this._delay;
         if(alpha >= 1)
         {
            alpha = 1;
            if(this._complete != null)
            {
               this._complete();
            }
         }
      }
      
      public function start(param1:uint = 4278190080, param2:Number = 1, param3:Function = null, param4:Boolean = false) : void
      {
         if(!param4 && exists)
         {
            return;
         }
         OBF_1e14(param1);
         this._delay = param2;
         this._complete = param3;
         alpha = 0;
         exists = true;
      }
      
      public function stop() : void
      {
         exists = false;
      }
   }
}

