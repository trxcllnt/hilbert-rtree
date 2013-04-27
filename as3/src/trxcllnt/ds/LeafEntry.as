package trxcllnt.ds
{
	import flash.geom.Rectangle;

	// this represents a single object in the problem space
	internal class LeafEntry implements Entry
	{
		private var _datum:HRDatum;
		public function get datum():HRDatum { return _datum; }
		public function get boundingBox():Rectangle { return _datum.boundingBox; }
		public function get description():* { return _datum.item; }
		
		public function set parent(p:HRNonLeaf):void { /* NOP */ }
		
		private var _hilbertValue:uint;
		public function get hilbertValue():uint { return _hilbertValue; }
		
		public function LeafEntry(datum:HRDatum)
		{
			_datum = datum;
			_hilbertValue = rectangleHilbertValue(boundingBox);
		}
		
		public function toString():String
		{
			return /*"[LeafEntry " + _minBoundingRectangle.toString() + " " +*/  "" + _hilbertValue /*+ "]"*/;
		}
	}
}