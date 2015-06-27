package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MinimalLowerThirds3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MinimalLowerThirds3(c:IGshahAnimationController=null) {
			controller=c as MinimalLowerThirds3AnimationController;
		}
	}
	
}
