package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FreshLogoSting extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FreshLogoSting(c:IGshahAnimationController=null) {
			controller=c as FreshLogoStingAnimationController;
		}
	}
	
}
