package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SlinkyTunnel extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SlinkyTunnel(c:IGshahAnimationController=null) {
			controller=c as SlinkyTunnelAnimationController;
		}
	}
	
}
