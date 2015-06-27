package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock7 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock7(c:IGshahAnimationController=null) {
			controller=c as MotionBlock7AnimationController;
		}
	}
	
}
