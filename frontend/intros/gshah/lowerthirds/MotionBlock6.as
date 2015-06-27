package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock6 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock6(c:IGshahAnimationController=null) {
			controller=c as MotionBlock6AnimationController;
		}
	}
	
}
