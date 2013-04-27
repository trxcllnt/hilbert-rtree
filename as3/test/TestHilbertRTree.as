package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import trxcllnt.ds.HRDatum;
	import trxcllnt.ds.HRNonLeaf;
	import trxcllnt.ds.HRTree;
	
	[SWF(width = "1000", height = "8000")]
	public class TestHilbertRTree extends Sprite
	{
		private var _tree:HRTree;
		
		public function TestHilbertRTree()
		{
			_tree = new HRTree();
			
			const a:Rectangle = new Rectangle(3, 6, 5, 30);
			const b:Rectangle = new Rectangle(25, 34, 9, 4);
			const c:Rectangle = new Rectangle(33, 21, 4, 15);
			const d:Rectangle = new Rectangle(21, 23, 17, 4);
			const e:Rectangle = new Rectangle(6, 3, 20, 5);
			const f:Rectangle = new Rectangle(31, 15, 4, 4);
			const g:Rectangle = new Rectangle(23, 11, 15, 3);
			const h:Rectangle = new Rectangle(23, 25, 3, 11);
			const i:Rectangle = new Rectangle(27, 14.5, 8.5, 6);
			const j:Rectangle = new Rectangle(16, 3.5, 6, 4);
			
			trace(_tree);
			 _tree.insert(a, "a");
			trace(_tree);
			 _tree.insert(b, "b");
			trace(_tree);
			 _tree.insert(c, "c");
			trace(_tree);
			 _tree.insert(d, "d");
			trace(_tree);
			 _tree.insert(e, "e");
			trace(_tree);
			 _tree.insert(f, "f");
			trace(_tree);
			 _tree.insert(g, "g");
			trace(_tree);
			 _tree.insert(h, "h");
			trace(_tree);
			 _tree.insert(i, "i");
			trace(_tree);
			 _tree.insert(j, "j");
			trace(_tree);
			
			trace(_tree.search(d));	// should be d,h,c
			trace(_tree.search(b)); // should be b,h,c
			trace(_tree.search(g)); // should be g
			
			_tree.remove(j, "j");
			trace(_tree);
			_tree.remove(i, "i");
			trace(_tree);
			_tree.remove(h, "h");
			trace(_tree);
			_tree.remove(g, "g");
			trace(_tree);
			_tree.remove(f, "f");
			trace(_tree);
			_tree.remove(e, "e");
			trace(_tree);
			_tree.remove(d, "d");
			trace(_tree);
			_tree.remove(c, "c");
			trace(_tree);
			_tree.remove(b, "b");
			trace(_tree);
			_tree.remove(a, "a");
			trace(_tree);
			
			var success:Boolean = _tree.remove(a, "a");
			if (success == false)
			{
				trace("Not found");
			}
			trace(_tree);
			
			_tree.insert(a, "a");
			trace(_tree);
		}
	}
}