package mathgraph 
{
	/**
	 * A mathematics graph that is able to have weighted edges
	 * @author Sean Snyder
	 */
	public class WeightedGraph extends BasicGraph
	{
		//each index of this array represents a node, and contains an array of the weights for its edges
		private var weightedList:Array; //ex: [ [50, 90], [120, 70], undefined, [45, 125], []]
		
		public function WeightedGraph(allowLoops:Boolean=false, allowDirectedEdges:Boolean=false, allowQuiverEdges:Boolean=false) 
		{
			super(allowLoops, allowDirectedEdges, allowQuiverEdges);
		}
		
		//addEdge calls addWeightedEdge with default weight of 1
		override public function addEdge(nodeA:int, nodeB:int):Boolean 
		{
			return addWeightedEdge(nodeA, nodeB, 1);
		}
		
		public function addWeightedEdge(nodeA:int, nodeB:int, weight:int):Boolean
		{
			var success:Boolean = super.addEdge(nodeA, nodeB);
			if (success) {
				var wList:Array = weightedList[nodeA];
				wList.push(weight);
				return true;
			}
			else return false;
		}
		//addWeightedEdge(nodeA, nodeB, weight:int) :allows loops and multiple edges
		//removeEdge finds first valid edge from A to B to remove and calls removeWeightedEdge
		//removeWeightedEdge :removes the edge from A to B that is the specified weight
		
		//getWeight returns randomly chosen edge's actual weight from node A to node B 
		//edgesDirectional and related methods return true
	}

}