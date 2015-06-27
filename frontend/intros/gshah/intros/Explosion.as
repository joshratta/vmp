package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class Explosion extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function Explosion(c:IGshahAnimationController=null) {
			controller=c as ExplosionAnimationController;
		}
	}
	
}
