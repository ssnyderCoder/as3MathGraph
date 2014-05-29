package mathgraph 
{
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GraphUtil 
	{
		
		public static function isTreeGraph(graph:BasicGraph):Boolean {
			//path find for all nodes
			//if node checked more than once, return true
			return false;
		}
		
		//finds the shortest path along edges from node A to node B (Dijkstra algorithm).
		//returns this path as an array of nodes, or null if no such path exists.
		public static function findShortestPath(graph:BasicGraph, nodeA:int, nodeB:int):Array {
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
					var newDistance:int = distances[currentNode] + graph.getWeight(currentNode, neighbor);
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