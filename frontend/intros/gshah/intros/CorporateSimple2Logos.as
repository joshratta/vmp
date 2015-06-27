package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CorporateSimple2Logos extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CorporateSimple2Logos(c:IGshahAnimationController=null) {
			controller=c as CorporateSimple2LogosAnimationController;
		}
	}
	
}
