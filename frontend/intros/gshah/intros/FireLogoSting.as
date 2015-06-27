package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FireLogoSting extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FireLogoSting(c:IGshahAnimationController=null) {
			controller=c as FireLogoStingAnimationController;
		}
	}
	
}
