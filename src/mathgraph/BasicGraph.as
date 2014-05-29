package mathgraph 
{
	/**
	 * A data structure that represents a simple mathematics graph.  It contains a set of nodes connected by edges. 
	 * Edges are either undirected or directed, but have no weights associated with them.
	 * Pairs of nodes can be permitted to either allow only 1 edge between them, or multiple edges.
	 * Nodes may have loops if allowed (edges connecting a node to itself).
	 * @author Sean Snyder
	 */
	public class BasicGraph 
	{
		//each index of this array represents a node, and contains an array of the index values of adjacent nodes
		protected var adjacencyList:Array; //ex: [ [1,3], [0,1], undefined, [0,1], []]
		
		//each index of this array represents a node, and contains an array of the weights for its edges
		private var weightedList:Array; //ex: [ [50, 90], [120, 70], undefined, [45, 125], []]
		
		protected var numNodes:int = 0;
		protected var numEdges:int = 0;
		
		private var _allowLoops:Boolean;
		private var _allowDirectedEdges:Boolean;
		private var _allowQuiverEdges:Boolean;
		
		public function BasicGraph(allowLoops:Boolean=false, allowDirectedEdges:Boolean=false, allowQuiverEdges:Boolean=false) 
		{
			adjacencyList = new Array();
			
			_allowLoops = allowLoops;
			_allowDirectedEdges = allowDirectedEdges;
			_allowQuiverEdges = allowQuiverEdges;
			
		}
		
		//returns an array containing the indexes of all loaded nodes
		public function getAllNodes():Array {
			var nodes:Array = new Array();
			for (var i:int = 0; i < adjacencyList.length; i++) 
			{
				if (adjacencyList[i] != null) nodes.push(i);
			}
			return nodes;
		}
		
		public function totalNodes():int 
		{
			return numNodes;
		}
		
		public function totalEdges():int 
		{
			return numEdges;
		}
		
		//returns how many edges a node has connected from it to other nodes, or -1 if the node doesnt exist
		public function numberEdges(node:int):int {
			var adjList:Array = adjacencyList[node];
			if (adjList == null) return -1;
			else return adjList.length;
		}
		
		//checks if a node exists in the graph
		public function hasNode(node:int):Boolean {
			return adjacencyList[node] != null;
		}
		
		//adds a new node to the graph
		public function addNode(node:int):Boolean {
			if (node < 0) return false;
			if (node >= adjacencyList.length || adjacencyList[node] == null) {
				adjacencyList[node] = new Array();
				numNodes++;
				return true;
			}
			return false;
		}
		
		//removes a node from a graph
		public function removeNode(node:int):Boolean {
			var adjList:Array = adjacencyList[node];
			if (adjList != null) { 
				//remove this node from all other adjacency lists
				for (var adjNode:int = 0; adjNode < adjacencyList.length; adjNode++) 
				{
					if (!hasNode(adjNode)) {
						continue;
					}
					while (adjacent(adjNode, node)) {
						removeEdge(adjNode, node);
					}
				}
				//remove all edges from this node's adkacency list
				while (adjList.length > 0) {
					adjList.pop();
					numEdges--;
				}
				if (node == adjacencyList.length - 1) {
					adjacencyList.pop();
				}
				else {
					adjacencyList[node] = null;
				}
				numNodes--;
				return true;
			}
			return false;
			
		}
		
		//add an edge between 2 nodes
		public function addEdge(nodeA:int, nodeB:int):Boolean {
			if (nodeA == nodeB && !allowsLoops) {
				return false;
			}
			else {
				var adjListA:Array = adjacencyList[nodeA];
				var adjListB:Array = adjacencyList[nodeB];
				if (adjListA == null || adjListB == null || (!allowsQuivers && adjListA.indexOf(nodeB) != -1)) {
					return false;
				}
				adjListA.push(nodeB);
				if (!hasDirectionalEdges && nodeA != nodeB) {
					if (!allowsQuivers && adjListB.indexOf(nodeA) != -1) {
						return false;
					}
					adjListB.push(nodeA);
				}
				numEdges++;
				return true;
			}
		}
		
		//remove an edge between 2 nodes
		public function removeEdge(nodeA:int, nodeB:int):Boolean {
			if (nodeA == nodeB && !allowsLoops) {
				return false;
			}
			
			var adjListA:Array = adjacencyList[nodeA];
			if (adjListA == null) {
				return false;
			}
			
			var nodeBIndex:int = adjListA.indexOf(nodeB);
			if (nodeBIndex == -1) {
				return false;
			}
			adjListA.splice(nodeBIndex, 1);
			if (!hasDirectionalEdges && nodeA != nodeB) {
				var adjListB:Array = adjacencyList[nodeB];
				if (adjListB == null) {
					return false;
				}
				var nodeAIndex:int = adjListB.indexOf(nodeA);
				if (nodeAIndex == -1) {
					return false;
				}
				adjListB.splice(nodeAIndex, 1);
			}
			numEdges--;
			return true;
		}
		
		//returns an array containing all adjacent nodes
		public function neighbors(node:int):Array {
			return adjacencyList[node];
		}
		
		//tests whether there is an edge between 2 nodes
		public function adjacent(nodeA:int, nodeB:int):Boolean {
			var adjListA:Array = adjacencyList[nodeA];
			return hasAdjacentNode(nodeB, adjListA);
		}
		
		public function getWeight(nodeA:int, nodeB:int):int 
		{
			return 1;
		}
		
		public function get allowsLoops():Boolean
		{
			return _allowLoops
		}
		
		public function get hasDirectionalEdges():Boolean 
		{
			return _allowDirectedEdges;
		}
		
		public function get allowsQuivers():Boolean 
		{
			return _allowQuiverEdges;
		}
		
		//tests whether a node is found in a list of adjacent nodes
		private function hasAdjacentNode(node:int, adjList:Array):Boolean {
			if (adjList == null || adjList.length == 0) {
				return false;
			}
			for each (var adjNode:int in adjList) 
			{
				if (adjNode == node) {
					return true;
				}
			}
			return false;
		}
	}

}