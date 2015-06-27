package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock1(c:IGshahAnimationController=null) {
			controller=c as MotionBlock1AnimationController;
		}
	}
	
}
