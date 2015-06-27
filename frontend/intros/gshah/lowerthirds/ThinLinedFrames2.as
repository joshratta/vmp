package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ThinLinedFrames2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ThinLinedFrames2(c:IGshahAnimationController=null) {
			controller=c as ThinLinedFrames2AnimationController;
		}
	}
	
}
