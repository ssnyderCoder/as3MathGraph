package mathgraph 
{
	/**
	 * A basic graph that is prevented from having cycles.  Any attempt to add an edge that would create a cycle fails.
	 * @author Sean Snyder
	 */
	public class BasicTree extends BasicGraph 
	{
		
		public function BasicTree() 
		{
			super();
		}
		
		override public function addEdge(nodeA:int, nodeB:int):Boolean 
		{
			var hasPath:Boolean = super.findShortestPath(nodeA, nodeB) != null;
			if (hasPath) {
				return false;
			}
			else {
				return super.addEdge(nodeA, nodeB);
			}
		}
	}

}