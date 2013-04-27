package trxcllnt.ds
{
	public function hilbertSortOrder(a:Object, b:Object):int
	{
		if (a.hilbertValue < b.hilbertValue)
		{
			return -1;
		}
		else if (a.hilbertValue > b.hilbertValue)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}