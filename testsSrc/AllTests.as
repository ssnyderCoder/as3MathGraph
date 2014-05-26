package  
{
	import asunit.framework.TestSuite;
	import mathgraph.TestBasicGraph;
	import mathgraph.TestForestGraph;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class AllTests extends TestSuite
	{
		
		public function AllTests() 
		{
			super();
            addTest(new TestBasicGraph());
            addTest(new TestForestGraph());
		}
		
	}

}
