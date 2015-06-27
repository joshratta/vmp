package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class DropLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function DropLogo(c:IGshahAnimationController=null) {
			controller=c as DropLogoAnimationController;
		}
	}
	
}
