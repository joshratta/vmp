package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SideBounce extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SideBounce(c:IGshahAnimationController=null) {
			controller=c as SideBounceAnimationController;
		}
	}
	
}
