package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SwooshLines4 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SwooshLines4(c:IGshahAnimationController=null) {
			controller=c as SwooshLines4AnimationController;
		}
	}
	
}
