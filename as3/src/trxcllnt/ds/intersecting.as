package trxcllnt.ds
{
	import flash.geom.Rectangle;

	public function intersecting(rect0:Rectangle, rect1:Rectangle):Boolean
	{
		return rect0.left < rect1.right
			&& rect0.right > rect1.left
			&& rect0.bottom > rect1.top
			&& rect0.top < rect1.bottom;
	}
}