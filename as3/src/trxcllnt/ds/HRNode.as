package trxcllnt.ds
{
	import asx.array.detect;
	import asx.array.filter;
	import asx.array.last;
	import asx.array.map;
	import asx.array.reduce;
	import asx.fn._;
	
	import flash.geom.Rectangle;

	internal class HRNode
	{
		public static const EMPTY_RECTANGLE:Rectangle = new Rectangle();
		
		protected var _minBoundingRectangle:Rectangle;
		public function get mbr():Rectangle { return _minBoundingRectangle; }
		
		protected var _entries:Array;
		public function get entries():Array { return _entries; }
		public function set entries(newEntries:Array):void
		{
			_entries = newEntries;
			for each (var entry:Entry in newEntries)
			{
				entry.parent = this as HRNonLeaf;
			}
			adjustNode();
		}
		
		public function get hilbertValue():uint { return (last(_entries) as Entry).hilbertValue; }
		
		public var parent:HRNonLeaf;
		
		public function HRNode(parent:HRNonLeaf=null)
		{
			this.parent = parent;
			_entries = [];
			_minBoundingRectangle = EMPTY_RECTANGLE;
		}
		
		public function search(r:Rectangle):Array
		{
			throw "Override!";
			return [];
		}
		
		internal function get overflowSiblings():Array
		{
			// here we assume the 2-to-3 splitting policy, which means just one cooperating sibling
			const nbor:HRNode = getRightNeighbor();
			return nbor ? [nbor] : [];
		}
		
		internal function get underflowSiblings():Array
		{
			// 2-to-3 policy says two cooperating nodes for underflow
			const rNeighbor:HRNode = getRightNeighbor();
			const lNeighbor:HRNode = getLeftNeighbor();
			var result:Array = [];
			if (lNeighbor)
			{
				result.push(lNeighbor);
			}
			if (rNeighbor)
			{
				result.push(rNeighbor);
			}
			return result;
		}
		
		internal function get indexInParent():uint
		{
			const self:HRNode = this;
			const parentEntries:Array = parent.entries;
			const entryContainingMe:NonLeafEntry = detect(parentEntries, function(e:NonLeafEntry):Boolean { return e.child == self; }) as NonLeafEntry;
			if (entryContainingMe == null)
			{
				throw new Error("can't find correct entry for node");
			}
			return parentEntries.indexOf(entryContainingMe);
		}
		
		private function getRightNeighbor():HRNode
		{
			return getNeighbor(1);
		}
		
		private function getLeftNeighbor():HRNode
		{
			return getNeighbor(-1);
		}
		
		private function getNeighbor(displacement:int):HRNode
		{
			if (parent == null)
			{
				return null;
			}
			const neighborEntry:NonLeafEntry = parent.entries[indexInParent + displacement];
			return neighborEntry ? neighborEntry.child : null;
		}	
		
		internal function adjustNode():void
		{
			const rectangles:Array = map(entries, function(e:Entry):Rectangle { return e.boundingBox; });
			_minBoundingRectangle = reduce(EMPTY_RECTANGLE, rectangles, mergeBoundingRectangle) as Rectangle;
		}
		
		internal function get isFull():Boolean
		{
			throw("Override!");
		}
		
		internal function get isEmpty():Boolean
		{
			return _entries.length == 0;
		}
		
		public function toString():String
		{
			throw("Override!");
		}
	}
}