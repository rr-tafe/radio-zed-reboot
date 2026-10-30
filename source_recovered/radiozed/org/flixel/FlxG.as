package org.flixel
{
   import org.flixel.data.*;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class FlxG
   {
      
      public static var panel:FlxPanel;
      
      protected static var _mute:Boolean;
      
      public static var kong:OBF_1e0b;
      
      public static var scores:Array;
      
      public static var music:FlxSound;
      
      public static var height:uint;
      
      protected static var _volume:Number;
      
      public static var buffer:BitmapData;
      
      public static var sounds:Array;
      
      public static var debug:Boolean;
      
      public static var levels:Array;
      
      public static var fade:OBF_1e0f;
      
      public static var save:int;
      
      protected static var _cache:Object;
      
      public static var level:int;
      
      public static var elapsed:Number;
      
      public static var score:int;
      
      public static var timeScale:Number;
      
      public static var saves:Array;
      
      protected static var _scrollTarget:Point;
      
      public static var followTarget:FlxObject;
      
      public static var mouse:FlxMouse;
      
      public static var followLead:Point;
      
      public static var width:uint;
      
      public static var followLerp:Number;
      
      public static var scroll:Point;
      
      protected static var _game:FlxGame;
      
      public static var quake:OBF_1e04;
      
      public static var followMin:Point;
      
      public static var flash:OBF_1e0e;
      
      public static var followMax:Point;
      
      public static var keys:OBF_1e0c;
      
      protected static var _pause:Boolean;
      
      public static var superPause:Boolean = true;
      
      public static var LIBRARY_NAME:String = "flixel";
      
      public static var LIBRARY_MAJOR_VERSION:uint = 2;
      
      public static var LIBRARY_MINOR_VERSION:uint = 23;
      
      public function FlxG()
      {
         super();
      }
      
      public static function get stage() : Stage
      {
         if(!(_game._state != null && _game._state.parent != null))
         {
            return null;
         }
         return _game._state.parent.stage;
      }
      
      protected static function OBF_0b() : void
      {
         var _loc1_:FlxSound = null;
         if(music != null && music.active)
         {
            music.OBF_1a03();
         }
         var _loc2_:uint = sounds.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = sounds[_loc3_] as FlxSound;
            if(_loc1_ != null && _loc1_.active)
            {
               _loc1_.OBF_1a03();
            }
            _loc3_++;
         }
      }
      
      public static function get mute() : Boolean
      {
         return _mute;
      }
      
      public static function get volume() : Number
      {
         return _volume;
      }
      
      internal static function doFollow() : void
      {
         if(followTarget != null)
         {
            _scrollTarget.x = (width >> 1) - followTarget.x - (followTarget.width >> 1) + (followTarget as FlxSprite).offset.x;
            _scrollTarget.y = (height >> 1) - followTarget.y - (followTarget.height >> 1) + (followTarget as FlxSprite).offset.y;
            if(followLead != null && followTarget is FlxSprite)
            {
               _scrollTarget.x -= (followTarget as FlxSprite).velocity.x * followLead.x;
               _scrollTarget.y -= (followTarget as FlxSprite).velocity.y * followLead.y;
            }
            scroll.x += (_scrollTarget.x - scroll.x) * followLerp * FlxG.elapsed;
            scroll.y += (_scrollTarget.y - scroll.y) * followLerp * FlxG.elapsed;
            if(followMin != null)
            {
               if(scroll.x > followMin.x)
               {
                  scroll.x = followMin.x;
               }
               if(scroll.y > followMin.y)
               {
                  scroll.y = followMin.y;
               }
            }
            if(followMax != null)
            {
               if(scroll.x < followMax.x)
               {
                  scroll.x = followMax.x;
               }
               if(scroll.y < followMax.y)
               {
                  scroll.y = followMax.y;
               }
            }
         }
      }
      
      public static function getMuteValue() : uint
      {
         if(_mute)
         {
            return 0;
         }
         return 1;
      }
      
      public static function addBitmap(param1:Class, param2:Boolean = false, param3:Boolean = false, param4:String = null) : BitmapData
      {
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:BitmapData = null;
         var _loc11_:Matrix = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = param4;
         if(_loc6_ == null)
         {
            _loc6_ = String(param1);
            if(param3 && _cache[_loc6_] != undefined && _cache[_loc6_] != null)
            {
               _loc8_ = 0;
               do
               {
                  _loc9_ = _loc6_ + _loc8_++;
               }
               while(_cache[_loc9_] != undefined && _cache[_loc9_] != null);
               _loc6_ = _loc9_;
            }
         }
         if(!checkBitmapCache(_loc6_))
         {
            _cache[_loc6_] = new param1().bitmapData;
            if(param2)
            {
               _loc5_ = true;
            }
         }
         var _loc7_:BitmapData = _cache[_loc6_];
         if(!_loc5_ && param2 && _loc7_.width == new param1().bitmapData.width)
         {
            _loc5_ = true;
         }
         if(_loc5_)
         {
            _loc10_ = new BitmapData(_loc7_.width << 1,_loc7_.height,true,0);
            _loc10_.draw(_loc7_);
            _loc11_ = new Matrix();
            _loc11_.scale(-1,1);
            _loc11_.translate(_loc10_.width,0);
            _loc10_.draw(_loc7_,_loc11_);
            _loc7_ = _loc10_;
         }
         return _loc7_;
      }
      
      public static function set state(param1:FlxState) : void
      {
         _game.OBF_1a0f(param1);
      }
      
      public static function set mute(param1:Boolean) : void
      {
         _mute = param1;
         OBF_0b();
      }
      
      public static function play(param1:Class, param2:Number = 1, param3:Boolean = false) : FlxSound
      {
         var _loc4_:uint = sounds.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            if(!(sounds[_loc5_] as FlxSound).active)
            {
               break;
            }
            _loc5_++;
         }
         if(sounds[_loc5_] == null)
         {
            sounds[_loc5_] = new FlxSound();
         }
         var _loc6_:FlxSound = sounds[_loc5_];
         _loc6_.OBF_1d07(param1,param3);
         _loc6_.volume = param2;
         _loc6_.play();
         return _loc6_;
      }
      
      internal static function setGameData(param1:FlxGame, param2:uint, param3:uint, param4:uint) : void
      {
         _game = param1;
         _cache = new Object();
         width = param2;
         height = param3;
         _mute = false;
         _volume = 0.5;
         sounds = new Array();
         mouse = new FlxMouse();
         keys = new OBF_1e0c();
         scroll = null;
         _scrollTarget = null;
         unfollow();
         FlxG.levels = new Array();
         FlxG.scores = new Array();
         level = 0;
         score = 0;
         FlxU.seed = NaN;
         kong = null;
         pause = false;
         timeScale = 1;
         panel = new FlxPanel();
         quake = new OBF_1e04(param4);
         flash = new OBF_1e0e();
         fade = new OBF_1e0f();
         FlxU.setWorldBounds();
      }
      
      public static function set volume(param1:Number) : void
      {
         _volume = param1;
         if(_volume < 0)
         {
            _volume = 0;
         }
         else if(_volume > 1)
         {
            _volume = 1;
         }
         OBF_0b();
      }
      
      public static function OBF_1b1b(param1:Class, param2:Number = 1) : void
      {
         if(music == null)
         {
            music = new FlxSound();
         }
         else if(music.active)
         {
            music.stop();
         }
         music.OBF_1d07(param1,true);
         music.volume = param2;
         music.survive = true;
         music.play();
      }
      
      public static function createBitmap(param1:uint, param2:uint, param3:uint, param4:Boolean = false, param5:String = null) : BitmapData
      {
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc6_:String = param5;
         if(_loc6_ == null)
         {
            _loc6_ = param1 + "x" + param2 + ":" + param3;
            if(param4 && _cache[_loc6_] != undefined && _cache[_loc6_] != null)
            {
               _loc7_ = 0;
               do
               {
                  _loc8_ = _loc6_ + _loc7_++;
               }
               while(_cache[_loc8_] != undefined && _cache[_loc8_] != null);
               _loc6_ = _loc8_;
            }
         }
         if(!checkBitmapCache(_loc6_))
         {
            _cache[_loc6_] = new BitmapData(param1,param2,true,param3);
         }
         return _cache[_loc6_];
      }
      
      public static function log(param1:Object) : void
      {
         if(_game != null && _game._console != null)
         {
            _game._console.log(param1 == null ? "ERROR: null object" : param1.toString());
         }
      }
      
      public static function checkBitmapCache(param1:String) : Boolean
      {
         return _cache[param1] != undefined && _cache[param1] != null;
      }
      
      internal static function updateSounds() : void
      {
         var _loc1_:FlxSound = null;
         if(music != null && music.active)
         {
            music.update();
         }
         var _loc2_:uint = sounds.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = sounds[_loc3_] as FlxSound;
            if(_loc1_ != null && _loc1_.active)
            {
               _loc1_.update();
            }
            _loc3_++;
         }
      }
      
      internal static function updateInput() : void
      {
         keys.update();
         mouse.update(state.mouseX,state.mouseY,scroll.x,scroll.y);
      }
      
      public static function OBF_1a12(param1:String, param2:Number = 1, param3:Boolean = false) : FlxSound
      {
         var _loc4_:uint = sounds.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            if(!(sounds[_loc5_] as FlxSound).active)
            {
               break;
            }
            _loc5_++;
         }
         if(sounds[_loc5_] == null)
         {
            sounds[_loc5_] = new FlxSound();
         }
         var _loc6_:FlxSound = sounds[_loc5_];
         _loc6_.OBF_1d06(param1,param3);
         _loc6_.volume = param2;
         _loc6_.play();
         return _loc6_;
      }
      
      internal static function unfollow() : void
      {
         followTarget = null;
         followLead = null;
         followLerp = 1;
         followMin = null;
         followMax = null;
         if(scroll != null)
         {
            scroll.x = scroll.y = 0;
         }
         else
         {
            scroll = new Point();
         }
         if(_scrollTarget != null)
         {
            _scrollTarget.x = _scrollTarget.y = 0;
         }
         else
         {
            _scrollTarget = new Point();
         }
      }
      
      public static function get state() : FlxState
      {
         return _game._state;
      }
      
      protected static function OBF_1b1a() : void
      {
         var _loc1_:FlxSound = null;
         if(music != null && music.active)
         {
            music.play();
         }
         var _loc2_:uint = sounds.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = sounds[_loc3_] as FlxSound;
            if(_loc1_ != null && _loc1_.active)
            {
               _loc1_.play();
            }
            _loc3_++;
         }
      }
      
      public static function followAdjust(param1:Number = 0, param2:Number = 0) : void
      {
         followLead = new Point(param1,param2);
      }
      
      public static function follow(param1:FlxObject, param2:Number = 1) : void
      {
         followTarget = param1;
         followLerp = param2;
         _scrollTarget.x = (width >> 1) - followTarget.x - (followTarget.width >> 1) + (followTarget as FlxSprite).offset.x;
         _scrollTarget.y = (height >> 1) - followTarget.y - (followTarget.height >> 1) + (followTarget as FlxSprite).offset.y;
         scroll.x = _scrollTarget.x;
         scroll.y = _scrollTarget.y;
         doFollow();
      }
      
      public static function resetInput() : void
      {
         keys.reset();
         mouse.reset();
      }
      
      public static function followBounds(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = true) : void
      {
         followMin = new Point(-param1,-param2);
         followMax = new Point(-param3 + width,-param4 + height);
         if(followMax.x > followMin.x)
         {
            followMax.x = followMin.x;
         }
         if(followMax.y > followMin.y)
         {
            followMax.y = followMin.y;
         }
         if(param5)
         {
            FlxU.setWorldBounds(-param1,-param2,-param1 + param3,-param2 + param4);
         }
         doFollow();
      }
      
      protected static function OBF_1c01() : void
      {
         var _loc1_:FlxSound = null;
         if(music != null && music.active)
         {
            music.pause();
         }
         var _loc2_:uint = sounds.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = sounds[_loc3_] as FlxSound;
            if(_loc1_ != null && _loc1_.active)
            {
               _loc1_.pause();
            }
            _loc3_++;
         }
      }
      
      internal static function destroySounds(param1:Boolean = false) : void
      {
         var _loc2_:FlxSound = null;
         if(sounds == null)
         {
            return;
         }
         if(music != null && (param1 || !music.survive))
         {
            music.destroy();
         }
         var _loc3_:uint = sounds.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = sounds[_loc4_] as FlxSound;
            if(_loc2_ != null && (param1 || !_loc2_.survive))
            {
               _loc2_.destroy();
            }
            _loc4_++;
         }
      }
      
      public static function set pause(param1:Boolean) : void
      {
         var _loc2_:Boolean = _pause;
         _pause = param1;
         if(_pause != _loc2_)
         {
            if(_pause && superPause)
            {
               _game.OBF_1c02();
               OBF_1c01();
            }
            else
            {
               _game.OBF_1a0a();
               OBF_1b1a();
            }
         }
      }
      
      public static function get pause() : Boolean
      {
         return _pause;
      }
   }
}

