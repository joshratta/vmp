package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ChristmasTime extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ChristmasTime(c:IGshahAnimationController=null) {
			controller=c as ChristmasTimeAnimationController;
		}
	}
	
}
