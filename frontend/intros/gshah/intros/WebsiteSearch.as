package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class WebsiteSearch extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function WebsiteSearch(c:IGshahAnimationController=null) {
			controller=c as WebsiteSearchAnimationController;
		}
	}
	
}
