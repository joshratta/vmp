package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SpringLowerThird3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SpringLowerThird3(c:IGshahAnimationController=null) {
			controller=c as SpringLowerThird3AnimationController;
		}
	}
	
}
