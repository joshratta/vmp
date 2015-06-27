package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CleanLowerThird1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CleanLowerThird1(c:IGshahAnimationController=null) {
			controller=c as CleanLowerThird1AnimationController;
		}
	}
	
}
