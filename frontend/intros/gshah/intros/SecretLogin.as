package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SecretLogin extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SecretLogin(c:IGshahAnimationController=null) {
			controller=c as SecretLoginAnimationController;
		}
	}
	
}
