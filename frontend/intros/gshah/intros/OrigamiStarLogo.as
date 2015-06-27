package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class OrigamiStarLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function OrigamiStarLogo(c:IGshahAnimationController=null) {
			controller=c as OrigamiStarLogoAnimationController;
		}
	}
	
}
