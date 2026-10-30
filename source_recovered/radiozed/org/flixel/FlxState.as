package org.flixel
{
   import flash.display.Sprite;
   
   public class FlxState extends Sprite
   {
      
      public static var screen:FlxSprite;
      
      public static var bgColor:uint;
      
      public var defaultGroup:FlxGroup;
      
      public function FlxState()
      {
         super();
         this.defaultGroup = new FlxGroup();
         if(screen == null)
         {
            screen = new FlxSprite();
            screen.createGraphic(FlxG.width,FlxG.height,0,true);
            var _temp_1:* = screen.origin;
            screen.origin.y = 0;
            _temp_1.x = 0;
            screen.antialiasing = true;
         }
      }
      
      public function add(param1:FlxObject) : FlxObject
      {
         return this.defaultGroup.add(param1);
      }
      
      public function preProcess() : void
      {
         screen.OBF_1e14(bgColor);
      }
      
      public function collide() : void
      {
         this.defaultGroup.collide();
      }
      
      public function render() : void
      {
         this.defaultGroup.render();
      }
      
      public function update() : void
      {
         this.defaultGroup.update();
      }
      
      public function destroy() : void
      {
         this.defaultGroup.destroy();
      }
      
      public function create() : void
      {
      }
      
      public function postProcess() : void
      {
      }
   }
}

