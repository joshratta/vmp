package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CorporateLowerThird1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CorporateLowerThird1(c:IGshahAnimationController=null) {
			controller=c as CorporateLowerThird1AnimationController;
		}
	}
	
}
