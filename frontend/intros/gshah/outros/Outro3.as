package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro3 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro3(c:IGshahOutroController=null) {
			controller=c as Outro3AnimationController;
		}
	}
	
}
