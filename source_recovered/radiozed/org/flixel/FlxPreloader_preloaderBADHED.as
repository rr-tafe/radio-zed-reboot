package org.flixel
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol12")]
   public class FlxPreloader_preloaderBADHED extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
      
      public var dataClass:Class = FlxPreloader_preloaderBADHED_dataClass;
      
      public function FlxPreloader_preloaderBADHED()
      {
         super();
         initialWidth = 16000 / 20;
         initialHeight = 12000 / 20;
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

