package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class NatureAbstract extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function NatureAbstract(c:IGshahAnimationController=null) {
			controller=c as NatureAbstractAnimationController;
		}
	}
	
}
