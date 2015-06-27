package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ModernLowerThird3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ModernLowerThird3(c:IGshahAnimationController=null) {
			controller=c as ModernLowerThird3AnimationController;
		}
	}
	
}
