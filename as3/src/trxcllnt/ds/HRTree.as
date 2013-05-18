package trxcllnt.ds
{
	import asx.array.detect;
	
	import flash.geom.Rectangle;

	public class HRTree
	{
		private var _root:HRNonLeaf;
		
		public function HRTree()
		{
			_root = new HRNonLeaf().makeRoot();
		}
		
		public function get mbr():Rectangle { return _root.mbr; }
		
		private var data:Array = [];
		public function hasItem(item:*):Boolean {
			return find(item) != null;
		}
		
		public function find(item:*):HRDatum {
			if(item == null) return null;
			
			return detect(data, function(d:HRDatum):Boolean {
				return d.item == item;
			}) as HRDatum;
		}
		
		public function getBounds(item:*):Rectangle {
			if(item == null) return null;
			
			return find(item).boundingBox.clone();
		}
		
		public function insert(r:Rectangle, item:* = null):HRTree
		{
			const datum:HRDatum = new HRDatum(r, item);
			data.push(datum);
			_root = _root.insert(datum);
			
			return this;
		}
		
		public function update(newSize:Rectangle, item:*):HRTree {
			const d:HRDatum = find(item);
			
			if(d != null) {
				
				if(newSize.equals(d.boundingBox)) return this;
				
				remove(d.boundingBox, item);
			}
			
			return insert(newSize, item);
		}
		
		public function search(r:Rectangle):Array
		{
			return _root.search(r);
		}
		
		public function remove(r:Rectangle, item:* = null):Boolean
		{
			const datum:HRDatum = find(item) || new HRDatum(r, item);
			
			if(hasItem(item)) data.splice(data.indexOf(find(item)), 1);
			
			return _root.remove(datum);
		}
		
		public function toString():String
		{
			return _root.toString();
		}
	}
}