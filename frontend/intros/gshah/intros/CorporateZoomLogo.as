package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CorporateZoomLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CorporateZoomLogo(c:IGshahAnimationController=null) {
			controller=c as CorporateZoomLogoAnimationController;
		}
	}
	
}
