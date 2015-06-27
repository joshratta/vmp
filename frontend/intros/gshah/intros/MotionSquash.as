package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionSquash extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionSquash(c:IGshahAnimationController=null) {
			controller=c as MotionSquashAnimationController;
		}
	}
	
}
