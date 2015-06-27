package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleTypography6 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleTypography6(c:IGshahAnimationController=null) {
			controller=c as SimpleTypography6AnimationController;
		}
	}
	
}
