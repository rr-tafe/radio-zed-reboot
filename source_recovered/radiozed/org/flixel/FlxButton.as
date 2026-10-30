package org.flixel
{
   import flash.events.MouseEvent;
   
   public class FlxButton extends FlxGroup
   {
      
      public var _line:Number;
      
      protected var _initialized:Boolean;
      
      protected var _onT:FlxText;
      
      protected var _pressed:Boolean;
      
      protected var _offT:FlxText;
      
      protected var _off:FlxSprite;
      
      protected var _sf:FlxPoint;
      
      public var _column:Number;
      
      protected var _onToggle:Boolean;
      
      protected var _callback:Function;
      
      protected var _on:FlxSprite;
      
      public function FlxButton(param1:int, param2:int, param3:Function)
      {
         super();
         x = param1;
         y = param2;
         width = 100;
         height = 20;
         this._off = new FlxSprite().createGraphic(width,height,4286545791);
         this._off.solid = false;
         add(this._off,true);
         this._on = new FlxSprite().createGraphic(width,height,4294967295);
         this._on.solid = false;
         add(this._on,true);
         this._offT = null;
         this._onT = null;
         this._callback = param3;
         this._onToggle = false;
         this._pressed = false;
         this._initialized = false;
         this._sf = null;
      }
      
      override public function destroy() : void
      {
         if(FlxG.stage != null)
         {
            FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP,this.OBF_1c0f);
         }
      }
      
      public function set on(param1:Boolean) : void
      {
         this._onToggle = param1;
      }
      
      override public function update() : void
      {
         if(!this._initialized)
         {
            if(FlxG.stage != null)
            {
               FlxG.stage.addEventListener(MouseEvent.MOUSE_UP,this.OBF_1c0f);
            }
         }
         super.update();
         this.OBF_1a02(false);
         if(overlapsPoint(FlxG.mouse.x,FlxG.mouse.y))
         {
            if(!FlxG.mouse.pressed())
            {
               this._pressed = false;
            }
            else if(!this._pressed)
            {
               this._pressed = true;
            }
            this.OBF_1a02(!this._pressed);
         }
         if(this._onToggle)
         {
            this.OBF_1a02(this._off.visible);
         }
      }
      
      protected function OBF_1c0f(param1:MouseEvent) : void
      {
         if(!exists || !visible || !active || !FlxG.mouse.justReleased() || this._callback == null)
         {
            return;
         }
         if(overlapsPoint(FlxG.mouse.x,FlxG.mouse.y))
         {
            this._callback();
         }
      }
      
      protected function OBF_1a02(param1:Boolean) : void
      {
         if(param1)
         {
            this._off.visible = false;
            if(this._offT != null)
            {
               this._offT.visible = false;
            }
            this._on.visible = true;
            if(this._onT != null)
            {
               this._onT.visible = true;
            }
         }
         else
         {
            this._on.visible = false;
            if(this._onT != null)
            {
               this._onT.visible = false;
            }
            this._off.visible = true;
            if(this._offT != null)
            {
               this._offT.visible = true;
            }
         }
      }
      
      public function get on() : Boolean
      {
         return this._onToggle;
      }
      
      public function loadGraphic(param1:FlxSprite, param2:FlxSprite = null) : FlxButton
      {
         this._off = replace(this._off,param1) as FlxSprite;
         if(param2 != null)
         {
            this._on = replace(this._on,param2) as FlxSprite;
         }
         else
         {
            if(this._on != this._off)
            {
               OBF_1b0e(this._on);
            }
            this._on = this._off;
         }
         var _temp_1:* = this._on;
         this._off.solid = false;
         _temp_1.solid = false;
         this._off.scrollFactor = scrollFactor;
         this._on.scrollFactor = scrollFactor;
         width = this._off.width;
         height = this._off.height;
         refreshHulls();
         return this;
      }
      
      public function OBF_1d05(param1:FlxText, param2:FlxText = null) : FlxButton
      {
         if(param1 != null)
         {
            if(this._offT == null)
            {
               this._offT = param1;
               add(this._offT);
            }
            else
            {
               this._offT = replace(this._offT,param1) as FlxText;
            }
         }
         if(param2 == null)
         {
            this._onT = this._offT;
         }
         else if(this._onT != null)
         {
            this._onT = replace(this._onT,param2) as FlxText;
         }
         else
         {
            this._onT = param2;
            add(this._onT);
         }
         this._offT.scrollFactor = scrollFactor;
         this._onT.scrollFactor = scrollFactor;
         return this;
      }
   }
}

