package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide32 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide32(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide32AnimationController;
		}
	}
	
}
