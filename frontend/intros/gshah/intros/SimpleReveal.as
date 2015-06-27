package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleReveal extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleReveal(c:IGshahAnimationController=null) {
			controller=c as SimpleRevealAnimationController;
		}
	}
	
}
