package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FlyingPaper extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FlyingPaper(c:IGshahAnimationController=null) {
			controller=c as FlyingPaperAnimationController;
		}
	}
	
}
