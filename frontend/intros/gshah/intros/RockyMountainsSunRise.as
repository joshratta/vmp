package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class RockyMountainsSunRise extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function RockyMountainsSunRise(c:IGshahAnimationController=null) {
			controller=c as RockyMountainsSunRiseAnimationController;
		}
	}
	
}
