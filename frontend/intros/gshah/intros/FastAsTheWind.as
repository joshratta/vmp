package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class FastAsTheWind extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function FastAsTheWind(c:IGshahAnimationController=null) {
			controller=c as FastAsTheWindAnimationController;
		}
	}
	
}
