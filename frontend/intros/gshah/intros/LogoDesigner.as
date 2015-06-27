package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class LogoDesigner extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function LogoDesigner(c:IGshahAnimationController=null) {
			controller=c as LogoDesignerAnimationController;
		}
	}
	
}
