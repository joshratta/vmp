package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class VideoInsert1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function VideoInsert1(c:IGshahAnimationController=null) {
			controller=c as VideoInsert1AnimationController;
		}
	}
	
}
