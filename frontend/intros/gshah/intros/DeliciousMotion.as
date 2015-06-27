package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class DeliciousMotion extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function DeliciousMotion(c:IGshahAnimationController=null) {
			controller=c as DeliciousMotionAnimationController;
		}
	}
	
}
