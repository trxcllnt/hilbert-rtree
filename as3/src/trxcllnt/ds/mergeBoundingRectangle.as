package trxcllnt.ds
{
	import flash.geom.Rectangle;

	public function mergeBoundingRectangle(rect0:Rectangle, rect1:Rectangle):Rectangle
	{
		if (rect0 == HRNode.EMPTY_RECTANGLE)
		{
			return rect1.clone();
		}
		
		var merged:Rectangle = new Rectangle();
		merged.x = Math.min(rect0.x, rect1.x);
		const right:Number = Math.max(rect0.right, rect1.right);
		merged.width = right - merged.x;
		
		merged.y = Math.min(rect0.y, rect1.y);
		const bottom:Number = Math.max(rect0.bottom, rect1.bottom);
		merged.height = bottom - merged.y;
	
		return merged;
	}
}