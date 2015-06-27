package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleTypography1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleTypography1(c:IGshahAnimationController=null) {
			controller=c as SimpleTypography1AnimationController;
		}
	}
	
}
