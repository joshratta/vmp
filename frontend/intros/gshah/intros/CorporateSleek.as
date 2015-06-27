package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CorporateSleek extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CorporateSleek(c:IGshahAnimationController=null) {
			controller=c as CorporateSleekAnimationController;
		}
	}
	
}
