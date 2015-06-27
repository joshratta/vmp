package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleLowerThirds5 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleLowerThirds5(c:IGshahAnimationController=null) {
			controller=c as SimpleLowerThirds5AnimationController;
		}
	}
	
}
