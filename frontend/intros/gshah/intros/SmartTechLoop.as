package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmartTechLoop extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmartTechLoop(c:IGshahAnimationController=null) {
			controller=c as SmartTechLoopAnimationController;
		}
	}
	
}
