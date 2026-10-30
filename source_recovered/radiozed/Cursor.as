package
{
   import org.flixel.FlxSprite;
   import org.flixel.FlxU;
   
   public class Cursor extends FlxSprite
   {
      
      protected var _player:Player;
      
      private var ImgCursor:Class = Cursor_ImgCursor;
      
      public function Cursor(param1:Player)
      {
         this._player = param1;
         super();
         loadGraphic(this.ImgCursor,true,true,15,3);
         solid = false;
      }
      
      override public function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = this._player.x + 10;
         var _loc5_:Number = this._player.y + 10;
         if(_loc4_ > x)
         {
            this.facing = RIGHT;
            _loc1_ = _loc4_ - x;
            _loc2_ = _loc5_ - y;
            _loc3_ = FlxU.getAngle(_loc1_,_loc2_);
            angle = _loc3_;
         }
         else
         {
            this.facing = LEFT;
            _loc1_ = _loc4_ - x;
            _loc2_ = _loc5_ - y;
            _loc3_ = FlxU.getAngle(_loc1_,_loc2_);
            angle = 180 + _loc3_;
         }
         super.update();
      }
   }
}

