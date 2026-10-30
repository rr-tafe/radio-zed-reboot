package
{
   import org.flixel.FlxSprite;
   
   public class DoorDown extends FlxSprite
   {
      
      private var ImgDoor:Class = DoorDown_ImgDoor;
      
      public function DoorDown(param1:Number, param2:Number)
      {
         super(param1,param2);
         loadGraphic(this.ImgDoor,false,false,20,32);
         width = 20;
         height = 32;
         fixed = true;
         visible = false;
         collideRight = false;
         collideLeft = false;
         collideTop = false;
         collideBottom = false;
         solid = false;
      }
   }
}

