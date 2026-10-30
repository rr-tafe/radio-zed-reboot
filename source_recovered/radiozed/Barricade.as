package
{
   import org.flixel.*;
   import flash.net.SharedObject;
   
   public class Barricade extends FlxSprite
   {
      
      private var ImgHeatlh_bar:Class = Barricade_ImgHeatlh_bar;
      
      protected var shared:SharedObject = SharedObject.getLocal("reloaded");
      
      private var ImgBarricade1:Class = Barricade_ImgBarricade1;
      
      private var ImgBarricade2:Class = Barricade_ImgBarricade2;
      
      private var ImgBarricade3:Class = Barricade_ImgBarricade3;
      
      private var ImgBarricade0:Class = Barricade_ImgBarricade0;
      
      private var _barricadeNumber:Number;
      
      private var healthBar:FlxText;
      
      private var GUI:FlxSprite;
      
      public function Barricade(param1:Number, param2:Number, param3:Number)
      {
         var _loc4_:Number = NaN;
         super(param1,param2);
         if(param3 == 0)
         {
            if(this.shared.data.leftBarricade_lvl == 0)
            {
               loadGraphic(this.ImgBarricade0,false,true,31,35);
            }
            else if(this.shared.data.leftBarricade_lvl == 1)
            {
               loadGraphic(this.ImgBarricade1,false,true,31,35);
            }
            else if(this.shared.data.leftBarricade_lvl != 2)
            {
               if(this.shared.data.leftBarricade_lvl == 3)
               {
                  loadGraphic(this.ImgBarricade3,false,true,31,35);
               }
            }
            else
            {
               loadGraphic(this.ImgBarricade2,false,true,31,35);
            }
         }
         else if(param3 == 1)
         {
            if(this.shared.data.rightBarricade_lvl == 0)
            {
               loadGraphic(this.ImgBarricade0,false,true,31,35);
            }
            else if(this.shared.data.rightBarricade_lvl != 1)
            {
               if(this.shared.data.rightBarricade_lvl == 2)
               {
                  loadGraphic(this.ImgBarricade2,false,true,31,35);
               }
               else if(this.shared.data.rightBarricade_lvl == 3)
               {
                  loadGraphic(this.ImgBarricade3,false,true,31,35);
               }
            }
            else
            {
               loadGraphic(this.ImgBarricade1,false,true,31,35);
            }
         }
         addAnimation("100",[0]);
         addAnimation("80",[1]);
         addAnimation("40",[2]);
         addAnimation("10",[3]);
         addAnimation("0",[4]);
         collideRight = false;
         collideLeft = false;
         collideTop = false;
         if(param3 != 0)
         {
            if(param3 == 1)
            {
               this._barricadeNumber = 1;
               health = this.shared.data.rightBarricade;
            }
         }
         else
         {
            this._barricadeNumber = 0;
            health = this.shared.data.leftBarricade;
         }
         if(this._barricadeNumber != 0)
         {
            if(this._barricadeNumber == 1)
            {
               this.shared.data.rightBarricade = health;
               _loc4_ = this.shared.data.rightBarricade / this.shared.data.rightBarricade_Max;
               if(_loc4_ >= 0.81)
               {
                  play("100");
               }
               else if(_loc4_ >= 0.41)
               {
                  play("80");
               }
               else if(_loc4_ < 0.11)
               {
                  if(_loc4_ > 0)
                  {
                     play("10");
                  }
                  else if(this.shared.data.rightBarricade == 0)
                  {
                     play("0");
                  }
               }
               else
               {
                  play("40");
               }
            }
         }
         else
         {
            this.shared.data.leftBarricade = health;
            _loc4_ = this.shared.data.leftBarricade / this.shared.data.leftBarricade_Max;
            if(_loc4_ >= 0.81)
            {
               play("100");
            }
            else if(_loc4_ < 0.41)
            {
               if(_loc4_ >= 0.11)
               {
                  play("40");
               }
               else if(_loc4_ > 0)
               {
                  play("10");
               }
               else if(this.shared.data.leftBarricade == 0)
               {
                  play("0");
               }
            }
            else
            {
               play("80");
            }
         }
         if(health > 0)
         {
            this.GUI = new FlxSprite(this.x + 6,this.y - 5,this.ImgHeatlh_bar);
            FlxG.state.add(this.GUI);
            this.healthBar = new FlxText(this.GUI.x + 8,this.GUI.y - 4,FlxG.width,String(health));
            this.healthBar.color = 14868183;
            this.healthBar.size = 8;
            FlxG.state.add(this.healthBar);
         }
      }
      
      override public function hurt(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         this.healthBar.text = String(health);
         if(health <= 2)
         {
            this.healthBar.kill();
            this.GUI.kill();
         }
         super.hurt(param1);
         if(this._barricadeNumber != 0)
         {
            if(this._barricadeNumber == 1)
            {
               this.shared.data.rightBarricade = health;
               _loc2_ = this.shared.data.rightBarricade / this.shared.data.rightBarricade_Max;
               if(_loc2_ < 0.81)
               {
                  if(_loc2_ >= 0.41)
                  {
                     play("80");
                  }
                  else if(_loc2_ >= 0.11)
                  {
                     play("40");
                  }
                  else if(_loc2_ > 0)
                  {
                     play("10");
                  }
               }
               else
               {
                  play("100");
               }
            }
         }
         else
         {
            this.shared.data.leftBarricade = health;
            _loc2_ = this.shared.data.leftBarricade / this.shared.data.leftBarricade_Max;
            if(_loc2_ < 0.81)
            {
               if(_loc2_ >= 0.41)
               {
                  play("80");
               }
               else if(_loc2_ >= 0.11)
               {
                  play("40");
               }
               else if(_loc2_ > 0)
               {
                  play("10");
               }
            }
            else
            {
               play("100");
            }
         }
      }
      
      override public function kill() : void
      {
         if(dead)
         {
            return;
         }
         play("0");
      }
   }
}

