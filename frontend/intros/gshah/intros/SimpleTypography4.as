package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleTypography4 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleTypography4(c:IGshahAnimationController=null) {
			controller=c as SimpleTypography4AnimationController;
		}
	}
	
}
