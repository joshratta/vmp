package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SwooshLines3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SwooshLines3(c:IGshahAnimationController=null) {
			controller=c as SwooshLines3AnimationController;
		}
	}
	
}
