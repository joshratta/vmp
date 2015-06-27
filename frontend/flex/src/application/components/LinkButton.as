package application.components
{
	import application.skins.LinkButtonSkin;
	
	import spark.components.Button;

	public class LinkButton extends Button
	{
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			buttonMode = value;
			setStyle('skinClass',LinkButtonSkin);
		}
		
		public function LinkButton()
		{
			super();
			
			buttonMode = true;
		}
	}
}