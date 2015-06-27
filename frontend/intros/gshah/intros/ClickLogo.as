package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ClickLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ClickLogo(c:IGshahAnimationController=null) {
			controller=c as ClickLogoAnimationController;
		}
	}
	
}
