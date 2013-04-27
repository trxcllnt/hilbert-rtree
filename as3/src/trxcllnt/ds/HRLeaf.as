package trxcllnt.ds
{
	import asx.array.filter;
	import asx.array.map;
	import asx.array.reject;
	
	import flash.geom.Rectangle;

	internal class HRLeaf extends HRNode
	{
		private static const LEAF_CAPACITY:uint = 3;

		public function HRLeaf(parent:HRNonLeaf=null)
		{
			super(parent);
		}
		
		public override function search(r:Rectangle):Array
		{
			return map(filter(_entries, intersects_r), function(e:LeafEntry):* { return e.datum; });
			
			function intersects_r(e:LeafEntry):Boolean { return intersecting(e.boundingBox, r); }
		}
		
		internal override function get isFull():Boolean
		{
			return _entries.length == LEAF_CAPACITY;
		}
		
		internal function insert(datum:HRDatum):void
		{
			_entries[_entries.length] = new LeafEntry(datum);
			_entries.sort(hilbertSortOrder);
			adjustNode();
		}
		
		internal function remove(datum:HRDatum):void
		{
			const newEntries:Array = reject(_entries, function(e:LeafEntry):Boolean { return e.datum.equals(datum); });
			_entries = newEntries;
			adjustNode();
		}
		
		public override function toString():String
		{
			return "[Leaf: " + _entries.toString() + "]";
		}
	}
}