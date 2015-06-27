package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class GeometricLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function GeometricLogo(c:IGshahAnimationController=null) {
			controller=c as GeometricLogoAnimationController;
		}
	}
	
}
