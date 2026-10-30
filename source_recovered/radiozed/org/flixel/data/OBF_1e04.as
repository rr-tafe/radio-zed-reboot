package org.flixel.data
{
   import org.flixel.FlxG;
   
   public class OBF_1e04
   {
      
      public var y:int;
      
      protected var _timer:Number;
      
      protected var _intensity:Number;
      
      public var x:int;
      
      protected var _zoom:uint;
      
      public function OBF_1e04(param1:uint)
      {
         super();
         this._zoom = param1;
         this.start(0);
      }
      
      public function update() : void
      {
         if(this._timer > 0)
         {
            this._timer -= FlxG.elapsed;
            if(this._timer > 0)
            {
               this.x = (Math.random() * this._intensity * FlxG.width * 2 - this._intensity * FlxG.width) * this._zoom;
               this.y = (Math.random() * this._intensity * FlxG.height * 2 - this._intensity * FlxG.height) * this._zoom;
            }
            else
            {
               this._timer = 0;
               this.x = 0;
               this.y = 0;
            }
         }
      }
      
      public function start(param1:Number = 0.05, param2:Number = 0.5) : void
      {
         this.stop();
         this._intensity = param1;
         this._timer = param2;
      }
      
      public function stop() : void
      {
         this.x = 0;
         this.y = 0;
         this._intensity = 0;
         this._timer = 0;
      }
   }
}

