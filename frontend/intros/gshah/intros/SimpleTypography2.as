package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleTypography2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleTypography2(c:IGshahAnimationController=null) {
			controller=c as SimpleTypography2AnimationController;
		}
	}
	
}
