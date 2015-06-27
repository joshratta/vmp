package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class LaptopInvention extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function LaptopInvention(c:IGshahAnimationController=null) {
			controller=c as LaptopInventionAnimationController;
		}
	}
	
}
