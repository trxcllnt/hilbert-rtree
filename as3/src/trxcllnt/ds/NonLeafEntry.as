package trxcllnt.ds
{
	import asx.array.last;
	import asx.array.map;
	import asx.array.reduce;
	import asx.fn._;
	
	import flash.geom.Rectangle;

	internal class NonLeafEntry implements Entry
	{
		private var _boundingBox:Rectangle;
		public function get boundingBox():Rectangle { return _boundingBox; }
		
		private var _child:HRNode;
		internal function get child():HRNode { return _child; }
		
		public function set parent(p:HRNonLeaf):void { _child.parent = p; }
		
		private var _largestHilbertValue:uint;
		public function get hilbertValue():uint { return _largestHilbertValue; }
		
		public function NonLeafEntry(child:HRNode)
		{
			_child = child;
			adjustHilbertValue();
		}
		
		internal function adjustBoundingRectangle():void
		{
			const rectangles:Array = map(_child.entries, function(e:Entry):Rectangle { return e.boundingBox; });
			_boundingBox = reduce(_, rectangles, mergeBoundingRectangle) as Rectangle;
		}
		
		internal function adjustHilbertValue():void
		{
			if (_child.entries.length == 0)
			{
				return;
			}
			_largestHilbertValue = last(_child.entries).hilbertValue;
		}
		
		public function toString():String
		{
			return "[Entry " /*+ _minBoundingRectangle.toString() + " "*/ + _largestHilbertValue + ": " + _child.toString() + "]";
		}
	}
}