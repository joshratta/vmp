package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FunkyLogoSting extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FunkyLogoSting(c:IGshahAnimationController=null) {
			controller=c as FunkyLogoStingAnimationController;
		}
	}
	
}
