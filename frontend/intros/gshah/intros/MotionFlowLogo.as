package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionFlowLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionFlowLogo(c:IGshahAnimationController=null) {
			controller=c as MotionFlowLogoAnimationController;
		}
	}
	
}
