package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FunLowerThirds2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FunLowerThirds2(c:IGshahAnimationController=null) {
			controller=c as FunLowerThirds2AnimationController;
		}
	}
	
}
