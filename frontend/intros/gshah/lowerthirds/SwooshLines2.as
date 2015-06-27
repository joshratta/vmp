package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SwooshLines2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SwooshLines2(c:IGshahAnimationController=null) {
			controller=c as SwooshLines2AnimationController;
		}
	}
	
}
