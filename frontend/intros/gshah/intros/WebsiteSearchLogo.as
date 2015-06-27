package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class WebsiteSearchLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function WebsiteSearchLogo(c:IGshahAnimationController=null) {
			controller=c as WebsiteSearchLogoAnimationController;
		}
	}
	
}
