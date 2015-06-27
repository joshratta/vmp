package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock3(c:IGshahAnimationController=null) {
			controller=c as MotionBlock3AnimationController;
		}
	}
	
}
