package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MobileSlideshow extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MobileSlideshow(c:IGshahAnimationController=null) {
			controller=c as MobileSlideshowAnimationController;
		}
	}
	
}
