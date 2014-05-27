package mathgraph 
{
	/**
	 * 
	 * @author Sean Snyder
	 */
	public class TestForestGraph extends TestBasicGraph 
	{
		
		public function TestForestGraph(testMethod:String=null) 
		{
			super(testMethod);
			
		}
		
		override public function getGraph(loops:Boolean=false, directedEdges:Boolean=false, quiverEdges:Boolean=false):BasicGraph 
		{
			return new BasicForestGraph(loops, directedEdges, quiverEdges);
		}
		
		override public function testCircularPath():void 
		{
			assertThrows(Error, function():void{ failCircularPath(); } );
		}
		
		private function failCircularPath():void {
			super.testCircularPath();
		}
		
		override public function testUndirectedQuiverEdges():void 
		{
			assertThrows(Error, function():void{ failUndirectedQuiverEdges(); } );
		}
		
		private function failUndirectedQuiverEdges():void {
			super.testCircularPath();
		}
		
		override public function testDirectedQuiverEdges():void 
		{
			assertThrows(Error, function():void{ failDirectedQuiverEdges(); } );
		}
		
		private function failDirectedQuiverEdges():void {
			super.testDirectedQuiverEdges();
		}
		
		override public function testUndirectedQuiverEdgesRemoveNode():void 
		{
			assertThrows(Error, function():void{ failUndirectedQuiverEdgesRemoveNode(); } );
		}
		
		private function failUndirectedQuiverEdgesRemoveNode():void {
			super.testUndirectedQuiverEdgesRemoveNode();
		}
		
		override public function testDirectedQuiverEdgesRemoveNode():void 
		{
			assertThrows(Error, function():void{ failDirectedQuiverEdgesRemoveNode(); } );
		}
		
		private function failDirectedQuiverEdgesRemoveNode():void {
			super.testDirectedQuiverEdgesRemoveNode();
		}
	}

}