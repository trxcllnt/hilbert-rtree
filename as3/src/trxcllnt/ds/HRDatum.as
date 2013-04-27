package trxcllnt.ds
{
	import flash.geom.Rectangle;

	public class HRDatum
	{
		public var boundingBox:Rectangle;
		public var item:*;
		
		public function HRDatum(r:Rectangle, d:*=null)
		{
			boundingBox = r;
			item = d;
		}
		
		public function equals(other:HRDatum):Boolean
		{
			return boundingBox.equals(other.boundingBox) && item == other.item;
		}
		
		public function toString():String
		{
			return "[" + item + " " + boundingBox + "]";
		}
	}
}