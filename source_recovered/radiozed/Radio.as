package
{
   import org.flixel.FlxG;
   import org.flixel.FlxSprite;
   import org.flixel.FlxText;
   import flash.net.SharedObject;
   
   public class Radio extends FlxSprite
   {
      
      private var ImgHeatlh_bar:Class = Radio_ImgHeatlh_bar;
      
      protected var shared:SharedObject = SharedObject.getLocal("reloaded");
      
      private var _barricadeNumber:Number;
      
      private var healthBar:FlxText;
      
      private var GUI:FlxSprite;
      
      private var ImgRadion:Class = Radio_ImgRadion;
      
      public function Radio(param1:Number, param2:Number)
      {
         super(param1,param2);
         loadGraphic(this.ImgRadion,false,true,37,64);
         collideRight = false;
         collideLeft = false;
         collideTop = false;
         this.health = 100;
         this.GUI = new FlxSprite(this.x + 6,this.y - 4,this.ImgHeatlh_bar);
         FlxG.state.add(this.GUI);
         this.healthBar = new FlxText(this.GUI.x + 8,this.GUI.y - 3,FlxG.width,String(health));
         this.healthBar.color = 14868183;
         this.healthBar.size = 8;
         FlxG.state.add(this.healthBar);
      }
      
      override public function hurt(param1:Number) : void
      {
         this.healthBar.text = String(health);
         if(health <= 2)
         {
            this.healthBar.kill();
            this.GUI.kill();
         }
         super.hurt(param1);
      }
      
      override public function kill() : void
      {
         if(dead)
         {
            return;
         }
         this.healthBar.kill();
         this.GUI.kill();
      }
   }
}

