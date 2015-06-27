package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FutureLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FutureLogo(c:IGshahAnimationController=null) {
			controller=c as FutureLogoAnimationController;
		}
	}
	
}
