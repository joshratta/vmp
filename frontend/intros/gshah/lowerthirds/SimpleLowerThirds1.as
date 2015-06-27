package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleLowerThirds1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleLowerThirds1(c:IGshahAnimationController=null) {
			controller=c as SimpleLowerThirds1AnimationController;
		}
	}
	
}
