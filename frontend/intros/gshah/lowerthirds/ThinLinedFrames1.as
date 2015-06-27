package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ThinLinedFrames1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ThinLinedFrames1(c:IGshahAnimationController=null) {
			controller=c as ThinLinedFrames1AnimationController;
		}
	}
	
}
