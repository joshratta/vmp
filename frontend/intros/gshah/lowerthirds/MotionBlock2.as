package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock2(c:IGshahAnimationController=null) {
			controller=c as MotionBlock2AnimationController;
		}
	}
	
}
