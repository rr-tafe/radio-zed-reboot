package org.flixel.data
{
   import flash.events.KeyboardEvent;
   
   public class OBF_1e0c
   {
      
      public var RIGHT:Boolean;
      
      protected const _t:uint = 256;
      
      public var LEFT:Boolean;
      
      public var FOUR:Boolean;
      
      public var TWO:Boolean;
      
      public var CONTROL:Boolean;
      
      public var A:Boolean;
      
      public var B:Boolean;
      
      public var C:Boolean;
      
      public var D:Boolean;
      
      public var E:Boolean;
      
      public var ONE:Boolean;
      
      public var G:Boolean;
      
      public var H:Boolean;
      
      public var I:Boolean;
      
      public var J:Boolean;
      
      public var K:Boolean;
      
      public var F:Boolean;
      
      public var N:Boolean;
      
      public var O:Boolean;
      
      public var Q:Boolean;
      
      public var R:Boolean;
      
      public var S:Boolean;
      
      public var T:Boolean;
      
      public var U:Boolean;
      
      public var MINUS:Boolean;
      
      public var Y:Boolean;
      
      public var L:Boolean;
      
      public var Z:Boolean;
      
      public var QUOTE:Boolean;
      
      public var V:Boolean;
      
      public var X:Boolean;
      
      public var P:Boolean;
      
      public var SHIFT:Boolean;
      
      public var SLASH:Boolean;
      
      public var BACKSPACE:Boolean;
      
      public var EIGHT:Boolean;
      
      public var W:Boolean;
      
      public var M:Boolean;
      
      public var THREE:Boolean;
      
      public var ESCAPE:Boolean;
      
      public var SEMICOLON:Boolean;
      
      public var CAPSLOCK:Boolean;
      
      protected var _lookup:Object;
      
      public var PLUS:Boolean;
      
      protected var _map:Array;
      
      public var ZERO:Boolean;
      
      public var DOWN:Boolean;
      
      public var F1:Boolean;
      
      public var F2:Boolean;
      
      public var F3:Boolean;
      
      public var F4:Boolean;
      
      public var F5:Boolean;
      
      public var F6:Boolean;
      
      public var F7:Boolean;
      
      public var NINE:Boolean;
      
      public var F9:Boolean;
      
      public var ALT:Boolean;
      
      public var F8:Boolean;
      
      public var DELETE:Boolean;
      
      public var LBRACKET:Boolean;
      
      public var UP:Boolean;
      
      public var ENTER:Boolean;
      
      public var FIVE:Boolean;
      
      public var SIX:Boolean;
      
      public var COMMA:Boolean;
      
      public var PERIOD:Boolean;
      
      public var BACKSLASH:Boolean;
      
      public var F10:Boolean;
      
      public var F11:Boolean;
      
      public var F12:Boolean;
      
      public var SEVEN:Boolean;
      
      public var SPACE:Boolean;
      
      public var RBRACKET:Boolean;
      
      public function OBF_1e0c()
      {
         super();
         var _loc1_:uint = 0;
         this._lookup = new Object();
         this._map = new Array(this._t);
         _loc1_ = 65;
         while(_loc1_ <= 90)
         {
            this.OBF_1b(String.fromCharCode(_loc1_),_loc1_);
            _loc1_++;
         }
         _loc1_ = 48;
         this.OBF_1b("ZERO",_loc1_++);
         this.OBF_1b("ONE",_loc1_++);
         this.OBF_1b("TWO",_loc1_++);
         this.OBF_1b("THREE",_loc1_++);
         this.OBF_1b("FOUR",_loc1_++);
         this.OBF_1b("FIVE",_loc1_++);
         this.OBF_1b("SIX",_loc1_++);
         this.OBF_1b("SEVEN",_loc1_++);
         this.OBF_1b("EIGHT",_loc1_++);
         this.OBF_1b("NINE",_loc1_++);
         _loc1_ = 1;
         while(_loc1_ <= 12)
         {
            this.OBF_1b("F" + _loc1_,111 + _loc1_);
            _loc1_++;
         }
         this.OBF_1b("ESCAPE",27);
         this.OBF_1b("MINUS",189);
         this.OBF_1b("PLUS",187);
         this.OBF_1b("DELETE",46);
         this.OBF_1b("BACKSPACE",8);
         this.OBF_1b("LBRACKET",219);
         this.OBF_1b("RBRACKET",221);
         this.OBF_1b("BACKSLASH",220);
         this.OBF_1b("CAPSLOCK",20);
         this.OBF_1b("SEMICOLON",186);
         this.OBF_1b("QUOTE",222);
         this.OBF_1b("ENTER",13);
         this.OBF_1b("SHIFT",16);
         this.OBF_1b("COMMA",188);
         this.OBF_1b("PERIOD",190);
         this.OBF_1b("SLASH",191);
         this.OBF_1b("CONTROL",17);
         this.OBF_1b("ALT",18);
         this.OBF_1b("SPACE",32);
         this.OBF_1b("UP",38);
         this.OBF_1b("DOWN",40);
         this.OBF_1b("LEFT",37);
         this.OBF_1b("RIGHT",39);
      }
      
      public function handleKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = this._map[param1.keyCode];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.current <= 0)
         {
            _loc2_.current = 0;
         }
         else
         {
            _loc2_.current = -1;
         }
         this[_loc2_.name] = false;
      }
      
      public function pressed(param1:String) : Boolean
      {
         return this[param1];
      }
      
      public function justReleased(param1:String) : Boolean
      {
         return this._map[this._lookup[param1]].current == -1;
      }
      
      public function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = this._map[param1.keyCode];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.current <= 0)
         {
            _loc2_.current = 2;
         }
         else
         {
            _loc2_.current = 1;
         }
         this[_loc2_.name] = true;
      }
      
      public function reset() : void
      {
         var _loc2_:Object = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._t)
         {
            if(this._map[_loc1_] != null)
            {
               _loc2_ = this._map[_loc1_];
               this[_loc2_.name] = false;
               _loc2_.current = 0;
               _loc2_.last = 0;
            }
            _loc1_++;
         }
      }
      
      public function justPressed(param1:String) : Boolean
      {
         return this._map[this._lookup[param1]].current == 2;
      }
      
      public function update() : void
      {
         var _loc2_:Object = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._t)
         {
            if(this._map[_loc1_] != null)
            {
               _loc2_ = this._map[_loc1_];
               if(_loc2_.last == -1 && _loc2_.current == -1)
               {
                  _loc2_.current = 0;
               }
               else if(_loc2_.last == 2 && _loc2_.current == 2)
               {
                  _loc2_.current = 1;
               }
               _loc2_.last = _loc2_.current;
            }
            _loc1_++;
         }
      }
      
      protected function OBF_1b(param1:String, param2:uint) : void
      {
         this._lookup[param1] = param2;
         this._map[param2] = {
            "name":param1,
            "current":0,
            "last":0
         };
      }
   }
}

