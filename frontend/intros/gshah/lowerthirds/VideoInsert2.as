package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class VideoInsert2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function VideoInsert2(c:IGshahAnimationController=null) {
			controller=c as VideoInsert2AnimationController;
		}
	}
	
}
