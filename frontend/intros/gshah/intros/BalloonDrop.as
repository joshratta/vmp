package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class BalloonDrop extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function BalloonDrop(c:IGshahAnimationController=null) {
			controller=c as BalloonDropAnimationController;
		}
	}
	
}
