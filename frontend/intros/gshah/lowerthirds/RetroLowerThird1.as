package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class RetroLowerThird1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function RetroLowerThird1(c:IGshahAnimationController=null) {
			controller=c as RetroLowerThird1AnimationController;
		}
	}
	
}
