package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MinimalLowerThirds2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MinimalLowerThirds2(c:IGshahAnimationController=null) {
			controller=c as MinimalLowerThirds2AnimationController;
		}
	}
	
}
