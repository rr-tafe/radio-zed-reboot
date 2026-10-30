package org.flixel.data
{
   public class OBF_1e13
   {
      
      public var delay:Number;
      
      public var frames:Array;
      
      public var looped:Boolean;
      
      public var name:String;
      
      public function OBF_1e13(param1:String, param2:Array, param3:Number = 0, param4:Boolean = true)
      {
         super();
         this.name = param1;
         this.delay = 0;
         if(param3 > 0)
         {
            this.delay = 1 / param3;
         }
         this.frames = param2;
         this.looped = param4;
      }
   }
}

