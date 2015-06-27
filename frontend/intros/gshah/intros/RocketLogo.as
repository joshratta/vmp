package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class RocketLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function RocketLogo(c:IGshahAnimationController=null) {
			controller=c as RocketLogoAnimationController;
		}
	}
	
}
