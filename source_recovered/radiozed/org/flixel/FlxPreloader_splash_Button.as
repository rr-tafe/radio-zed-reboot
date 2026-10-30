package org.flixel
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol12")]
   public class FlxPreloader_splash_Button extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
      
      public var dataClass:Class = FlxPreloader_splash_Button_dataClass;
      
      public function FlxPreloader_splash_Button()
      {
         super();
         initialWidth = 2340 / 20;
         initialHeight = 840 / 20;
      }
      
      override public function get movieClipData() : ByteArray
      {
         if(bytes == null)
         {
            bytes = ByteArray(new this.dataClass());
         }
         return bytes;
      }
   }
}

