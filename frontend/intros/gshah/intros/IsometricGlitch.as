package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class IsometricGlitch extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function IsometricGlitch(c:IGshahAnimationController=null) {
			controller=c as IsometricGlitchAnimationController;
		}
	}
	
}
