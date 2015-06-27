package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SwooshLines1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SwooshLines1(c:IGshahAnimationController=null) {
			controller=c as SwooshLines1AnimationController;
		}
	}
	
}
