package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CorporateLowerThird2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CorporateLowerThird2(c:IGshahAnimationController=null) {
			controller=c as CorporateLowerThird2AnimationController;
		}
	}
	
}
