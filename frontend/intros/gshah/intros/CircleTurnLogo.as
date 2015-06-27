package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CircleTurnLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CircleTurnLogo(c:IGshahAnimationController=null) {
			controller=c as CircleTurnLogoAnimationController;
		}
	}
	
}
