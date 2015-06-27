package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class MobileSMS extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function MobileSMS(c:IGshahAnimationController=null) {
			controller=c as MobileSMSAnimationController;
		}
	}
	
}
