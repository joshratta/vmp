package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class OceanBreeze extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function OceanBreeze(c:IGshahAnimationController=null) {
			controller=c as OceanBreezeAnimationController;
		}
	}
	
}
