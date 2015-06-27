package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class GuitarLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function GuitarLogo(c:IGshahAnimationController=null) {
			controller=c as GuitarLogoAnimationController;
		}
	}
	
}
