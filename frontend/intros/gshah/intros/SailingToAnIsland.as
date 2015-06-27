package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SailingToAnIsland extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SailingToAnIsland(c:IGshahAnimationController=null) {
			controller=c as SailingToAnIslandAnimationController;
		}
	}
	
}
