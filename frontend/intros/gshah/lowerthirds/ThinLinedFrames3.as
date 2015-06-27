package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ThinLinedFrames3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ThinLinedFrames3(c:IGshahAnimationController=null) {
			controller=c as ThinLinedFrames3AnimationController;
		}
	}
	
}
