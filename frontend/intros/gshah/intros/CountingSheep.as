package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class CountingSheep extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function CountingSheep(c:IGshahAnimationController=null) {
			controller=c as CountingSheepAnimationController;
		}
	}
	
}
