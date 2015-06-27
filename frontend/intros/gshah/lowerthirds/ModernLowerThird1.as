package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ModernLowerThird1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ModernLowerThird1(c:IGshahAnimationController=null) {
			controller=c as ModernLowerThird1AnimationController;
		}
	}
	
}
