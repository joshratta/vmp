package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class RetroLowerThird3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function RetroLowerThird3(c:IGshahAnimationController=null) {
			controller=c as RetroLowerThird3AnimationController;
		}
	}
	
}
