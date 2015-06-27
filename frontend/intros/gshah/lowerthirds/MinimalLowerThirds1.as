package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MinimalLowerThirds1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MinimalLowerThirds1(c:IGshahAnimationController=null) {
			controller=c as MinimalLowerThirds1AnimationController;
		}
	}
	
}
