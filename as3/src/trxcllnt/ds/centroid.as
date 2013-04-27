package trxcllnt.ds
{
	/**
	 * @author alan
	 */
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public function centroid(r:Rectangle):Vector.<Number>
	{
		return new <Number>[r.left + r.width/2, r.top + r.height/2];
	}
}