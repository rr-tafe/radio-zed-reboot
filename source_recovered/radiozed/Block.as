package
{
   import org.flixel.FlxSprite;
   
   public class Block extends FlxSprite
   {
      
      private var ImgBlock:Class = Block_ImgBlock;
      
      public function Block(param1:Number, param2:Number)
      {
         super(param1,param2);
         loadGraphic(this.ImgBlock,false,true,25,16);
         alpha = 0;
         health = 100;
         width = 25;
         height = 16;
         fixed = true;
      }
   }
}

