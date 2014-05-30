package mathgraph 
{
	import asunit.framework.TestCase;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestGraphUtil extends TestCase 
	{
		
		public function TestGraphUtil(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		public function getGraph(loops:Boolean=false, directedEdges:Boolean=false, quiverEdges:Boolean=false):BasicGraph {
			return new BasicGraph(loops, directedEdges, quiverEdges);	
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
			
			var path:Array = GraphUtil.findShortestPath(testGraph, 0, 3);
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
			
			var path:Array = GraphUtil.findShortestPath(testGraph, 0, 3);
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
			
			var path:Array = GraphUtil.findShortestPath(testGraph, 0, 6);
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
			
			var path:Array = GraphUtil.findShortestPath(testGraph, 0, 4);
			assertNotNull("Path should not be null", path);
			assertTrue("Path should list 4 nodes", path.length == 4);
			assertTrue("Path should list node 0 first", path[0] == 0);
			assertTrue("Path should list node 6 second", path[1] == 6);
			assertTrue("Path should list node 5 third", path[2] == 5);
			assertTrue("Path should list node 4 forth", path[3] == 4);
		}
		
		public function testWeightedCyclePath():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addNode(4);
			testGraph.addNode(5);
			testGraph.addNode(6);
			testGraph.addEdge(0, 1, 25);
			testGraph.addEdge(1, 2, 25);
			testGraph.addEdge(2, 3, 25);
			testGraph.addEdge(3, 4, 25);
			testGraph.addEdge(4, 5, 25);
			testGraph.addEdge(5, 6, 25);
			testGraph.addEdge(3, 6, 125);
			testGraph.addEdge(1, 6, 150);
			
			var path:Array = GraphUtil.findShortestPath(testGraph, 0, 6);
			assertNotNull("Path should not be null", path);
			assertTrue("Path should list 7 nodes", path.length == 7);
			assertTrue("Path should list node 0", path[0] == 0);
			assertTrue("Path should list node 1", path[1] == 1);
			assertTrue("Path should list node 2", path[2] == 2);
			assertTrue("Path should list node 3", path[3] == 3);
			assertTrue("Path should list node 4", path[4] == 4);
			assertTrue("Path should list node 5", path[5] == 5);
			assertTrue("Path should list node 6", path[6] == 6);
		}
		
		public function testWeightedDirectedPath():void {
			var testGraph:BasicGraph = getGraph(true, true);
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addEdge(0, 0, 25);
			testGraph.addEdge(0, 1, 25);
			testGraph.addEdge(1, 2, 25);
			testGraph.addEdge(1, 3, 25);
			testGraph.addEdge(3, 0, 5);
			
			var path:Array = GraphUtil.findShortestPath(testGraph, 0, 3);
			assertNotNull("Path should not be null", path);
			assertTrue("Path should list 3 nodes", path.length == 3);
			assertTrue("Path should list node 0", path[0] == 0);
			assertTrue("Path should list node 1", path[1] == 1);
			assertTrue("Path should list node 3", path[2] == 3);
		}
		
		public function testWeightedDirectedQuiverPath():void {
			var testGraph:BasicGraph = getGraph(true, true, true);
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addEdge(0, 1, 25);
			testGraph.addEdge(0, 1, 275);
			testGraph.addEdge(0, 1, 325);
			testGraph.addEdge(0, 1, 425);
			testGraph.addEdge(0, 1, 525);
			testGraph.addEdge(0, 2, 35);
			testGraph.addEdge(0, 2, 75);
			testGraph.addEdge(0, 2, 125);
			testGraph.addEdge(1, 3, 25);
			testGraph.addEdge(2, 3, 25);
			
			var path:Array = GraphUtil.findShortestPath(testGraph, 0, 3, true);
			assertNotNull("Path should not be null", path);
			assertTrue("Path should list 3 nodes", path.length == 3);
			assertTrue("Path should list node 0", path[0] == 0);
			assertTrue("Path should list node 1", path[1] == 1);
			assertTrue("Path should list node 3", path[2] == 3);
		}
		
		public function testSimplestTree():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			//testGraph.addNode(2);
			//testGraph.addNode(3);
			testGraph.addEdge(0, 1);
			//testGraph.addEdge(1, 2);
			//testGraph.addEdge(0, 3);
			assertTrue("Should be a tree", GraphUtil.isForestGraph(testGraph));
		}
		
		public function testValidTree():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(0, 3);
			assertTrue("Should be a tree", GraphUtil.isForestGraph(testGraph));
		}
		
		public function testValidForest():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addNode(4);
			testGraph.addNode(5);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(4, 3);
			assertTrue("Should be a forest", GraphUtil.isForestGraph(testGraph));
		}
		
		public function testDirectedValidTree():void {
			var testGraph:BasicGraph = getGraph(true, true);
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(0, 3);
			assertTrue("Should be a tree", GraphUtil.isForestGraph(testGraph));
		}
		
		public function testDirectedValidForest():void {
			var testGraph:BasicGraph = getGraph(true, true);
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addNode(4);
			testGraph.addNode(5);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(4, 3);
			assertTrue("Should be a forest", GraphUtil.isForestGraph(testGraph));
		}
		
		public function testInvalidTree():void {
			var testGraph:BasicGraph = getGraph();
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(0, 3);
			testGraph.addEdge(2, 3);
			assertFalse("Should not be a tree", GraphUtil.isForestGraph(testGraph));
		}
		
		public function testInvalidDirectedTree():void {
			var testGraph:BasicGraph = getGraph(true, true);
			testGraph.addNode(0);
			testGraph.addNode(1);
			testGraph.addNode(2);
			testGraph.addNode(3);
			testGraph.addEdge(0, 1);
			testGraph.addEdge(1, 2);
			testGraph.addEdge(2, 3);
			testGraph.addEdge(3, 0);
			assertFalse("Should not be a tree", GraphUtil.isForestGraph(testGraph));
		}
		
	}

}