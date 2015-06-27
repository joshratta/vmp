package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CleanLowerThird2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CleanLowerThird2(c:IGshahAnimationController=null) {
			controller=c as CleanLowerThird2AnimationController;
		}
	}
	
}
