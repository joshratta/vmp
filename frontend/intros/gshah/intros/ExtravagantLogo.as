package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ExtravagantLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ExtravagantLogo(c:IGshahAnimationController=null) {
			controller=c as ExtravagantLogoAnimationController;
		}
	}
	
}
