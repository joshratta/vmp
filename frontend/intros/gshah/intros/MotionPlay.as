package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionPlay extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionPlay(c:IGshahAnimationController=null) {
			controller=c as MotionPlayAnimationController;
		}
	}
	
}
