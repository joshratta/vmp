package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock8 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock8(c:IGshahAnimationController=null) {
			controller=c as MotionBlock8AnimationController;
		}
	}
	
}
