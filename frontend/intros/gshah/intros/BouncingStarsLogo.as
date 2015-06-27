package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class BouncingStarsLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function BouncingStarsLogo(c:IGshahAnimationController=null) {
			controller=c as BouncingStarsLogoAnimationController;
		}
	}
	
}
