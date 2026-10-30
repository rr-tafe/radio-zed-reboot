package
{
   import mx.resources.ResourceBundle;
   
   public class OBF_1e1b extends ResourceBundle
   {
      
      public function OBF_1e1b()
      {
         super("en_US","core");
      }
      
      override protected function getContent() : Object
      {
         return {
            "multipleChildSets_ClassAndInstance":"Multiple sets of visual children have been specified for this component (component definition and component instance).",
            "truncationIndicator":"...",
            "notExecuting":"Repeater is not executing.",
            "versionAlreadyRead":"Compatibility version has already been read.",
            "multipleChildSets_ClassAndSubclass":"Multiple sets of visual children have been specified for this component (base component definition and derived component definition).",
            "viewSource":"View Source",
            "badFile":"File does not exist.",
            "stateUndefined":"Undefined state \'{0}\'.",
            "versionAlreadySet":"Compatibility version has already been set."
         };
      }
   }
}

