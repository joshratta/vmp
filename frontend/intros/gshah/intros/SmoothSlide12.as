package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide12 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide12(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide12AnimationController;
		}
	}
	
}
