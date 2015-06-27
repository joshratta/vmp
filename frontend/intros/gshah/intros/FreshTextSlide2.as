package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FreshTextSlide2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FreshTextSlide2(c:IGshahAnimationController=null) {
			controller=c as FreshTextSlide2AnimationController;
		}
	}
	
}
