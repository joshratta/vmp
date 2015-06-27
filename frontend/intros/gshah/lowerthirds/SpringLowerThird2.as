package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SpringLowerThird2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SpringLowerThird2(c:IGshahAnimationController=null) {
			controller=c as SpringLowerThird2AnimationController;
		}
	}
	
}
