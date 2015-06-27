package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class NeonDance extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function NeonDance(c:IGshahAnimationController=null) {
			controller=c as NeonDanceAnimationController;
		}
	}
	
}
