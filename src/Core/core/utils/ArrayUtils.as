package core.utils
{
  public final class ArrayUtils
  {
    /**
    * Retrieve an array ranging "FROM" - "TO" with a specified "STEP"
    * */
    public static function numericRange(from:int = 0, to:int = 0, step:int = 1):Array
    {
      var temp:Array = new Array();
      for (var i:int = from; i <= to; i += step) temp.push(i);
      
      return temp;
    }
    
    
    public static function shuffleArray(source:Array):Array
    {
      var temp:Array = new Array();
      var target:Array = source.concat();
      var sourceLength:int = source.length;
      var randomID:int;
      
      for (var i:int = 0; i < sourceLength; i++)
      {
        randomID = Math.floor(Math.random() * sourceLength);
        temp.push(source[randomID]);
        target.splice(randomID, 1);
      }
      
      return temp;
    }
    
    
    
    public static function removeDuplicateArrayElements(arr:Array):Array
    {
      return arr.filter(filterDuplicates);
    }
    
    private static function filterDuplicates(e:*, i:int, a:Array):Boolean { return a.indexOf(e) == i; }
  }
}