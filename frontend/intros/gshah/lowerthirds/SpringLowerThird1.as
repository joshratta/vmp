package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SpringLowerThird1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SpringLowerThird1(c:IGshahAnimationController=null) {
			controller=c as SpringLowerThird1AnimationController;
		}
	}
	
}
