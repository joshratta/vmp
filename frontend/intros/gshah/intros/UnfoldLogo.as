package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class UnfoldLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function UnfoldLogo(c:IGshahAnimationController=null) {
			controller=c as UnfoldLogoAnimationController;
		}
	}
	
}
