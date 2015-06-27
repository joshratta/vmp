package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleTypography3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleTypography3(c:IGshahAnimationController=null) {
			controller=c as SimpleTypography3AnimationController;
		}
	}
	
}
