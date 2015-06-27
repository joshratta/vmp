package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class LogoOnString extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function LogoOnString(c:IGshahAnimationController=null) {
			controller=c as LogoOnStringAnimationController;
		}
	}
	
}
