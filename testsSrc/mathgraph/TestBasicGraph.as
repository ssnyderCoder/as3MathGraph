package mathgraph
{
	import asunit.framework.TestCase;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestBasicGraph extends TestCase
	{
		//Subtle, unexpected bugs caught thanks to unit testing: 2
		
		public function TestBasicGraph(testMethod:String = null)
		{
			super(testMethod);
		}
		
		public function getGraph(loops:Boolean=false, directedEdges:Boolean=false, quiverEdges:Boolean=false):BasicGraph {
			return new BasicGraph(loops, directedEdges, quiverEdges);	
		}
		
		public function testGraphAddNode():void
		{
			var testGraph:BasicGraph = getGraph();
			assertTrue("Node 0 wasnt added to Graph", testGraph.addNode(0));
			assertFalse("Node 0 was already added to Graph", testGraph.addNode(0));
			assertFalse("Node must be positive number", testGraph.addNode(-1));
		}
		
		public function testGraphHasNodes():void
		{
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			assertTrue("Node 0 not in Graph", testGraph.hasNode(0));
			assertTrue("Node 1 not in Graph", testGraph.hasNode(1));
		}
		
		public function testGraphNumNodesEdges():void
		{
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(6);
			testGraph.addNode(3);
			assertTrue("There should be 2 nodes in Graph", testGraph.totalNodes() == 2);
			assertTrue("There should be 0 edges in Graph", testGraph.totalEdges() == 0);
		}
		
		public function testGraphRemoveNode():void
		{
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			assertTrue("The node should have been removed", testGraph.removeNode(0));
			assertTrue("There should be 0 nodes in Graph", testGraph.totalNodes() == 0);
			assertFalse("The node should not have been removed again", testGraph.removeNode(0));
		}
		
		public function testGraphAddEdge():void
		{
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			
			assertTrue("Edge should have been added", testGraph.addEdge(0, 1));
			assertFalse("Cannot add edge again", testGraph.addEdge(0, 1));
			assertFalse("Cannot add edge from or to nonexistant node", testGraph.addEdge(0, 2));
			assertTrue("Node 1 and Node 0 should be neighbors", testGraph.adjacent(0, 1));
			assertTrue("Node 0 should have 1 neighbor: "+ testGraph.numberEdges(0), testGraph.numberEdges(0) == 1);
			assertTrue("Node 1 should have 1 neighbor: "+ testGraph.numberEdges(1), testGraph.numberEdges(1) == 1);
		}
		
		public function testGraphRemoveEdge():void
		{
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addEdge(0, 1);
			assertTrue("Edge should have been removed", testGraph.removeEdge(0, 1));
			assertFalse("Cannot remove edge again", testGraph.removeEdge(0, 1));
			assertFalse("Cannot remove edge from or to nonexistant node", testGraph.removeEdge(0, 2));
			assertFalse("Node 1 and Node 0 should not be neighbors", testGraph.adjacent(0, 1));
			assertTrue("Node 0 should have 0 neighbors", testGraph.numberEdges(0) == 0);
			assertTrue("Node 1 should have 0 neighbors", testGraph.numberEdges(1) == 0);
		}
		
		public function testNullNodes():void {
			var testGraph:BasicGraph = getGraph();
			assertFalse("Nonexistent nodes are not in graph", testGraph.hasNode(0));
			assertFalse("Cannot remove nonexistent node", testGraph.removeNode(0));
			assertTrue("Nonexistent nodes have an invalid number of neighbors", testGraph.numberEdges(0) < 0);
			assertTrue("Nonexistent nodes have an invalid set of neighbors", testGraph.neighbors(0) == null);
		}
		
		public function testSimplePath():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(2, 3);
			
			var path:Array = testGraph.findShortestPath(0, 3);
			assertNotNull("Path should not be null", path);
			assertTrue("Path should list 4 nodes", path.length == 4);
			assertTrue("Path should list node 0 first", path[0] == 0);
			assertTrue("Path should list node 1 second", path[1] == 1);
			assertTrue("Path should list node 2 third", path[2] == 2);
			assertTrue("Path should list node 3 forth", path[3] == 3);
		}
		
		public function testNoPath():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			
			var path:Array = testGraph.findShortestPath(0, 3);
			assertNull("Path should be null", path);
		}
		
		public function testBranchingPath():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addNode(4);
			testGraph.addNode(5);
			testGraph.addNode(6);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(2, 3);
			testGraph.addEdge(0, 4);
			testGraph.addEdge(4, 5);
			testGraph.addEdge(6, 5);
			
			var path:Array = testGraph.findShortestPath(0, 6);
			assertNotNull("Path should not be null", path);
			assertTrue("Path should list 4 nodes", path.length == 4);
			assertTrue("Path should list node 0 first", path[0] == 0);
			assertTrue("Path should list node 4 second", path[1] == 4);
			assertTrue("Path should list node 5 third", path[2] == 5);
			assertTrue("Path should list node 6 forth", path[3] == 6);
		}
		
		public function testCircularPath():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addNode(4);
			testGraph.addNode(5);
			testGraph.addNode(6);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(2, 3);
			testGraph.addEdge(3, 4);
			testGraph.addEdge(4, 5);
			testGraph.addEdge(5, 6);
			testGraph.addEdge(6, 0);
			
			var path:Array = testGraph.findShortestPath(0, 4);
			assertNotNull("Path should not be null", path);
			assertTrue("Path should list 4 nodes", path.length == 4);
			assertTrue("Path should list node 0 first", path[0] == 0);
			assertTrue("Path should list node 6 second", path[1] == 6);
			assertTrue("Path should list node 5 third", path[2] == 5);
			assertTrue("Path should list node 4 forth", path[3] == 4);
		}
		
		public function testLoops():void {
			var testGraph1:BasicGraph = getGraph(true);
			testGraph1.addNode(0);
			assertTrue("Loops should be able to be added", testGraph1.addEdge(0, 0));
			assertTrue("Loops should be able to be checked", testGraph1.adjacent(0, 0));
			assertTrue("Loops should be able to be removed", testGraph1.removeEdge(0, 0));
			
			var testGraph2:BasicGraph = getGraph(false);
			testGraph2.addNode(0);
			assertFalse("Loops should not be permissible", testGraph2.addEdge(0, 0));
		}
		
		public function testDirectedEdges():void {
			var testGraph:BasicGraph = getGraph(true, true);
			testGraph.addNode(0);
			assertTrue("Directed Loops should be able to be added", testGraph.addEdge(0, 0));
			assertTrue("Directed Edges should count as single edge for node", testGraph.numberEdges(0) == 1);
			assertTrue("Directed Edges should count as single edge for total", testGraph.totalEdges() == 1);
			assertTrue("Directed Loops should be able to be checked", testGraph.adjacent(0, 0));
			assertTrue("Directed Loops should be able to be removed", testGraph.removeEdge(0, 0));
			
			testGraph.addNode(1);
			assertTrue("Directed Edges should be able to be added", testGraph.addEdge(0, 1));
			assertTrue("Directed Edges should count as single edge for node", testGraph.numberEdges(0) == 1);
			assertTrue("Directed Edges should count as single edge for total", testGraph.totalEdges() == 1);
			assertTrue("Directed Edges should be able to be checked", testGraph.adjacent(0, 1));
			assertFalse("Directed Edges should be one way", testGraph.adjacent(1, 0));
			assertFalse("Directed Edges should only be removable from start node", testGraph.removeEdge(1, 0));
			assertTrue("Directed Edges should be able to be removed", testGraph.removeEdge(0, 1));
			
			testGraph.addNode(2);
			testGraph.addEdge(1, 2);
			assertTrue("Should be able to add directed edge backwards", testGraph.addEdge(2, 1));
			assertTrue("Node 1 should have 1 edge", testGraph.numberEdges(1) == 1);
			assertTrue("Node 2 should have 1 edge", testGraph.numberEdges(2) == 1);
			assertTrue("Should be 2 edges", testGraph.totalEdges() == 2);
			assertTrue("Directed Edges should be able to be removed", testGraph.removeEdge(1, 2));
			assertTrue("Directed Edges should be removed without removing other edges", testGraph.removeEdge(2, 1));
			
		}
		
		public function testUndirectedQuiverEdges():void {
			var testGraph:BasicGraph = getGraph(true, false, true);
			//one node
			testGraph.addNode(0);
			testGraph.addEdge(0, 0);
			assertTrue("Should be able to add 2nd edge", testGraph.addEdge(0, 0));
			assertTrue("Node 0 should have 2 edges", testGraph.numberEdges(0) == 2);
			assertTrue("Should be 2 edges", testGraph.totalEdges() == 2);
			
			assertTrue("Should be able to remove an edge", testGraph.removeEdge(0, 0));
			assertTrue("Node 0 should have 1 edge", testGraph.numberEdges(0) == 1);
			assertTrue("Should be 1 edge", testGraph.totalEdges() == 1);
			
			assertTrue("Should be able to remove an edge", testGraph.removeEdge(0, 0));
			assertTrue("Node 0 should have 0 edges", testGraph.numberEdges(0) == 0);
			assertTrue("Should be 0 edges", testGraph.totalEdges() == 0);
			
			//two nodes
			testGraph.addNode(1);
			assertTrue("Should be able to add 1st edge to 1", testGraph.addEdge(0, 1));
			assertTrue("Should be able to add 2nd edge to 1", testGraph.addEdge(0, 1));
			assertTrue("Node 0 should have 2 edges to 1", testGraph.numberEdges(0) == 2);
			assertTrue("Should be 2 edges to 1", testGraph.totalEdges() == 2);
			
			assertTrue("Should be able to remove an edge to 1", testGraph.removeEdge(0, 1));
			assertTrue("Node 0 should have 1 edge to 1", testGraph.numberEdges(0) == 1);
			assertTrue("Should be 1 edge to 1", testGraph.totalEdges() == 1);
			
			assertTrue("Should be able to remove an edge to 1", testGraph.removeEdge(0, 1));
			assertTrue("Node 0 should have 0 edges to 1", testGraph.numberEdges(0) == 0);
			assertTrue("Should be 0 edges to 1", testGraph.totalEdges() == 0);
		}
		
		public function testDirectedQuiverEdges():void {
			var testGraph:BasicGraph = getGraph(true, true, true);
			testGraph.addNode(0);
			testGraph.addEdge(0, 0);
			assertTrue("Should be able to add 2nd edge", testGraph.addEdge(0, 0));
			assertTrue("Node 0 should have 2 edges", testGraph.numberEdges(0) == 2);
			assertTrue("Should be 2 edges", testGraph.totalEdges() == 2);
			
			assertTrue("Should be able to remove an edge", testGraph.removeEdge(0, 0));
			assertTrue("Node 0 should have 1 edge", testGraph.numberEdges(0) == 1);
			assertTrue("Should be 1 edge", testGraph.totalEdges() == 1);
			
			assertTrue("Should be able to remove an edge", testGraph.removeEdge(0, 0));
			assertTrue("Node 0 should have 0 edges", testGraph.numberEdges(0) == 0);
			assertTrue("Should be 0 edges", testGraph.totalEdges() == 0);
			
			//two nodes
			testGraph.addNode(1);
			assertTrue("Should be able to add 1st edge to 1", testGraph.addEdge(0, 1));
			assertTrue("Should be able to add 2nd edge to 1", testGraph.addEdge(0, 1));
			assertTrue("Node 0 should have 2 edges to 1", testGraph.numberEdges(0) == 2);
			assertTrue("Should be 2 edges to 1", testGraph.totalEdges() == 2);
			
			assertTrue("Should be able to remove an edge to 1", testGraph.removeEdge(0, 1));
			assertTrue("Node 0 should have 1 edge to 1", testGraph.numberEdges(0) == 1);
			assertTrue("Should be 1 edge to 1", testGraph.totalEdges() == 1);
			
			assertTrue("Should be able to remove an edge to 1", testGraph.removeEdge(0, 1));
			assertTrue("Node 0 should have 0 edges to 1", testGraph.numberEdges(0) == 0);
			assertTrue("Should be 0 edges to 1", testGraph.totalEdges() == 0);
		}
		
		public function testUndirectedQuiverEdgesRemoveNode():void {
			var testGraph:BasicGraph = getGraph(true, false, true);
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addEdge(0, 0);
			testGraph.addEdge(0, 0);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 0);
			testGraph.addEdge(1, 0);
			testGraph.addEdge(2, 0);
			testGraph.addEdge(2, 0);
			assertTrue("Should be 7 edges", testGraph.totalEdges() == 7);
			assertTrue("Should be able to remove node 0", testGraph.removeNode(0));
			assertTrue("Should be 0 edges after deletion: " + testGraph.totalEdges(), testGraph.totalEdges() == 0);
		}
		
		public function testDirectedQuiverEdgesRemoveNode():void {
			var testGraph:BasicGraph = getGraph(true, true, true);
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addEdge(0, 0);
			testGraph.addEdge(0, 0);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 0);
			testGraph.addEdge(1, 0);
			testGraph.addEdge(2, 0);
			testGraph.addEdge(2, 0);
			assertTrue("Should be 7 edges", testGraph.totalEdges() == 7);
			assertTrue("Should be able to remove node 0", testGraph.removeNode(0));
			assertTrue("Should be 0 edges after deletion: " + testGraph.totalEdges(), testGraph.totalEdges() == 0);
		}
	}

}