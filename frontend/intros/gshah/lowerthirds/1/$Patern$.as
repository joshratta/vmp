package gshah.lowerthirds {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class $Patern$ extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function $Patern$(c:IGshahAnimationController=null) {
			controller=c as $Patern$AnimationController;
		}
	}
	
}
