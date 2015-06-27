package gshah.intros.logos {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	
	public class BlueCircleLogoLogo extends MovieClip {
		
		public function BlueCircleLogoLogo() {
			if(this.parent!=null&&(this.parent as Object).controller!=null)
			{
				var bitmap:Bitmap=(this.parent as Object).controller.getLogo(0);
				if(bitmap!=null)
				{
					this.removeChildren();
					this.addChild(bitmap);
					bitmap.x=-4.85;
					bitmap.y=-38.20;
					
				}
			}
		}
	}
	
}
