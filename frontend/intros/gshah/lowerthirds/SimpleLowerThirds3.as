package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SimpleLowerThirds3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SimpleLowerThirds3(c:IGshahAnimationController=null) {
			controller=c as SimpleLowerThirds3AnimationController;
		}
	}
	
}
