package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro7a extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro7a(c:IGshahOutroController=null) {
			controller=c as Outro7aAnimationController;
		}
	}
	
}
