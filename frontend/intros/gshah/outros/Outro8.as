package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro8 extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro8(c:IGshahOutroController=null) {
			controller=c as Outro8AnimationController;
		}
	}
	
}
