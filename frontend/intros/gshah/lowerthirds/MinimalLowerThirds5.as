package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MinimalLowerThirds5 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MinimalLowerThirds5(c:IGshahAnimationController=null) {
			controller=c as MinimalLowerThirds5AnimationController;
		}
	}
	
}
