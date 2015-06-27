package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SpiderLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SpiderLogo(c:IGshahAnimationController=null) {
			controller=c as SpiderLogoAnimationController;
		}
	}
	
}
