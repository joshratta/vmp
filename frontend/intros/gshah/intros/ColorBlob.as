package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ColorBlob extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ColorBlob(c:IGshahAnimationController=null) {
			controller=c as ColorBlobAnimationController;
		}
	}
	
}
