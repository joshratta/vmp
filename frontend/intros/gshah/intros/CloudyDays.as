package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CloudyDays extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CloudyDays(c:IGshahAnimationController=null) {
			controller=c as CloudyDaysAnimationController;
		}
	}
	
}
