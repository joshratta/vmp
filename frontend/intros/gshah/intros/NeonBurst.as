package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class NeonBurst extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function NeonBurst(c:IGshahAnimationController=null) {
			controller=c as NeonBurstAnimationController;
		}
	}
	
}
