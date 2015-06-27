package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ScienceExperiment extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ScienceExperiment(c:IGshahAnimationController=null) {
			controller=c as ScienceExperimentAnimationController;
		}
	}
	
}
