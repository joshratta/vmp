package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock9 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock9(c:IGshahAnimationController=null) {
			controller=c as MotionBlock9AnimationController;
		}
	}
	
}
