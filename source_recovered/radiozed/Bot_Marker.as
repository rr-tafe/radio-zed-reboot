package
{
   import org.flixel.FlxSprite;
   
   public class Bot_Marker extends FlxSprite
   {
      
      public var _ThisName:String;
      
      private var ImgMarker:Class = Bot_Marker_ImgMarker;
      
      public function Bot_Marker(param1:Number, param2:Number, param3:Number, param4:String = "")
      {
         super(param1,param2);
         this._ThisName = param4;
         loadGraphic(this.ImgMarker,false,false,param3,4);
         alpha = 0;
         fixed = true;
         collideRight = false;
         collideLeft = false;
         collideTop = false;
         collideBottom = false;
      }
   }
}

