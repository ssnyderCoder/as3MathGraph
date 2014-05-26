package mathgraph 
{
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestForestGraph extends TestBasicGraph 
	{
		
		public function TestForestGraph(testMethod:String=null) 
		{
			super(testMethod);
			
		}
		
		override public function getGraph():BasicGraph 
		{
			return new BasicForestGraph();
		}
		
		override public function testCircularPath():void 
		{
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
			assertFalse("Should not allow circular path", testGraph.addEdge(6, 0));
			
			var path:Array = testGraph.findShortestPath(0, 4);
			assertNotNull("Path should not be null", path);
			assertTrue("Path should list 4 nodes", path.length == 5);
			assertTrue("Path should list node 0 first", path[0] == 0);
			assertTrue("Path should list node 1 second", path[1] == 1);
			assertTrue("Path should list node 2 third", path[2] == 2);
			assertTrue("Path should list node 3 fourth", path[3] == 3);
			assertTrue("Path should list node 4 fifth", path[4] == 4);
		}
	}

}