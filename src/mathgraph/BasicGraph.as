package mathgraph 
{
	/**
	 * A data structure that represents a simple mathematics graph.  It contains a set of nodes connected by edges. 
	 * Edges are undirected with no weights associated with them.  Pairs of nodes can have only 1 edge between them.
	 * Nodes may not have loops (edges connecting a node to itself).
	 * @author Sean Snyder
	 */
	public class BasicGraph 
	{
		//each index of this array represents a node, and contains an array of the index values of adjacent nodes
		protected var adjacencyList:Array; //ex: [ [1,3], [0,1], undefined, [0,1], []]
		
		protected var numNodes:int = 0;
		protected var numEdges:int = 0;
		
		public function BasicGraph() 
		{
			adjacencyList = new Array();
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
				//remove this node from neighbors' adjacency lists
				//if directed graph, remove this node from another other node's adjacency list TODO
				for each (var adjNode:int in adjList) 
				{
					removeEdge(node, adjNode);
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
			if (nodeA == nodeB && !canHaveLoops()) {
				return false;
			}
			else {
				var adjListA:Array = adjacencyList[nodeA];
				var adjListB:Array = adjacencyList[nodeB];
				if (adjListA == null || adjListB == null ||
					(!allowsQuivers() && (adjListA.indexOf(nodeB) != -1 || adjListB.indexOf(nodeA) != -1))) {
					return false;
				}
				adjListA.push(nodeB);
				if (!hasDirectionalEdges() && nodeA != nodeB) {
					adjListB.push(nodeA);
				}
				numEdges++;
				return true;
			}
		}
		
		//remove an edge between 2 nodes
		public function removeEdge(nodeA:int, nodeB:int):Boolean {
			if (nodeA == nodeB) {
				return false;
			}
			var adjListA:Array = adjacencyList[nodeA];
			var adjListB:Array = adjacencyList[nodeB];
			if (adjListA == null || adjListB == null) {
				return false;
			}
			var nodeAIndex:int = adjListB.indexOf(nodeA);
			var nodeBIndex:int = adjListA.indexOf(nodeB);
			if (adjListA.indexOf(nodeB) == -1 || adjListB.indexOf(nodeA) == -1) {
				return false;
			}
			adjListA.splice(nodeBIndex, 1);
			adjListB.splice(nodeAIndex, 1);
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
			var adjListB:Array = adjacencyList[nodeB];
			return hasAdjacentNode(nodeB, adjListA) || hasAdjacentNode(nodeA, adjListB);
		}
		
		//finds the shortest path along edges from node A to node B (Dijkstra algorithm).
		//returns this path as an array of nodes, or null if no such path exists.
		public function findShortestPath(nodeA:int, nodeB:int):Array {
			if (!hasNode(nodeA) || !hasNode(nodeB)) {
				return null;
			}
			
			//initializations
			var distances:Array = new Array();
			var visited:Array = new Array();
			var previous:Array = new Array();
			const nodeUnVisited:int = 0;
			const nodeVisited:int = 1;
			for (var i:int = 0; i < adjacencyList.length; i++) 
			{
				if (adjacencyList[i] != null) {
					visited[i] = nodeUnVisited;
					distances[i] = int.MAX_VALUE;
					previous[i] = -1;
				}
			}
			var currentNode:int = nodeA;
			distances[currentNode] = 0;
			
			while (currentNode != -1) {
				//calculate distances for all neighbors
				for each (var neighbor:int in adjacencyList[currentNode]) 
				{
					var newDistance:int = distances[currentNode] + getWeight(currentNode, neighbor);
					var oldDistance:int = distances[neighbor];
					if (newDistance < oldDistance) {
						distances[neighbor] = newDistance;
						previous[neighbor] = currentNode;
					}
				}
				visited[currentNode] = nodeVisited;
				if (currentNode == nodeB) break;
				
				//repeat loop with lowest distance unvisited node
				var lowestNode:int = -1;
				var lowestNodeValue:int = int.MAX_VALUE - 1;
				for (var j:int = 0; j < visited.length; j++) 
				{
					if (visited[j] == nodeUnVisited && distances[j] < lowestNodeValue) {
						lowestNode = j;
						lowestNodeValue = distances[j];
					}
				}
				currentNode = lowestNode;
			}
			
			//create path from node A to node B
			if (previous[nodeB] == -1) { //no path from node A to B
				return null;
			}
			var path:Array = new Array();
			var pathNode:int = nodeB;
			while (pathNode != -1) {
				path.unshift(pathNode);
				pathNode = previous[pathNode];
			}
			
			return path;
		}
		
		protected function getWeight(nodeA:int, nodeB:int):int 
		{
			return 1;
		}
		
		protected function canHaveLoops():Boolean
		{
			return false;
		}
		
		private function hasDirectionalEdges():Boolean 
		{
			return false;
		}
		
		protected function allowsQuivers():Boolean 
		{
			return false;
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