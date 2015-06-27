package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CorporateLowerThird3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CorporateLowerThird3(c:IGshahAnimationController=null) {
			controller=c as CorporateLowerThird3AnimationController;
		}
	}
	
}
