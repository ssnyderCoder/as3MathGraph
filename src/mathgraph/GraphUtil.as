package mathgraph 
{
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GraphUtil 
	{
		
		//checks if a graph is made up of 1 or more trees and has no cycles
		public static function isForestGraph(graph:BasicGraph):Boolean {
			//initializations
			var visited:Array = new Array();
			var previous:Array = new Array();
			const nodeUnVisited:int = 0;
			const nodeVisited:int = 1;
			var nodes:Array = graph.getAllNodes();
			for (var i:int = 0; i < nodes.length; i++) 
			{
				var node:int = nodes[i];
				visited[node] = nodeUnVisited;
				previous[node] = -1;
			}
			var currentNode:int = nodes[0];
			previous[currentNode] = -1; //tree start node
			
			while (currentNode != -1) {
				//visit all neighbors
				var neighbors:Array = graph.neighbors(currentNode, false);
				for each (var neighbor:int in neighbors) 
				{
					if(previous[currentNode] == neighbor && !graph.hasDirectionalEdges){
						continue;
					}
					else if(previous[neighbor] == -1 && (visited[neighbor] == nodeUnVisited || previous[currentNode] == -1)){
						previous[neighbor] = currentNode;
					}
					else {
						return false;
					}
				}
				visited[currentNode] = nodeVisited;
				
				//repeat loop with a node that has been unvisited (and has previous node, if any)
				var nextNode:int = -1;
				var isStartNode:Boolean = true;
				for (var j:int = 0; j < visited.length; j++) 
				{
					if (visited[j] == nodeUnVisited) {
						if (previous[j] != -1) {
							nextNode = j;
							isStartNode = false;
						}
						else if(nextNode == -1){
							nextNode = j;
						}
					}
				}
				currentNode = nextNode;
				if (isStartNode && currentNode != -1) {
					previous[currentNode] = -1;
				}
			}
			
			return true;
		}
		
		/**
		 * Finds the shortest path along edges from node A to node B (Dijkstra algorithm).
		 * @param	graph The BasicGraph to find the path in.
		 * @param	nodeA starting node
		 * @param	nodeB ending node
		 * @param	shortestEdges Applies only if quivers permitted in graph.  If true, the shortest edges are always considered for thr pathfinding, otherwise valid edges are chosen at random, which can randomly result in paths being longer.
		 * @return this path as an array of nodes, or null if no such path exists.
		 */
		public static function findShortestPath(graph:BasicGraph, nodeA:int, nodeB:int, shortestEdges:Boolean=true):Array {
			if (!graph.hasNode(nodeA) || !graph.hasNode(nodeB)) {
				return null;
			}
			
			//initializations
			var distances:Array = new Array();
			var visited:Array = new Array();
			var previous:Array = new Array();
			const nodeUnVisited:int = 0;
			const nodeVisited:int = 1;
			var nodes:Array = graph.getAllNodes();
			for (var i:int = 0; i < nodes.length; i++) 
			{
				var node:int = nodes[i];
				visited[node] = nodeUnVisited;
				distances[node] = int.MAX_VALUE;
				previous[node] = -1;
			}
			var currentNode:int = nodeA;
			distances[currentNode] = 0;
			
			while (currentNode != -1) {
				//calculate distances for all neighbors
				var neighbors:Array = graph.neighbors(currentNode);
				for each (var neighbor:int in neighbors) 
				{
					var newDistance:int = distances[currentNode] + graph.getWeight(currentNode, neighbor, shortestEdges);
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
		
		
	}

}