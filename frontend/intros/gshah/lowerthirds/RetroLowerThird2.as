package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class RetroLowerThird2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function RetroLowerThird2(c:IGshahAnimationController=null) {
			controller=c as RetroLowerThird2AnimationController;
		}
	}
	
}
