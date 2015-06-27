package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class BlueCircleLogo extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function BlueCircleLogo(c:IGshahAnimationController=null) {
			controller=c as BlueCircleLogoAnimationController;
		}
	}
	
}
