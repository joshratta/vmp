package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock4 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock4(c:IGshahAnimationController=null) {
			controller=c as MotionBlock4AnimationController;
		}
	}
	
}
