package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class InstagramLogoSting extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function InstagramLogoSting(c:IGshahAnimationController=null) {
			controller=c as InstagramLogoStingAnimationController;
		}
	}
	
}
