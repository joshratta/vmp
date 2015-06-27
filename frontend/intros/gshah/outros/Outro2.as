package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro2 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro2(c:IGshahOutroController=null) {
			controller=c as Outro2AnimationController;
		}
	}
	
}
