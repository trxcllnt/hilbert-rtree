package trxcllnt.ds
{
	import flash.geom.Rectangle;

	public function rectangleHilbertValue(r:Rectangle):uint
	{
		return HILBERT.index(centroid(r));
	}
}

import com.nodename.math.spaceFillingCurve.Hilbert;

internal const HILBERT:Hilbert = new Hilbert(2, 16);