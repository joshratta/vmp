package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class LogoCreator extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function LogoCreator(c:IGshahAnimationController=null) {
			controller=c as LogoCreatorAnimationController;
		}
	}
	
}
