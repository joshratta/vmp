package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MotionExperiment extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MotionExperiment(c:IGshahAnimationController=null) {
			controller=c as MotionExperimentAnimationController;
		}
	}
	
}
