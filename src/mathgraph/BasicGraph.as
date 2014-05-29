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
			weightedList = new Array();
			
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
				weightedList[node] = new Array();
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
					weightedList.pop();
				}
				else {
					adjacencyList[node] = null;
					weightedList[node] = null;
				}
				numNodes--;
				return true;
			}
			return false;
			
		}
		
		//add an edge between 2 nodes
		public function addEdge(nodeA:int, nodeB:int, weight:int=1):Boolean {
			if (nodeA == nodeB && !allowsLoops) {
				return false;
			}
			else if (weight < 0) { //invalid weight: must be positive
				return false;
			}
			else {
				var adjListA:Array = adjacencyList[nodeA];
				var adjListB:Array = adjacencyList[nodeB];
				var weightListA:Array = weightedList[nodeA];
				var weightListB:Array = weightedList[nodeB];
				if (adjListA == null || adjListB == null || (!allowsQuivers && adjListA.indexOf(nodeB) != -1)) {
					return false;
				}
				adjListA.push(nodeB);
				weightListA.push(weight);
				if (!hasDirectionalEdges && nodeA != nodeB) {
					if (!allowsQuivers && adjListB.indexOf(nodeA) != -1) {
						return false;
					}
					adjListB.push(nodeA);
					weightListB.push(weight);
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
			var weightListA:Array = weightedList[nodeA];
			if (adjListA == null) {
				return false;
			}
			
			var nodeBIndex:int = adjListA.indexOf(nodeB);
			if (nodeBIndex == -1) {
				return false;
			}
			adjListA.splice(nodeBIndex, 1);
			weightListA.splice(nodeBIndex, 1);
			if (!hasDirectionalEdges && nodeA != nodeB) {
				var adjListB:Array = adjacencyList[nodeB];
				var weightListB:Array = weightedList[nodeB];
				if (adjListB == null) {
					return false;
				}
				var nodeAIndex:int = adjListB.indexOf(nodeA);
				if (nodeAIndex == -1) {
					return false;
				}
				adjListB.splice(nodeAIndex, 1);
				weightListB.splice(nodeAIndex, 1);
			}
			numEdges--;
			return true;
		}
		
		//returns an array containing all adjacent nodes
		/**
		 * Returns a list of nodes that are adjacent to the specified node.
		 * @param	node any nodes adjacent to this node will be provided
		 * @param	exclusive Applies only if quivers are enabled; If true, adjacent nodes appear only once in the list.
		 * @return an array containing all adjacent nodes
		 */
		public function neighbors(node:int, exclusive:Boolean=true):Array {
			if (exclusive && allowsQuivers) {
				var exclNodes:Array = new Array();
				var exclAdjList:Array = new Array();
				for each (var node:int in adjacencyList[node]) 
				{
					if (exclNodes[node] == null) {
						exclAdjList.push(node);
						exclNodes[node] = 0;
					}
				}
				return exclAdjList;
			}
			else {
				var adjList:Array = adjacencyList[node];
				return adjList == null ? null : adjList.concat();
			}
		}
		
		//tests whether there is an edge between 2 nodes
		public function adjacent(nodeA:int, nodeB:int):Boolean {
			var adjListA:Array = adjacencyList[nodeA];
			return hasAdjacentNode(nodeB, adjListA);
		}
		
		/**
		 * Gets the weight of an edge between 2 nodes.
		 * If the Graph has directional edges, only the edges from the starting node to the ending node will be considered.
		 * @param	nodeA starting node
		 * @param	nodeB ending node
		 * @param	shortest Only applies if quivers are allowed.  If true, always choose the shortest edge, otherwise choose any valid edge at random.
		 * @return the weight of an edge, or -1 if that edge does not exist.
		 */
		public function getWeight(nodeA:int, nodeB:int, shortest:Boolean=true):int 
		{
			var weights:Array = new Array();
			
			var currentIndex:int = 0;
			var adjListA:Array = adjacencyList[nodeA];
			var weightListA:Array = weightedList[nodeA];
			while (currentIndex != -1 && currentIndex < adjListA.length) {
				currentIndex = adjListA.indexOf(nodeB, currentIndex);
				if (currentIndex != -1) {
					weights.push(weightListA[currentIndex]);
					currentIndex++;
				}
			}
			
			if (weights.length == 0) return -1;
			else if (shortest) {
				var shortestWeight:int = int.MAX_VALUE;
				for each (var weight:int in weights) 
				{
					if (weight < shortestWeight) shortestWeight = weight;
				}
				return shortestWeight;
			}
			else {
				var randomIndex:int = Math.floor(Math.random() * weights.length)
				return weights[randomIndex];
			}
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