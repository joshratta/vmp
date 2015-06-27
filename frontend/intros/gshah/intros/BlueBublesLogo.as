package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class BlueBublesLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function BlueBublesLogo(c:IGshahAnimationController=null) {
			controller=c as BlueBublesLogoAnimationController;
		}
	}
	
}
