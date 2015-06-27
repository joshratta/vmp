package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock11 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock11(c:IGshahAnimationController=null) {
			controller=c as MotionBlock11AnimationController;
		}
	}
	
}
