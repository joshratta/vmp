package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide20 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide20(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide20AnimationController;
		}
	}
	
}
