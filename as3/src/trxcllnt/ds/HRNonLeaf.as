package trxcllnt.ds
{
	import asx.array.detect;
	import asx.array.filter;
	import asx.array.flatten;
	import asx.array.inGroupsOf;
	import asx.array.last;
	import asx.array.map;
	import asx.array.reduce;
	import asx.array.reject;
	import asx.array.some;
	
	import flash.geom.Rectangle;
	
	internal class HRNonLeaf extends HRNode
	{
		private static const NON_LEAF_CAPACITY:uint = 3;
		
		public function HRNonLeaf(parent:HRNonLeaf=null)
		{
			super(parent);
		}
		
		// initialize a tree with me as the root
		internal function makeRoot():HRNonLeaf
		{
			const leaf:HRNode = new HRLeaf(this);
			const newEntry:NonLeafEntry = new NonLeafEntry(leaf);
			_entries.push(newEntry);
			return this;
		}
		
		public override function search(r:Rectangle):Array
		{
			const nodesToSearch:Array = map(filter(_entries, intersects_r), function(e:NonLeafEntry):HRNode { return e.child; });
			return flatten(map(nodesToSearch, function(node:HRNode):Array { return node.search(r); }));
			
			function intersects_r(e:NonLeafEntry):Boolean { return intersecting(e.boundingBox, r); }
		}
		
		internal function insert(datum:HRDatum):HRNonLeaf
		{
			const h:uint = rectangleHilbertValue(datum.boundingBox);
			
			var newLeaf:HRLeaf = null;
			const leaf:HRLeaf = chooseLeaf(this, h);
			if (leaf.isFull)
			{
				newLeaf = handleOverflow(leaf, new LeafEntry(datum)) as HRLeaf;
			}
			else
			{
				leaf.insert(datum);
			}
			
			return adjustTree(leaf, newLeaf);
			
			function chooseLeaf(root:HRNonLeaf, h:uint):HRLeaf
			{
				var n:HRNode = root;
				while ((n is HRLeaf) == false)
				{
					n = chooseSubtree(n, h);
				}
				return n as HRLeaf;
				
				function chooseSubtree(n:HRNonLeaf, h:uint):HRNode
				{
					const firstentryGreaterThanH:NonLeafEntry =
						detect(n._entries, function(entry:NonLeafEntry):Boolean { return entry.hilbertValue > h; }) as NonLeafEntry;
					return firstentryGreaterThanH ? firstentryGreaterThanH.child : last(n._entries).child;
				}
			}
		}
		
		public function remove(datum:HRDatum):Boolean
		{
			const h:uint = rectangleHilbertValue(datum.boundingBox);
			const leaf:HRLeaf = findLeaf(this, h);
			if (leaf == null)
			{
				return false;
			}
			leaf.remove(datum);
			if (leaf.isEmpty)
			{
				handleUnderflow(leaf);
			}
			adjustTree(leaf, null);
			return true;
			
			function findLeaf(root:HRNonLeaf, h:uint):HRLeaf
			{
				var n:HRNode = root;
				while (n && !(n is HRLeaf))
				{
					n = findSubtree(n, h);
				}
				return n as HRLeaf;
				
				function findSubtree(n:HRNonLeaf, h:uint):HRNode
				{
					const entryContainingH:NonLeafEntry =
						detect(n._entries, function(entry:NonLeafEntry):Boolean { return entry.hilbertValue >= h; }) as NonLeafEntry;
					return entryContainingH ? entryContainingH.child : null;
				}
			}
		}
		
		internal function removeNode(n:HRNode):void
		{
			const newEntries:Array = reject(_entries, function(e:NonLeafEntry):Boolean { return e.child == n; });
			_entries = newEntries;
			adjustNode();
		}
		
		private static function adjustTree(nodeBeingUpdated:HRNode, newlyCreatedNode:HRNode):HRNonLeaf
		{
			const parent:HRNonLeaf = nodeBeingUpdated.parent;
			if (parent == null)
			{
				if (newlyCreatedNode)
				{
					const newRoot:HRNonLeaf = new HRNonLeaf();
					newRoot.entries = [new NonLeafEntry(nodeBeingUpdated), new NonLeafEntry(newlyCreatedNode)];
					return newRoot;
				}
				else
				{
					const root:HRNonLeaf = nodeBeingUpdated as HRNonLeaf;
					return root.isEmpty ? root.makeRoot() : root;
				}
			}
			
			if (nodeBeingUpdated.isEmpty)
			{
				parent.removeNode(nodeBeingUpdated);
			}
			
			var newParent:HRNonLeaf = null;
			if (newlyCreatedNode)
			{
				if (parent.isFull)
				{
					newParent = handleOverflow(parent, new NonLeafEntry(newlyCreatedNode)) as HRNonLeaf;
					newParent.adjustNode();
				}
				else
				{
					parent.insertNodeAfter(newlyCreatedNode, nodeBeingUpdated);
				}
			}
			parent.adjustNode();
			
			return adjustTree(parent, newParent);
		}
		
		internal override function adjustNode():void
		{
			for each (var entry:NonLeafEntry in _entries)
			{
				entry.adjustBoundingRectangle();
				entry.adjustHilbertValue();
			}
			// this sort is necessary after a deletion because we don't know the proper order for the entries until their child nodes have had their own entries distributed:
			_entries.sort(hilbertSortOrder);
			super.adjustNode();
		}
		
		internal function insertNodeAfter(newNode:HRNode, precedingNode:HRNode):void
		{
			_entries.splice(precedingNode.indexInParent + 1, 0, new NonLeafEntry(newNode));
			newNode.parent = this;
		}
		
		private static function handleOverflow(overflowingNode:HRNode, entry:Entry):HRNode
		{
			const OverflowingNodeClass:Class = (overflowingNode as Object).constructor;
			
			const siblings:Array = overflowingNode.overflowSiblings;
			const allSiblingsFull:Boolean = ! some(siblings, function(n:HRNode):Boolean { return n.isFull == false; });
			const newNode:HRNode = allSiblingsFull ? new OverflowingNodeClass(null) : null;
			
			const allNodesInOrder:Array = [overflowingNode].concat(newNode ? newNode : []).concat(siblings);
			
			const siblingsEntries:Array = reduce([], siblings, function(acc:Array, sib:HRLeaf):Array { return acc.concat(sib.entries); }) as Array;
			const allEntriesInOrder:Array = overflowingNode.entries.concat(entry).concat(siblingsEntries);
			// technically this sort is not needed when siblings are in order to the right of overflowingNode,
			// but that depends on the splitting policy:
			allEntriesInOrder.sort(hilbertSortOrder);
			
			distributeEntries(allEntriesInOrder, allNodesInOrder);

			return newNode;
		}
		
		private static function handleUnderflow(underflowingNode:HRNode):void
		{
			const siblings:Array = underflowingNode.underflowSiblings;
			const allSiblingsReadyToUnderflow:Boolean = ! some(siblings, function(n:HRNode):Boolean { return n.entries.length > 1; });
			
			const allNodes:Array = siblings.concat(allSiblingsReadyToUnderflow ? [] : underflowingNode);
			
			const siblingsEntries:Array = reduce([], siblings, function(acc:Array, sib:HRLeaf):Array { return acc.concat(sib.entries); }) as Array;
			const allEntriesInOrder:Array = siblingsEntries;
			
			distributeEntries(allEntriesInOrder, allNodes);
		}
		
		private static function distributeEntries(entries:Array, nodes:Array):void
		{
			const entriesPerNode:uint = Math.ceil(entries.length/nodes.length);
			const entriesGroups:Array = inGroupsOf(entries, entriesPerNode);
			
			for (var i:uint = 0; i < nodes.length; i++)
			{
				var node:HRNode = nodes[i];
				node.entries = entriesGroups[i];
			}
		}
		
		internal override function get isFull():Boolean
		{
			return _entries.length == NON_LEAF_CAPACITY;
		}
		
		public override function toString():String
		{
			return "[Node " /*+ _minBoundingRectangle.toString()*/ + ": " + _entries.toString() + "]";
		}
	}
}
