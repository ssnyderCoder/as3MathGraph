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
		
		public function getGraph(loops:Boolean=false, directedEdges:Boolean=false, quiverEdges:Boolean=false):BasicGraph {
			return new BasicGraph(loops, directedEdges, quiverEdges);	
		}
		
	}

}