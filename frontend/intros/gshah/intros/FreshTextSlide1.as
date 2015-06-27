package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FreshTextSlide1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FreshTextSlide1(c:IGshahAnimationController=null) {
			controller=c as FreshTextSlide1AnimationController;
		}
	}
	
}
