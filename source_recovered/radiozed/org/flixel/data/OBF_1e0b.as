package org.flixel.data
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class OBF_1e0b extends Sprite
   {
      
      public var API:*;
      
      public function OBF_1e0b()
      {
         super();
         this.API = null;
      }
      
      public function OBF_1d0e() : void
      {
         var _loc1_:Object = LoaderInfo(root.loaderInfo).parameters;
         var _loc2_:String = _loc1_.api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         var _loc4_:Loader = new Loader();
         _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.OBF_19);
         _loc4_.load(_loc3_);
         this.addChild(_loc4_);
      }
      
      protected function OBF_19(param1:Event) : void
      {
         this.API = param1.target.content;
         this.API.services.connect();
      }
   }
}

