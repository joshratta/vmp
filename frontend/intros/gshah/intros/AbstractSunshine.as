package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class AbstractSunshine extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function AbstractSunshine(c:IGshahAnimationController=null) {
			controller=c as AbstractSunshineAnimationController;
		}
	}
	
}
