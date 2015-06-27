package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro6a extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro6a(c:IGshahOutroController=null) {
			controller=c as Outro6aAnimationController;
		}
	}
	
}
