package
{
   import org.flixel.FlxSprite;
   
   public class BulletBlock extends FlxSprite
   {
      
      private var ImgMarker:Class = bullet_Block_ImgMarker;
      
      public function BulletBlock(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super(param1,param2);
         loadGraphic(this.ImgMarker,false,false,param3,param4);
         alpha = 0;
         fixed = true;
      }
   }
}

