package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleTypography5 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleTypography5(c:IGshahAnimationController=null) {
			controller=c as SimpleTypography5AnimationController;
		}
	}
	
}
