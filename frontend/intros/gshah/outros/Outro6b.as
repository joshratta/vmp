package gshah.outros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	import gshah.IGshahOutroController;
	
	
	public class Outro6b extends MovieClip {
		
		public var controller:IGshahOutroController;
		public function Outro6b(c:IGshahOutroController=null) {
			controller=c as Outro6bAnimationController;
		}
	}
	
}
