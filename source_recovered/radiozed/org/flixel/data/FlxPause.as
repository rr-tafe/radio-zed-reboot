package org.flixel.data
{
   import org.flixel.FlxG;
   import org.flixel.FlxGroup;
   import org.flixel.FlxText;
   
   public class FlxPause extends FlxGroup
   {
      
      private var ImgKeyP:Class = FlxPause_ImgKeyP;
      
      private var ImgKey0:Class = FlxPause_ImgKey0;
      
      private var ImgKeyPlus:Class = FlxPause_ImgKeyPlus;
      
      private var ImgKeyMinus:Class = FlxPause_ImgKeyMinus;
      
      public function FlxPause()
      {
         super();
         scrollFactor.x = 0;
         scrollFactor.y = 0;
         x = (FlxG.width - 80) / 2;
         y = (FlxG.height - 92) / 2;
         add(new FlxText(0,5,80,"PAUSED").setFormat(null,16,14868183,"center"),true);
      }
   }
}

