package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CleanLowerThird3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CleanLowerThird3(c:IGshahAnimationController=null) {
			controller=c as CleanLowerThird3AnimationController;
		}
	}
	
}
