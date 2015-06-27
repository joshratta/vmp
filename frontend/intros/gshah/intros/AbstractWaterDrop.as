package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class AbstractWaterDrop extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function AbstractWaterDrop(c:IGshahAnimationController=null) {
			controller=c as AbstractWaterDropAnimationController;
		}
	}
	
}
