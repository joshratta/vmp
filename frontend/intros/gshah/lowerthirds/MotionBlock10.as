package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionBlock10 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionBlock10(c:IGshahAnimationController=null) {
			controller=c as MotionBlock10AnimationController;
		}
	}
	
}
