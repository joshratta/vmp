package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class TechnoLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function TechnoLogo(c:IGshahAnimationController=null) {
			controller=c as TechnoLogoAnimationController;
		}
	}
	
}
