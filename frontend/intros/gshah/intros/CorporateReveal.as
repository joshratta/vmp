package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CorporateReveal extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CorporateReveal(c:IGshahAnimationController=null) {
			controller=c as CorporateRevealAnimationController;
		}
	}
	
}
