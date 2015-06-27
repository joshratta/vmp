package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class ModernLowerThird2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function ModernLowerThird2(c:IGshahAnimationController=null) {
			controller=c as ModernLowerThird2AnimationController;
		}
	}
	
}
