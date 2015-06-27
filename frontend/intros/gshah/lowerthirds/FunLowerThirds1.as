package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FunLowerThirds1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FunLowerThirds1(c:IGshahAnimationController=null) {
			controller=c as FunLowerThirds1AnimationController;
		}
	}
	
}
