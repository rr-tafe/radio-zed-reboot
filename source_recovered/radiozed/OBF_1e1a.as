package
{
   import mx.resources.ResourceBundle;
   
   public class OBF_1e1a extends ResourceBundle
   {
      
      public function OBF_1e1a()
      {
         super("en_US","skins");
      }
      
      override protected function getContent() : Object
      {
         return {"notLoaded":"Unable to load \'{0}\'."};
      }
   }
}

