package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class PhotoStudio extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function PhotoStudio(c:IGshahAnimationController=null) {
			controller=c as PhotoStudioAnimationController;
		}
	}
	
}
