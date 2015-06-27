package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class RocketLaunch extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function RocketLaunch(c:IGshahAnimationController=null) {
			controller=c as RocketLaunchAnimationController;
		}
	}
	
}
