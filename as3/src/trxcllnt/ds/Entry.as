package trxcllnt.ds
{
	import flash.geom.Rectangle;

	public interface Entry
	{
		function get hilbertValue():uint;
		function get boundingBox():Rectangle;
		function set parent(p:HRNonLeaf):void;
	}
}