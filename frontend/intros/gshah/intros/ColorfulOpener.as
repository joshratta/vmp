package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ColorfulOpener extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ColorfulOpener(c:IGshahAnimationController=null) {
			controller=c as ColorfulOpenerAnimationController;
		}
	}
	
}
