package application.managers
{
	import application.managers.components.GshahAnimationLibraryItem;
	
	import flash.utils.getQualifiedClassName;
	
	import gshah.IGshahAnimationController;
	import gshah.intros.AbstractSunshineAnimationController;
	import gshah.intros.BlueBublesLogoAnimationController;
	import gshah.intros.BlueCircleLogoAnimationController;
	import gshah.intros.BouncingStarsLogoAnimationController;
	import gshah.intros.ChristmasTimeAnimationController;
	import gshah.intros.CircleTurnLogoAnimationController;
	import gshah.intros.ClickLogoAnimationController;
	import gshah.intros.CorporateRevealAnimationController;
	import gshah.intros.CorporateSimple2Logos2AnimationController;
	import gshah.intros.CorporateSimple2LogosAnimationController;
	import gshah.intros.CorporateSleekAnimationController;
	import gshah.intros.CorporateZoomLogoAnimationController;
	import gshah.intros.CountingSheepAnimationController;
	import gshah.intros.DeliciousMotionAnimationController;
	import gshah.intros.DropLogoAnimationController;
	import gshah.intros.ExplosionAnimationController;
	import gshah.intros.ExtravagantLogoAnimationController;
	import gshah.intros.FastAsTheWindAnimationController;
	import gshah.intros.FireLogoStingAnimationController;
	import gshah.intros.FlyingManAnimationController;
	import gshah.intros.FlyingPaperAnimationController;
	import gshah.intros.FreshLogoStingAnimationController;
	import gshah.intros.FreshTextSlide10AnimationController;
	import gshah.intros.FreshTextSlide11AnimationController;
	import gshah.intros.FreshTextSlide1AnimationController;
	import gshah.intros.FreshTextSlide2AnimationController;
	import gshah.intros.FreshTextSlide3AnimationController;
	import gshah.intros.FreshTextSlide4AnimationController;
	import gshah.intros.FreshTextSlide5AnimationController;
	import gshah.intros.FreshTextSlide6AnimationController;
	import gshah.intros.FreshTextSlide7AnimationController;
	import gshah.intros.FreshTextSlide8AnimationController;
	import gshah.intros.FreshTextSlide9AnimationController;
	import gshah.intros.FunkyLogoStingAnimationController;
	import gshah.intros.FutureLogoAnimationController;
	import gshah.intros.GeometricLogoAnimationController;
	import gshah.intros.GuitarLogoAnimationController;
	import gshah.intros.InstagramLogoStingAnimationController;
	import gshah.intros.LaptopInventionAnimationController;
	import gshah.intros.LogoOnStringAnimationController;
	import gshah.intros.MobileSMSAnimationController;
	import gshah.intros.MobileSlideshowAnimationController;
	import gshah.intros.MotionExperimentAnimationController;
	import gshah.intros.MotionFlowLogoAnimationController;
	import gshah.intros.MotionSquashAnimationController;
	import gshah.intros.NatureAbstractAnimationController;
	import gshah.intros.NeonBurstAnimationController;
	import gshah.intros.NeonDanceAnimationController;
	import gshah.intros.OceanBreezeAnimationController;
	import gshah.intros.OldProjectorTextSlide1AnimationController;
	import gshah.intros.OldProjectorTextSlide2AnimationController;
	import gshah.intros.OldProjectorTextSlide3AnimationController;
	import gshah.intros.OldProjectorTextSlide4AnimationController;
	import gshah.intros.OldProjectorTextSlide5AnimationController;
	import gshah.intros.OldProjectorTextSlide6AnimationController;
	import gshah.intros.OrigamiStarLogoAnimationController;
	import gshah.intros.QuickSlideRevealAnimationController;
	import gshah.intros.RocketLaunchAnimationController;
	import gshah.intros.RocketLogoAnimationController;
	import gshah.intros.RockyMountainsSunRiseAnimationController;
	import gshah.intros.SailingToAnIslandAnimationController;
	import gshah.intros.ScienceExperimentAnimationController;
	import gshah.intros.SecretLoginAnimationController;
	import gshah.intros.SideBounceAnimationController;
	import gshah.intros.SimpleRevealAnimationController;
	import gshah.intros.SimpleTypography1AnimationController;
	import gshah.intros.SimpleTypography2AnimationController;
	import gshah.intros.SimpleTypography3AnimationController;
	import gshah.intros.SimpleTypography4AnimationController;
	import gshah.intros.SimpleTypography5AnimationController;
	import gshah.intros.SimpleTypography6AnimationController;
	import gshah.intros.SlinkyTunnelAnimationController;
	import gshah.intros.SmartTechLoopAnimationController;
	import gshah.intros.SmoothSlide10AnimationController;
	import gshah.intros.SmoothSlide11AnimationController;
	import gshah.intros.SmoothSlide12AnimationController;
	import gshah.intros.SmoothSlide13AnimationController;
	import gshah.intros.SmoothSlide14AnimationController;
	import gshah.intros.SmoothSlide15AnimationController;
	import gshah.intros.SmoothSlide16AnimationController;
	import gshah.intros.SmoothSlide17AnimationController;
	import gshah.intros.SmoothSlide18AnimationController;
	import gshah.intros.SmoothSlide19AnimationController;
	import gshah.intros.SmoothSlide1AnimationController;
	import gshah.intros.SmoothSlide20AnimationController;
	import gshah.intros.SmoothSlide21AnimationController;
	import gshah.intros.SmoothSlide22AnimationController;
	import gshah.intros.SmoothSlide23AnimationController;
	import gshah.intros.SmoothSlide24AnimationController;
	import gshah.intros.SmoothSlide25AnimationController;
	import gshah.intros.SmoothSlide26AnimationController;
	import gshah.intros.SmoothSlide27AnimationController;
	import gshah.intros.SmoothSlide28AnimationController;
	import gshah.intros.SmoothSlide29AnimationController;
	import gshah.intros.SmoothSlide2AnimationController;
	import gshah.intros.SmoothSlide30AnimationController;
	import gshah.intros.SmoothSlide31AnimationController;
	import gshah.intros.SmoothSlide32AnimationController;
	import gshah.intros.SmoothSlide33AnimationController;
	import gshah.intros.SmoothSlide34AnimationController;
	import gshah.intros.SmoothSlide35AnimationController;
	import gshah.intros.SmoothSlide36AnimationController;
	import gshah.intros.SmoothSlide37AnimationController;
	import gshah.intros.SmoothSlide38AnimationController;
	import gshah.intros.SmoothSlide39AnimationController;
	import gshah.intros.SmoothSlide3AnimationController;
	import gshah.intros.SmoothSlide40AnimationController;
	import gshah.intros.SmoothSlide41AnimationController;
	import gshah.intros.SmoothSlide42AnimationController;
	import gshah.intros.SmoothSlide43AnimationController;
	import gshah.intros.SmoothSlide44AnimationController;
	import gshah.intros.SmoothSlide45AnimationController;
	import gshah.intros.SmoothSlide4AnimationController;
	import gshah.intros.SmoothSlide5AnimationController;
	import gshah.intros.SmoothSlide6AnimationController;
	import gshah.intros.SmoothSlide7AnimationController;
	import gshah.intros.SmoothSlide8AnimationController;
	import gshah.intros.SmoothSlide9AnimationController;
	import gshah.intros.SpiderLogoAnimationController;
	import gshah.intros.StickManAnimationController;
	import gshah.intros.TabletSlideshowAnimationController;
	import gshah.intros.TabletSwipeAnimationController;
	import gshah.intros.TechnoLogoAnimationController;
	import gshah.intros.TextSlideModernConcept1AnimationController;
	import gshah.intros.TextSlideModernConcept2AnimationController;
	import gshah.intros.TextSlideModernConcept3AnimationController;
	import gshah.intros.TextSlideModernConcept4AnimationController;
	import gshah.intros.TextSlideModernConcept5AnimationController;
	import gshah.intros.UnfoldLogoAnimationController;
	import gshah.intros.WebsiteSearchAnimationController;
	import gshah.intros.WebsiteSearchLogoAnimationController;
	import gshah.lowerthirds.CleanLowerThird1AnimationController;
	import gshah.lowerthirds.CleanLowerThird2AnimationController;
	import gshah.lowerthirds.CleanLowerThird3AnimationController;
	import gshah.lowerthirds.CleanLowerThird4AnimationController;
	import gshah.lowerthirds.CorporateLowerThird1AnimationController;
	import gshah.lowerthirds.CorporateLowerThird2AnimationController;
	import gshah.lowerthirds.CorporateLowerThird3AnimationController;
	import gshah.lowerthirds.CorporateLowerThird4AnimationController;
	import gshah.lowerthirds.CorporateLowerThird5AnimationController;
	import gshah.lowerthirds.FunLowerThirds1AnimationController;
	import gshah.lowerthirds.FunLowerThirds2AnimationController;
	import gshah.lowerthirds.FunLowerThirds3AnimationController;
	import gshah.lowerthirds.FunLowerThirds4AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird10AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird11AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird12AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird13AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird1AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird2AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird3AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird4AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird5AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird6AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird7AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird8AnimationController;
	import gshah.lowerthirds.GlitchCinematicTitlesLowerThird9AnimationController;
	import gshah.lowerthirds.GreenNeonThinLines1AnimationController;
	import gshah.lowerthirds.GreenNeonThinLines2AnimationController;
	import gshah.lowerthirds.GreenNeonThinLines3AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds10AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds1AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds2AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds3AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds4AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds5AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds6AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds7AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds8AnimationController;
	import gshah.lowerthirds.MinimalLowerThirds9AnimationController;
	import gshah.lowerthirds.ModernLowerThird1AnimationController;
	import gshah.lowerthirds.ModernLowerThird2AnimationController;
	import gshah.lowerthirds.ModernLowerThird3AnimationController;
	import gshah.lowerthirds.ModernLowerThird4AnimationController;
	import gshah.lowerthirds.ModernLowerThird5AnimationController;
	import gshah.lowerthirds.ModernLowerThird6AnimationController;
	import gshah.lowerthirds.ModernLowerThird7AnimationController;
	import gshah.lowerthirds.ModernNavyLowerThird1AnimationController;
	import gshah.lowerthirds.ModernNavyLowerThird2AnimationController;
	import gshah.lowerthirds.ModernNavyLowerThird3AnimationController;
	import gshah.lowerthirds.ModernNavyLowerThird4AnimationController;
	import gshah.lowerthirds.ModernNavyLowerThird5AnimationController;
	import gshah.lowerthirds.MotionBlock10AnimationController;
	import gshah.lowerthirds.MotionBlock11AnimationController;
	import gshah.lowerthirds.MotionBlock1AnimationController;
	import gshah.lowerthirds.MotionBlock2AnimationController;
	import gshah.lowerthirds.MotionBlock3AnimationController;
	import gshah.lowerthirds.MotionBlock4AnimationController;
	import gshah.lowerthirds.MotionBlock5AnimationController;
	import gshah.lowerthirds.MotionBlock6AnimationController;
	import gshah.lowerthirds.MotionBlock7AnimationController;
	import gshah.lowerthirds.MotionBlock8AnimationController;
	import gshah.lowerthirds.MotionBlock9AnimationController;
	import gshah.lowerthirds.RetroLowerThird1AnimationController;
	import gshah.lowerthirds.RetroLowerThird2AnimationController;
	import gshah.lowerthirds.RetroLowerThird3AnimationController;
	import gshah.lowerthirds.RetroLowerThird4AnimationController;
	import gshah.lowerthirds.RetroLowerThird5AnimationController;
	import gshah.lowerthirds.RetroLowerThird6AnimationController;
	import gshah.lowerthirds.RetroLowerThird7AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds1AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds2AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds3AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds4AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds5AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds6AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds7AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds8AnimationController;
	import gshah.lowerthirds.SimpleLowerThirds9AnimationController;
	import gshah.lowerthirds.SpringLowerThird1AnimationController;
	import gshah.lowerthirds.SpringLowerThird2AnimationController;
	import gshah.lowerthirds.SpringLowerThird3AnimationController;
	import gshah.lowerthirds.SpringLowerThird4AnimationController;
	import gshah.lowerthirds.SpringLowerThird5AnimationController;
	import gshah.lowerthirds.VideoInsert1AnimationController;
	import gshah.lowerthirds.VideoInsert2AnimationController;
	import gshah.lowerthirds.VideoInsert3AnimationController;
	import gshah.lowerthirds.VideoInsert4AnimationController;
	import gshah.lowerthirds.VideoInsert5AnimationController;
	import gshah.lowerthirds.VideoInsert6AnimationController;
	import gshah.lowerthirds.VideoInsert7AnimationController;
	import gshah.lowerthirds.VideoInsert8AnimationController;
	import gshah.lowerthirds.VideoInsert9AnimationController;
	import gshah.outros.Outro10AnimationController;
	import gshah.outros.Outro1AnimationController;
	import gshah.outros.Outro2AnimationController;
	import gshah.outros.Outro3AnimationController;
	import gshah.outros.Outro4AnimationController;
	import gshah.outros.Outro5AnimationController;
	import gshah.outros.Outro6AnimationController;
	import gshah.outros.Outro6aAnimationController;
	import gshah.outros.Outro6bAnimationController;
	import gshah.outros.Outro7AnimationController;
	import gshah.outros.Outro7aAnimationController;
	import gshah.outros.Outro8AnimationController;
	import gshah.outros.Outro9AnimationController;
	import gshah.lowerthirds.SwooshLines1AnimationController;
	import gshah.lowerthirds.SwooshLines2AnimationController;
	import gshah.lowerthirds.SwooshLines3AnimationController;
	import gshah.lowerthirds.SwooshLines4AnimationController;
	import gshah.lowerthirds.ThinLinedFrames1AnimationController;
	import gshah.lowerthirds.ThinLinedFrames2AnimationController;
	import gshah.lowerthirds.ThinLinedFrames3AnimationController;
	import gshah.lowerthirds.ThinLinesLowerThird1AnimationController;
	import gshah.lowerthirds.ThinLinesLowerThird2AnimationController;
	import gshah.lowerthirds.ThinLinesLowerThird3AnimationController;
	import gshah.lowerthirds.VideoMarketingLowerThird1AnimationController;
	import gshah.lowerthirds.VideoMarketingLowerThird2AnimationController;
	import gshah.lowerthirds.VideoMarketingLowerThird3AnimationController;
	import gshah.intros.LogoDesignerAnimationController;
	import gshah.intros.CloudyDaysAnimationController;
	import gshah.intros.PhotoStudioAnimationController;
	import gshah.intros.IsometricGlitchAnimationController;
	import gshah.intros.ColorfulOpenerAnimationController;
	import gshah.intros.MotionPlayAnimationController;
	import gshah.intros.AbstractWaterDropAnimationController;
	import gshah.intros.LogoCreatorAnimationController;
	import gshah.intros.ColorBlobAnimationController;
	import gshah.intros.BalloonDropAnimationController;

	import mx.collections.ArrayList;
	
	import sys.SystemSettings;
	
	public class GshahAnimationLibrary
	{
		private static var _instance:GshahAnimationLibrary;
		
		
		[Bindable]
		public static function get instance():GshahAnimationLibrary
		{
			if(_instance==null)
			{
				_instance=new GshahAnimationLibrary;
			}
			return _instance;
		}
		
		public static function set instance(value:GshahAnimationLibrary):void
		{
			_instance = value;
		}		
		
		
		private var _animationAliases:Array;
		public function getAnimationAliases():Array
		{
			if(_animationAliases==null)
			{			
				_animationAliases=[
					"gshah.intros::BlueCircleLogoAnimationController",
					"gshah.intros::BlueBublesLogoAnimationController",
					"gshah.intros::TechnoLogoAnimationController",
					"gshah.intros::FreshLogoStingAnimationController",
					"gshah.intros::GeometricLogoAnimationController",
					"gshah.intros::CorporateZoomLogoAnimationController",
					"gshah.intros::SideBounceAnimationController",
					"gshah.intros::WebsiteSearchLogoAnimationController",
					"gshah.intros::RocketLogoAnimationController",
					"gshah.intros::OrigamiStarLogoAnimationController",
					"gshah.intros::ScienceExperimentAnimationController",
					"gshah.intros::FlyingManAnimationController",
					"gshah.intros::FutureLogoAnimationController",
					"gshah.intros::MotionFlowLogoAnimationController",
					"gshah.intros::SpiderLogoAnimationController",
					"gshah.intros::MotionExperimentAnimationController",
					"gshah.intros::CountingSheepAnimationController",
					"gshah.intros::BouncingStarsLogoAnimationController",
					"gshah.intros::SlinkyTunnelAnimationController",
					"gshah.intros::SmartTechLoopAnimationController",
					"gshah.intros::GuitarLogoAnimationController",
					"gshah.intros::CorporateSleekAnimationController",
					"gshah.intros::SecretLoginAnimationController",
					"gshah.intros::MobileSMSAnimationController",
					"gshah.intros::RocketLaunchAnimationController",
					"gshah.intros::ExplosionAnimationController",
					"gshah.intros::DeliciousMotionAnimationController",
					"gshah.intros::ExtravagantLogoAnimationController",
					"gshah.intros::FunkyLogoStingAnimationController",
					"gshah.intros::CorporateSimple2LogosAnimationController",
					"gshah.intros::TabletSwipeAnimationController",
					"gshah.intros::SailingToAnIslandAnimationController",
					"gshah.intros::FireLogoStingAnimationController",
					"gshah.intros::ChristmasTimeAnimationController",
					"gshah.intros::LaptopInventionAnimationController",
					"gshah.intros::RockyMountainsSunRiseAnimationController",
					"gshah.intros::QuickSlideRevealAnimationController",
					"gshah.intros::ClickLogoAnimationController",
					"gshah.intros::FlyingPaperAnimationController",
					"gshah.intros::StickManAnimationController",
					"gshah.intros::CircleTurnLogoAnimationController",
					"gshah.intros::CorporateRevealAnimationController",
					"gshah.intros::DropLogoAnimationController",
					"gshah.intros::SimpleRevealAnimationController",
					"gshah.intros::NeonBurstAnimationController",
					"gshah.intros::InstagramLogoStingAnimationController",
					"gshah.intros::UnfoldLogoAnimationController",
					"gshah.lowerthirds::SpringLowerThird1AnimationController",
					"gshah.lowerthirds::SpringLowerThird2AnimationController",
					"gshah.lowerthirds::SpringLowerThird3AnimationController",
					"gshah.lowerthirds::SpringLowerThird4AnimationController",
					"gshah.lowerthirds::SpringLowerThird5AnimationController",
					"gshah.lowerthirds::CorporateLowerThird1AnimationController",
					"gshah.lowerthirds::CorporateLowerThird2AnimationController",
					"gshah.lowerthirds::CorporateLowerThird3AnimationController",
					"gshah.lowerthirds::CorporateLowerThird4AnimationController",
					"gshah.lowerthirds::CorporateLowerThird5AnimationController",
					"gshah.lowerthirds::RetroLowerThird1AnimationController",
					"gshah.lowerthirds::RetroLowerThird2AnimationController",
					"gshah.lowerthirds::RetroLowerThird3AnimationController",
					"gshah.lowerthirds::RetroLowerThird4AnimationController",
					"gshah.lowerthirds::RetroLowerThird5AnimationController",
					"gshah.lowerthirds::RetroLowerThird6AnimationController",
					"gshah.lowerthirds::RetroLowerThird7AnimationController",
					"gshah.lowerthirds::ModernLowerThird1AnimationController",
					"gshah.lowerthirds::ModernLowerThird2AnimationController",
					"gshah.lowerthirds::ModernLowerThird3AnimationController",
					"gshah.lowerthirds::ModernLowerThird4AnimationController",
					"gshah.lowerthirds::ModernLowerThird5AnimationController",
					"gshah.lowerthirds::ModernLowerThird6AnimationController",
					"gshah.lowerthirds::ModernLowerThird7AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird1AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird2AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird3AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird4AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird5AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird6AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird7AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird8AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird9AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird10AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird11AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird12AnimationController",
					"gshah.lowerthirds::GlitchCinematicTitlesLowerThird13AnimationController",
					"gshah.lowerthirds::CleanLowerThird1AnimationController",
					"gshah.lowerthirds::CleanLowerThird2AnimationController",
					"gshah.lowerthirds::CleanLowerThird3AnimationController",
					"gshah.lowerthirds::CleanLowerThird4AnimationController",
					"gshah.lowerthirds::VideoInsert1AnimationController",
					"gshah.lowerthirds::VideoInsert2AnimationController",
					"gshah.lowerthirds::VideoInsert3AnimationController",
					"gshah.lowerthirds::VideoInsert4AnimationController",
					"gshah.lowerthirds::VideoInsert5AnimationController",
					"gshah.lowerthirds::VideoInsert6AnimationController",
					"gshah.lowerthirds::VideoInsert7AnimationController",
					"gshah.lowerthirds::VideoInsert8AnimationController",
					"gshah.lowerthirds::VideoInsert9AnimationController",
					"gshah.lowerthirds::ModernNavyLowerThird1AnimationController",
					"gshah.lowerthirds::ModernNavyLowerThird2AnimationController",
					"gshah.lowerthirds::ModernNavyLowerThird3AnimationController",
					"gshah.lowerthirds::ModernNavyLowerThird4AnimationController",
					"gshah.lowerthirds::ModernNavyLowerThird5AnimationController",
					"gshah.outros::Outro1AnimationController",
					"gshah.outros::Outro2AnimationController",
					"gshah.outros::Outro3AnimationController",
					"gshah.outros::Outro4AnimationController",
					"gshah.outros::Outro5AnimationController",
					"gshah.outros::Outro6AnimationController",
					"gshah.outros::Outro6aAnimationController",
					"gshah.outros::Outro6bAnimationController",
					"gshah.outros::Outro7AnimationController",
					"gshah.outros::Outro7aAnimationController",
					"gshah.outros::Outro8AnimationController",
					"gshah.outros::Outro9AnimationController",
					"gshah.outros::Outro10AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds1AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds2AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds3AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds4AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds5AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds6AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds7AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds8AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds9AnimationController",
					"gshah.lowerthirds::MinimalLowerThirds10AnimationController",
					"gshah.lowerthirds::FunLowerThirds1AnimationController",
					"gshah.lowerthirds::FunLowerThirds2AnimationController",
					"gshah.lowerthirds::FunLowerThirds3AnimationController",
					"gshah.lowerthirds::FunLowerThirds4AnimationController",
					"gshah.intros::MobileSlideshowAnimationController",
					"gshah.intros::TabletSlideshowAnimationController",
					"gshah.intros::AbstractSunshineAnimationController",
					"gshah.intros::OceanBreezeAnimationController",
					"gshah.intros::MotionSquashAnimationController",
					"gshah.intros::WebsiteSearchAnimationController",
					"gshah.intros::NatureAbstractAnimationController",
					"gshah.intros::NeonDanceAnimationController",
					"gshah.intros::FastAsTheWindAnimationController",
					"gshah.intros::LogoOnStringAnimationController",
					"gshah.intros::MobileSlideshowAnimationController",
					"gshah.intros::TabletSlideshowAnimationController",
					"gshah.intros::AbstractSunshineAnimationController",
					"gshah.intros::OceanBreezeAnimationController",
					"gshah.intros::MotionSquashAnimationController",
					"gshah.intros::WebsiteSearchAnimationController",
					"gshah.intros::NatureAbstractAnimationController",
					"gshah.intros::NeonDanceAnimationController",
					"gshah.intros::CorporateSimple2Logos2AnimationController",
					"gshah.intros::FastAsTheWindAnimationController",
					"gshah.intros::LogoOnStringAnimationController",
					"gshah.lowerthirds::MotionBlock1AnimationController",
					"gshah.lowerthirds::MotionBlock2AnimationController",
					"gshah.lowerthirds::MotionBlock3AnimationController",
					"gshah.lowerthirds::MotionBlock4AnimationController",
					"gshah.lowerthirds::MotionBlock5AnimationController",
					"gshah.lowerthirds::MotionBlock6AnimationController",
					"gshah.lowerthirds::MotionBlock7AnimationController",
					"gshah.lowerthirds::MotionBlock8AnimationController",
					"gshah.lowerthirds::MotionBlock9AnimationController",
					"gshah.lowerthirds::MotionBlock10AnimationController",
					"gshah.lowerthirds::MotionBlock11AnimationController",
					"gshah.lowerthirds::GreenNeonThinLines1AnimationController",
					"gshah.lowerthirds::GreenNeonThinLines2AnimationController",
					"gshah.lowerthirds::GreenNeonThinLines3AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds1AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds2AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds3AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds4AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds5AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds6AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds7AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds8AnimationController",
					"gshah.lowerthirds::SimpleLowerThirds9AnimationController",
					"gshah.intros::OldProjectorTextSlide1AnimationController",
					"gshah.intros::OldProjectorTextSlide2AnimationController",
					"gshah.intros::OldProjectorTextSlide3AnimationController",
					"gshah.intros::OldProjectorTextSlide4AnimationController",
					"gshah.intros::OldProjectorTextSlide5AnimationController",
					"gshah.intros::OldProjectorTextSlide6AnimationController",
					"gshah.intros::TextSlideModernConcept1AnimationController",
					"gshah.intros::TextSlideModernConcept2AnimationController",
					"gshah.intros::TextSlideModernConcept3AnimationController",
					"gshah.intros::TextSlideModernConcept4AnimationController",
					"gshah.intros::TextSlideModernConcept5AnimationController",
					"gshah.intros::SimpleTypography1AnimationController",
					"gshah.intros::SimpleTypography2AnimationController",
					"gshah.intros::SimpleTypography3AnimationController",
					"gshah.intros::SimpleTypography4AnimationController",
					"gshah.intros::SimpleTypography5AnimationController",
					"gshah.intros::SimpleTypography6AnimationController",
					"gshah.intros::FreshTextSlide1AnimationController",
					"gshah.intros::FreshTextSlide2AnimationController",
					"gshah.intros::FreshTextSlide3AnimationController",
					"gshah.intros::FreshTextSlide4AnimationController",
					"gshah.intros::FreshTextSlide5AnimationController",
					"gshah.intros::FreshTextSlide6AnimationController",
					"gshah.intros::FreshTextSlide7AnimationController",
					"gshah.intros::FreshTextSlide8AnimationController",
					"gshah.intros::FreshTextSlide9AnimationController",
					"gshah.intros::FreshTextSlide10AnimationController",
					"gshah.intros::FreshTextSlide11AnimationController",
					"gshah.intros::SmoothSlide1AnimationController",
					"gshah.intros::SmoothSlide2AnimationController",
					"gshah.intros::SmoothSlide3AnimationController",
					"gshah.intros::SmoothSlide4AnimationController",
					"gshah.intros::SmoothSlide5AnimationController",
					"gshah.intros::SmoothSlide6AnimationController",
					"gshah.intros::SmoothSlide7AnimationController",
					"gshah.intros::SmoothSlide8AnimationController",
					"gshah.intros::SmoothSlide9AnimationController",
					"gshah.intros::SmoothSlide10AnimationController",
					"gshah.intros::SmoothSlide11AnimationController",
					"gshah.intros::SmoothSlide12AnimationController",
					"gshah.intros::SmoothSlide13AnimationController",
					"gshah.intros::SmoothSlide14AnimationController",
					"gshah.intros::SmoothSlide15AnimationController",
					"gshah.intros::SmoothSlide16AnimationController",
					"gshah.intros::SmoothSlide17AnimationController",
					"gshah.intros::SmoothSlide18AnimationController",
					"gshah.intros::SmoothSlide19AnimationController",
					"gshah.intros::SmoothSlide20AnimationController",
					"gshah.intros::SmoothSlide21AnimationController",
					"gshah.intros::SmoothSlide22AnimationController",
					"gshah.intros::SmoothSlide23AnimationController",
					"gshah.intros::SmoothSlide24AnimationController",
					"gshah.intros::SmoothSlide25AnimationController",
					"gshah.intros::SmoothSlide26AnimationController",
					"gshah.intros::SmoothSlide27AnimationController",
					"gshah.intros::SmoothSlide28AnimationController",
					"gshah.intros::SmoothSlide29AnimationController",
					"gshah.intros::SmoothSlide30AnimationController",
					"gshah.intros::SmoothSlide31AnimationController",
					"gshah.intros::SmoothSlide32AnimationController",
					"gshah.intros::SmoothSlide33AnimationController",
					"gshah.intros::SmoothSlide34AnimationController",
					"gshah.intros::SmoothSlide35AnimationController",
					"gshah.intros::SmoothSlide36AnimationController",
					"gshah.intros::SmoothSlide37AnimationController",
					"gshah.intros::SmoothSlide38AnimationController",
					"gshah.intros::SmoothSlide39AnimationController",
					"gshah.intros::SmoothSlide40AnimationController",
					"gshah.intros::SmoothSlide41AnimationController",
					"gshah.intros::SmoothSlide42AnimationController",
					"gshah.intros::SmoothSlide43AnimationController",
					"gshah.intros::SmoothSlide44AnimationController",
					"gshah.intros::SmoothSlide45AnimationController",
					"gshah.lowerthirds::SwooshLines1AnimationController",
					"gshah.lowerthirds::SwooshLines2AnimationController",
					"gshah.lowerthirds::SwooshLines3AnimationController",
					"gshah.lowerthirds::SwooshLines4AnimationController",
					"gshah.lowerthirds::ThinLinedFrames1AnimationController",
					"gshah.lowerthirds::ThinLinedFrames2AnimationController",
					"gshah.lowerthirds::ThinLinedFrames3AnimationController",
					"gshah.lowerthirds::ThinLinesLowerThird1AnimationController",
					"gshah.lowerthirds::ThinLinesLowerThird2AnimationController",
					"gshah.lowerthirds::ThinLinesLowerThird3AnimationController",
					"gshah.lowerthirds::VideoMarketingLowerThird1AnimationController",
					"gshah.lowerthirds::VideoMarketingLowerThird2AnimationController",
					"gshah.lowerthirds::VideoMarketingLowerThird3AnimationController",
					"gshah.intros::LogoDesignerAnimationController",
					"gshah.intros::CloudyDaysAnimationController",
					"gshah.intros::PhotoStudioAnimationController",
					"gshah.intros::IsometricGlitchAnimationController",
					"gshah.intros::ColorfulOpenerAnimationController",
					"gshah.intros::MotionPlayAnimationController",
					"gshah.intros::AbstractWaterDropAnimationController",
					"gshah.intros::LogoCreatorAnimationController",
					"gshah.intros::ColorBlobAnimationController",
					"gshah.intros::BalloonDropAnimationController"
				];
				
			}
			return _animationAliases;
		}
		
		private var _animationClasses:Array;
		public function getAnimationClasses():Array
		{
			if(_animationClasses==null)
			{
				_animationClasses=[
					BlueCircleLogoAnimationController,
					BlueBublesLogoAnimationController,
					TechnoLogoAnimationController,
					FreshLogoStingAnimationController,
					GeometricLogoAnimationController,
					CorporateZoomLogoAnimationController,
					SideBounceAnimationController,
					WebsiteSearchLogoAnimationController,
					RocketLogoAnimationController,
					OrigamiStarLogoAnimationController,
					ScienceExperimentAnimationController,
					FlyingManAnimationController,
					FutureLogoAnimationController,
					MotionFlowLogoAnimationController,
					SpiderLogoAnimationController,
					MotionExperimentAnimationController,
					CountingSheepAnimationController,
					BouncingStarsLogoAnimationController,
					SlinkyTunnelAnimationController,
					SmartTechLoopAnimationController,
					GuitarLogoAnimationController,
					CorporateSleekAnimationController,
					SecretLoginAnimationController,
					MobileSMSAnimationController,
					RocketLaunchAnimationController,
					ExplosionAnimationController,
					DeliciousMotionAnimationController,
					ExtravagantLogoAnimationController,
					FunkyLogoStingAnimationController,
					CorporateSimple2LogosAnimationController,
					TabletSwipeAnimationController,
					SailingToAnIslandAnimationController,
					FireLogoStingAnimationController,
					ChristmasTimeAnimationController,
					LaptopInventionAnimationController,
					RockyMountainsSunRiseAnimationController,
					QuickSlideRevealAnimationController,
					ClickLogoAnimationController,
					FlyingPaperAnimationController,
					StickManAnimationController,
					CircleTurnLogoAnimationController,
					CorporateRevealAnimationController,
					DropLogoAnimationController,
					SimpleRevealAnimationController,
					NeonBurstAnimationController,
					InstagramLogoStingAnimationController,
					UnfoldLogoAnimationController,
					SpringLowerThird1AnimationController,
					SpringLowerThird2AnimationController,
					SpringLowerThird3AnimationController,
					SpringLowerThird4AnimationController,
					SpringLowerThird5AnimationController,
					CorporateLowerThird1AnimationController,
					CorporateLowerThird2AnimationController,
					CorporateLowerThird3AnimationController,
					CorporateLowerThird4AnimationController,
					CorporateLowerThird5AnimationController,
					RetroLowerThird1AnimationController,
					RetroLowerThird2AnimationController,
					RetroLowerThird3AnimationController,
					RetroLowerThird4AnimationController,
					RetroLowerThird5AnimationController,
					RetroLowerThird6AnimationController,
					RetroLowerThird7AnimationController,
					ModernLowerThird1AnimationController,
					ModernLowerThird2AnimationController,
					ModernLowerThird3AnimationController,
					ModernLowerThird4AnimationController,
					ModernLowerThird5AnimationController,
					ModernLowerThird6AnimationController,
					ModernLowerThird7AnimationController,
					GlitchCinematicTitlesLowerThird1AnimationController,
					GlitchCinematicTitlesLowerThird2AnimationController,
					GlitchCinematicTitlesLowerThird3AnimationController,
					GlitchCinematicTitlesLowerThird4AnimationController,
					GlitchCinematicTitlesLowerThird5AnimationController,
					GlitchCinematicTitlesLowerThird6AnimationController,
					GlitchCinematicTitlesLowerThird7AnimationController,
					GlitchCinematicTitlesLowerThird8AnimationController,
					GlitchCinematicTitlesLowerThird9AnimationController,
					GlitchCinematicTitlesLowerThird10AnimationController,
					GlitchCinematicTitlesLowerThird11AnimationController,
					GlitchCinematicTitlesLowerThird12AnimationController,
					GlitchCinematicTitlesLowerThird13AnimationController,
					CleanLowerThird1AnimationController,
					CleanLowerThird2AnimationController,
					CleanLowerThird3AnimationController,
					CleanLowerThird4AnimationController,
					VideoInsert1AnimationController,
					VideoInsert2AnimationController,
					VideoInsert3AnimationController,
					VideoInsert4AnimationController,
					VideoInsert5AnimationController,
					VideoInsert6AnimationController,
					VideoInsert7AnimationController,
					VideoInsert8AnimationController,
					VideoInsert9AnimationController,
					ModernNavyLowerThird1AnimationController,
					ModernNavyLowerThird2AnimationController,
					ModernNavyLowerThird3AnimationController,
					ModernNavyLowerThird4AnimationController,
					ModernNavyLowerThird5AnimationController,
					Outro1AnimationController,
					Outro2AnimationController,
					Outro3AnimationController,
					Outro4AnimationController,
					Outro5AnimationController,
					Outro6AnimationController,
					Outro6aAnimationController,
					Outro6bAnimationController,
					Outro7AnimationController,
					Outro7aAnimationController,
					Outro8AnimationController,
					Outro9AnimationController,
					Outro10AnimationController,
					MinimalLowerThirds1AnimationController,
					MinimalLowerThirds2AnimationController,
					MinimalLowerThirds3AnimationController,
					MinimalLowerThirds4AnimationController,
					MinimalLowerThirds5AnimationController,
					MinimalLowerThirds6AnimationController,
					MinimalLowerThirds7AnimationController,
					MinimalLowerThirds8AnimationController,
					MinimalLowerThirds9AnimationController,
					MinimalLowerThirds10AnimationController,
					FunLowerThirds1AnimationController,
					FunLowerThirds2AnimationController,
					FunLowerThirds3AnimationController,
					FunLowerThirds4AnimationController,
					MobileSlideshowAnimationController,
					TabletSlideshowAnimationController,
					AbstractSunshineAnimationController,
					OceanBreezeAnimationController,
					MotionSquashAnimationController,
					WebsiteSearchAnimationController,
					NatureAbstractAnimationController,
					NeonDanceAnimationController,
					FastAsTheWindAnimationController,
					LogoOnStringAnimationController,
					MobileSlideshowAnimationController,
					TabletSlideshowAnimationController,
					AbstractSunshineAnimationController,
					OceanBreezeAnimationController,
					MotionSquashAnimationController,
					WebsiteSearchAnimationController,
					NatureAbstractAnimationController,
					NeonDanceAnimationController,
					CorporateSimple2Logos2AnimationController,
					FastAsTheWindAnimationController,
					LogoOnStringAnimationController,
					MotionBlock1AnimationController,
					MotionBlock2AnimationController,
					MotionBlock3AnimationController,
					MotionBlock4AnimationController,
					MotionBlock5AnimationController,
					MotionBlock6AnimationController,
					MotionBlock7AnimationController,
					MotionBlock8AnimationController,
					MotionBlock9AnimationController,
					MotionBlock10AnimationController,
					MotionBlock11AnimationController,
					GreenNeonThinLines1AnimationController,
					GreenNeonThinLines2AnimationController,
					GreenNeonThinLines3AnimationController,
					SimpleLowerThirds1AnimationController,
					SimpleLowerThirds2AnimationController,
					SimpleLowerThirds3AnimationController,
					SimpleLowerThirds4AnimationController,
					SimpleLowerThirds5AnimationController,
					SimpleLowerThirds6AnimationController,
					SimpleLowerThirds7AnimationController,
					SimpleLowerThirds8AnimationController,
					SimpleLowerThirds9AnimationController,
					OldProjectorTextSlide1AnimationController,
					OldProjectorTextSlide2AnimationController,
					OldProjectorTextSlide3AnimationController,
					OldProjectorTextSlide4AnimationController,
					OldProjectorTextSlide5AnimationController,
					OldProjectorTextSlide6AnimationController,					
					TextSlideModernConcept1AnimationController,
					TextSlideModernConcept2AnimationController,
					TextSlideModernConcept3AnimationController,
					TextSlideModernConcept4AnimationController,
					TextSlideModernConcept5AnimationController,
					SimpleTypography1AnimationController,
					SimpleTypography2AnimationController,
					SimpleTypography3AnimationController,
					SimpleTypography4AnimationController,
					SimpleTypography5AnimationController,
					SimpleTypography6AnimationController,
					FreshTextSlide1AnimationController,
					FreshTextSlide2AnimationController,
					FreshTextSlide3AnimationController,
					FreshTextSlide4AnimationController,
					FreshTextSlide5AnimationController,
					FreshTextSlide6AnimationController,
					FreshTextSlide7AnimationController,
					FreshTextSlide8AnimationController,
					FreshTextSlide9AnimationController,
					FreshTextSlide10AnimationController,
					FreshTextSlide11AnimationController,
					SmoothSlide1AnimationController,
					SmoothSlide2AnimationController,
					SmoothSlide3AnimationController,
					SmoothSlide4AnimationController,
					SmoothSlide5AnimationController,
					SmoothSlide6AnimationController,
					SmoothSlide7AnimationController,
					SmoothSlide8AnimationController,
					SmoothSlide9AnimationController,
					SmoothSlide10AnimationController,
					SmoothSlide11AnimationController,
					SmoothSlide12AnimationController,
					SmoothSlide13AnimationController,
					SmoothSlide14AnimationController,
					SmoothSlide15AnimationController,
					SmoothSlide16AnimationController,
					SmoothSlide17AnimationController,
					SmoothSlide18AnimationController,
					SmoothSlide19AnimationController,
					SmoothSlide20AnimationController,
					SmoothSlide21AnimationController,
					SmoothSlide22AnimationController,
					SmoothSlide23AnimationController,
					SmoothSlide24AnimationController,
					SmoothSlide25AnimationController,
					SmoothSlide26AnimationController,
					SmoothSlide27AnimationController,
					SmoothSlide28AnimationController,
					SmoothSlide29AnimationController,
					SmoothSlide30AnimationController,
					SmoothSlide31AnimationController,
					SmoothSlide32AnimationController,
					SmoothSlide33AnimationController,
					SmoothSlide34AnimationController,
					SmoothSlide35AnimationController,
					SmoothSlide36AnimationController,
					SmoothSlide37AnimationController,
					SmoothSlide38AnimationController,
					SmoothSlide39AnimationController,
					SmoothSlide40AnimationController,
					SmoothSlide41AnimationController,
					SmoothSlide42AnimationController,
					SmoothSlide43AnimationController,
					SmoothSlide44AnimationController,
					SmoothSlide45AnimationController,
					SwooshLines1AnimationController,
					SwooshLines2AnimationController,
					SwooshLines3AnimationController,
					SwooshLines4AnimationController,
					ThinLinedFrames1AnimationController,
					ThinLinedFrames2AnimationController,
					ThinLinedFrames3AnimationController,
					ThinLinesLowerThird1AnimationController,
					ThinLinesLowerThird2AnimationController,
					ThinLinesLowerThird3AnimationController,
					VideoMarketingLowerThird1AnimationController,
					VideoMarketingLowerThird2AnimationController,
					VideoMarketingLowerThird3AnimationController,
					LogoDesignerAnimationController,
					CloudyDaysAnimationController,
					PhotoStudioAnimationController,
					IsometricGlitchAnimationController,
					ColorfulOpenerAnimationController,
					MotionPlayAnimationController,
					AbstractWaterDropAnimationController,
					LogoCreatorAnimationController,
					ColorBlobAnimationController,
					BalloonDropAnimationController
				];
				
			}
			return _animationClasses;
		}
		
		public function getAnimationById(id:int):IGshahAnimationController
		{
			return (new (getAnimationClasses()[id])) as IGshahAnimationController;
		}
		public function getAnimationId(o:Object):int
		{
			return getAnimationAliases().indexOf(getQualifiedClassName(o));
		}
		
		public function isLowerThird(id:int):Boolean
		{
			return String(getAnimationAliases()[id]).indexOf('gshah.lowerthirds::')==0;
		}
		public function isOutro(id:int):Boolean
		{
			return String(getAnimationAliases()[id]).indexOf('gshah.outros::')==0;
		}
		public function isIntro(id:int):Boolean
		{
			return String(getAnimationAliases()[id]).indexOf('gshah.intros::')==0;
		}
		
		private var _textSlidesDataProvider:ArrayList;
		
		public function getTextSlidesDataProvider():ArrayList
		{
			if(_textSlidesDataProvider==null)
			{
				_textSlidesDataProvider=new ArrayList([
					new GshahAnimationLibraryItem('Old Projector Text Slide 1',OldProjectorTextSlide1AnimationController, 0x000000),
					new GshahAnimationLibraryItem('Old Projector Text Slide 2',OldProjectorTextSlide2AnimationController, 0x000000),
					new GshahAnimationLibraryItem('Old Projector Text Slide 3',OldProjectorTextSlide3AnimationController, 0x000000),
					new GshahAnimationLibraryItem('Old Projector Text Slide 4',OldProjectorTextSlide4AnimationController, 0x000000),
					new GshahAnimationLibraryItem('Old Projector Text Slide 5',OldProjectorTextSlide5AnimationController, 0x000000),
					new GshahAnimationLibraryItem('Old Projector Text Slide 6',OldProjectorTextSlide6AnimationController, 0x000000),
					new GshahAnimationLibraryItem('Text Slide Modern Concept 1',TextSlideModernConcept1AnimationController, 0xE56262),
					new GshahAnimationLibraryItem('Text Slide Modern Concept 2',TextSlideModernConcept2AnimationController, 0xE56262),
					new GshahAnimationLibraryItem('Text Slide Modern Concept 3',TextSlideModernConcept3AnimationController, 0xE56262),
					new GshahAnimationLibraryItem('Text Slide Modern Concept 4',TextSlideModernConcept4AnimationController, 0xE56262),
					new GshahAnimationLibraryItem('Text Slide Modern Concept 5',TextSlideModernConcept5AnimationController, 0xE56262),
					new GshahAnimationLibraryItem('Simple Typography 1',SimpleTypography1AnimationController, 0x3F8DF7),
					new GshahAnimationLibraryItem('Simple Typography 2',SimpleTypography2AnimationController, 0x3F8DF7),
					new GshahAnimationLibraryItem('Simple Typography 3',SimpleTypography3AnimationController, 0x3F8DF7),
					new GshahAnimationLibraryItem('Simple Typography 4',SimpleTypography4AnimationController, 0x3F8DF7),
					new GshahAnimationLibraryItem('Simple Typography 5',SimpleTypography5AnimationController, 0x3F8DF7),
					new GshahAnimationLibraryItem('Simple Typography 6',SimpleTypography6AnimationController, 0x3F8DF7),
					new GshahAnimationLibraryItem('Fresh Text Slide 1',FreshTextSlide1AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 2',FreshTextSlide2AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 3',FreshTextSlide3AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 4',FreshTextSlide4AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 5',FreshTextSlide5AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 6',FreshTextSlide6AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 7',FreshTextSlide7AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 8',FreshTextSlide8AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 9',FreshTextSlide9AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 10',FreshTextSlide10AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Fresh Text Slide 11',FreshTextSlide11AnimationController, 0x002131),
					new GshahAnimationLibraryItem('Smooth Slide 1',SmoothSlide1AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 2',SmoothSlide2AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 3',SmoothSlide3AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 4',SmoothSlide4AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 5',SmoothSlide5AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 6',SmoothSlide6AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 7',SmoothSlide7AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 8',SmoothSlide8AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 9',SmoothSlide9AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 10',SmoothSlide10AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 11',SmoothSlide11AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 12',SmoothSlide12AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 13',SmoothSlide13AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 14',SmoothSlide14AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 15',SmoothSlide15AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 16',SmoothSlide16AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 17',SmoothSlide17AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 18',SmoothSlide18AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 19',SmoothSlide19AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 20',SmoothSlide20AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 21',SmoothSlide21AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 22',SmoothSlide22AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 23',SmoothSlide23AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 24',SmoothSlide24AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 25',SmoothSlide25AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 26',SmoothSlide26AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 27',SmoothSlide27AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 28',SmoothSlide28AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 29',SmoothSlide29AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 30',SmoothSlide30AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 31',SmoothSlide31AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 32',SmoothSlide32AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 33',SmoothSlide33AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 34',SmoothSlide34AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 35',SmoothSlide35AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 36',SmoothSlide36AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 37',SmoothSlide37AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 38',SmoothSlide38AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 39',SmoothSlide39AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 40',SmoothSlide40AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 41',SmoothSlide41AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 42',SmoothSlide42AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 43',SmoothSlide43AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 44',SmoothSlide44AnimationController, 0x5C7383),
					new GshahAnimationLibraryItem('Smooth Slide 45',SmoothSlide45AnimationController, 0x5C7383)
				]);
			}
			return _textSlidesDataProvider;
		}
		private var _introsDataProvider:ArrayList;
		private var _introsOtoDataProvider:ArrayList;
		
		public function getIntrosDataProvider():ArrayList
		{
			if(_introsDataProvider==null)
			{
				_introsDataProvider=new ArrayList([
					new GshahAnimationLibraryItem('Fresh Logo Sting',FreshLogoStingAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Geometric Logo',GeometricLogoAnimationController,0x73FF73),
					new GshahAnimationLibraryItem('Corporate Zoom',CorporateZoomLogoAnimationController,0xDEDEDE),
					new GshahAnimationLibraryItem('Side Bounce',SideBounceAnimationController,0xBDDEEF),
					new GshahAnimationLibraryItem('Website Search',WebsiteSearchLogoAnimationController,0xEF3939),
					new GshahAnimationLibraryItem('Flying Rockets',RocketLogoAnimationController,0x002152),
					new GshahAnimationLibraryItem('Origami Star Logo',OrigamiStarLogoAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Science Experiment',ScienceExperimentAnimationController,0xC6DEDE),
					new GshahAnimationLibraryItem('Flying Man',FlyingManAnimationController,0x21ADD6),
					new GshahAnimationLibraryItem('Future Logo',FutureLogoAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Motion Flow',MotionFlowLogoAnimationController,0x314231),
					new GshahAnimationLibraryItem('Spider Web',SpiderLogoAnimationController,0xCED6DE),
					new GshahAnimationLibraryItem('Motion Experiment',MotionExperimentAnimationController,0x000000),
					new GshahAnimationLibraryItem('Counting Sheep',CountingSheepAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Bouncing Stars',BouncingStarsLogoAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Slinky Tunnel',SlinkyTunnelAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Smart Tech Loop',SmartTechLoopAnimationController,0x000000),
					new GshahAnimationLibraryItem('Guitar Strum',GuitarLogoAnimationController,0x3194FF),
					new GshahAnimationLibraryItem('Corporate Sleek',CorporateSleekAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Secret Login',SecretLoginAnimationController,0x214252),
					new GshahAnimationLibraryItem('Mobile SMS',MobileSMSAnimationController,0x73CE52),
					new GshahAnimationLibraryItem('Rocket Launch',RocketLaunchAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Explosion',ExplosionAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Neon Burst',NeonBurstAnimationController,0x002129),
					new GshahAnimationLibraryItem('Delicious Motion',DeliciousMotionAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Extravagant Opener',ExtravagantLogoAnimationController,0x000000),
					new GshahAnimationLibraryItem('Tablet Swipe',TabletSwipeAnimationController,0xD6D6D6),
					new GshahAnimationLibraryItem('Sailing To An Island',SailingToAnIslandAnimationController,0xffffff),
					new GshahAnimationLibraryItem('Fire Logo Sting',FireLogoStingAnimationController,0x394A63),
					new GshahAnimationLibraryItem('It\'s Christmas Time',ChristmasTimeAnimationController,0x00A5DE),
					new GshahAnimationLibraryItem('Laptop Invention',LaptopInventionAnimationController,0xF75A5A),
					new GshahAnimationLibraryItem('Abstract Retro',FunkyLogoStingAnimationController,0xE7E7E7),
					new GshahAnimationLibraryItem('Simple Corporate Opener',CorporateSimple2LogosAnimationController,0x212939),
					new GshahAnimationLibraryItem('Rocky Mountains Sun Rise',RockyMountainsSunRiseAnimationController,0xE7A508),
					new GshahAnimationLibraryItem('Quick Slide Reveal',QuickSlideRevealAnimationController,0xffffff)
				]);
			}
			if(SystemSettings.licensingType==SystemSettings.LICENSING_TYPE_OTO1DOWNSELL||SystemSettings.licensingType==SystemSettings.LICENSING_TYPE_OTO1)
			{
				if(_introsOtoDataProvider==null)
				{
					_introsOtoDataProvider=new ArrayList([
						new GshahAnimationLibraryItem('Mobile Slideshow',MobileSlideshowAnimationController,0x8C8C8C),
						new GshahAnimationLibraryItem('Tablet Slideshow',TabletSlideshowAnimationController,0xEFEFEF),
						new GshahAnimationLibraryItem('Abstract Sunshine',AbstractSunshineAnimationController,0xBDCECE),
						new GshahAnimationLibraryItem('Ocean Breeze',OceanBreezeAnimationController,0xB5C6C6),
						new GshahAnimationLibraryItem('Motion Squash',MotionSquashAnimationController,0xEFCEA5),
						new GshahAnimationLibraryItem('Website Search',WebsiteSearchAnimationController,0x9C6B42),
						new GshahAnimationLibraryItem('Techno Zoom',TechnoLogoAnimationController,0x081029),
						new GshahAnimationLibraryItem('Nature Abstract',NatureAbstractAnimationController,0xEFAD10),
						new GshahAnimationLibraryItem('Neon Dance',NeonDanceAnimationController,0x081029),
						new GshahAnimationLibraryItem('Corporate Simple Logo',CorporateSimple2Logos2AnimationController,0xffffff),
						new GshahAnimationLibraryItem('Fast As The Wind',FastAsTheWindAnimationController,0x39BDC6),
						new GshahAnimationLibraryItem('Logo On String',LogoOnStringAnimationController,0xEFCECE),
						new GshahAnimationLibraryItem('Logo Designer',LogoDesignerAnimationController, 0x6B6B6B),
						new GshahAnimationLibraryItem('Cloudy Days',CloudyDaysAnimationController, 0xFFFFFF),
						new GshahAnimationLibraryItem('Photo Studio',PhotoStudioAnimationController, 0xEFEFEF),
						new GshahAnimationLibraryItem('Isometric Glitch',IsometricGlitchAnimationController, 0x000000),
						new GshahAnimationLibraryItem('Colorful Opener',ColorfulOpenerAnimationController, 0xEF9400),
						new GshahAnimationLibraryItem('Motion Play',MotionPlayAnimationController, 0x214A63),
						new GshahAnimationLibraryItem('Abstract Water Drop',AbstractWaterDropAnimationController, 0x000000),
						new GshahAnimationLibraryItem('Logo Creator',LogoCreatorAnimationController, 0xF7F7F7),
						new GshahAnimationLibraryItem('Color Blob',ColorBlobAnimationController, 0xF7F7F7),
						new GshahAnimationLibraryItem('Balloon Drop',BalloonDropAnimationController, 0xA5CEDE)]);
				}
				return new ArrayList(_introsDataProvider.source.concat(_introsOtoDataProvider.source));
			}
			else
			{
				return _introsDataProvider;
			}
			
		}
		private var _lowerTirdsDataProvider:ArrayList;
		private var _lowerTirdsOtoDataProvider:ArrayList;
		
		public function getLowerThirdsDataProvider():ArrayList
		{
			if(_lowerTirdsDataProvider==null)
			{
				_lowerTirdsDataProvider=new ArrayList([
					new GshahAnimationLibraryItem('Spring Lower Third 1',SpringLowerThird1AnimationController),
					new GshahAnimationLibraryItem('Spring Lower Third 2',SpringLowerThird2AnimationController),
					new GshahAnimationLibraryItem('Spring Lower Third 3',SpringLowerThird3AnimationController),
					new GshahAnimationLibraryItem('Spring Lower Third 4',SpringLowerThird4AnimationController),
					new GshahAnimationLibraryItem('Spring Lower Third 5',SpringLowerThird5AnimationController),
					/*new GshahAnimationLibraryItem('Corporate Lower Third 1',CorporateLowerThird1AnimationController),
					new GshahAnimationLibraryItem('Corporate Lower Third 2',CorporateLowerThird2AnimationController),
					new GshahAnimationLibraryItem('Corporate Lower Third 3',CorporateLowerThird3AnimationController),
					new GshahAnimationLibraryItem('Corporate Lower Third 4',CorporateLowerThird4AnimationController),
					new GshahAnimationLibraryItem('Corporate Lower Third 5',CorporateLowerThird5AnimationController),*/
					new GshahAnimationLibraryItem('Retro Lower Third 1',RetroLowerThird1AnimationController),
					new GshahAnimationLibraryItem('Retro Lower Third 2',RetroLowerThird2AnimationController),
					new GshahAnimationLibraryItem('Retro Lower Third 3',RetroLowerThird3AnimationController),
					new GshahAnimationLibraryItem('Retro Lower Third 4',RetroLowerThird4AnimationController),
					new GshahAnimationLibraryItem('Retro Lower Third 5',RetroLowerThird5AnimationController),
					new GshahAnimationLibraryItem('Retro Lower Third 6',RetroLowerThird6AnimationController),
					new GshahAnimationLibraryItem('Retro Lower Third 7',RetroLowerThird7AnimationController),
					new GshahAnimationLibraryItem('Modern Lower Third 1',ModernLowerThird1AnimationController),
					new GshahAnimationLibraryItem('Modern Lower Third 2',ModernLowerThird2AnimationController),
					new GshahAnimationLibraryItem('Modern Lower Third 3',ModernLowerThird3AnimationController),
					new GshahAnimationLibraryItem('Modern Lower Third 4',ModernLowerThird4AnimationController),
					new GshahAnimationLibraryItem('Modern Lower Third 5',ModernLowerThird5AnimationController),
					new GshahAnimationLibraryItem('Modern Lower Third 6',ModernLowerThird6AnimationController),
					new GshahAnimationLibraryItem('Modern Lower Third 7',ModernLowerThird7AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 1',GlitchCinematicTitlesLowerThird1AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 2',GlitchCinematicTitlesLowerThird2AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 3',GlitchCinematicTitlesLowerThird3AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 4',GlitchCinematicTitlesLowerThird4AnimationController),
					//new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 5',GlitchCinematicTitlesLowerThird5AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 5',GlitchCinematicTitlesLowerThird6AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 6',GlitchCinematicTitlesLowerThird7AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 7',GlitchCinematicTitlesLowerThird8AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 8',GlitchCinematicTitlesLowerThird9AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 9',GlitchCinematicTitlesLowerThird10AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 10',GlitchCinematicTitlesLowerThird11AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 11',GlitchCinematicTitlesLowerThird12AnimationController),
					new GshahAnimationLibraryItem('Glitch Cinematic Titles Lower Third 12',GlitchCinematicTitlesLowerThird13AnimationController),
					/*new GshahAnimationLibraryItem('Video Insert 1',VideoInsert1AnimationController, 0.2),*/
					/*new GshahAnimationLibraryItem('Video Insert 1',VideoInsert2AnimationController, 0.2),
					new GshahAnimationLibraryItem('Video Insert 2',VideoInsert3AnimationController),
					new GshahAnimationLibraryItem('Video Insert 3',VideoInsert4AnimationController),
					new GshahAnimationLibraryItem('Video Insert 4',VideoInsert5AnimationController),
					new GshahAnimationLibraryItem('Video Insert 5',VideoInsert6AnimationController),
					new GshahAnimationLibraryItem('Video Insert 6',VideoInsert7AnimationController),
					new GshahAnimationLibraryItem('Video Insert 7',VideoInsert8AnimationController),
					new GshahAnimationLibraryItem('Video Insert 8',VideoInsert9AnimationController),
					new GshahAnimationLibraryItem('Modern Navy LowerThird 1',ModernNavyLowerThird1AnimationController),
					new GshahAnimationLibraryItem('Modern Navy LowerThird 2',ModernNavyLowerThird2AnimationController),
					new GshahAnimationLibraryItem('Modern Navy LowerThird 3',ModernNavyLowerThird3AnimationController),
					new GshahAnimationLibraryItem('Modern Navy LowerThird 4',ModernNavyLowerThird4AnimationController),
					new GshahAnimationLibraryItem('Modern Navy LowerThird 5',ModernNavyLowerThird5AnimationController)*/
					new GshahAnimationLibraryItem('Minimal Lower Third Blue 1',MinimalLowerThirds1AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Blue 2',MinimalLowerThirds2AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Blue 3',MinimalLowerThirds3AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Blue 4',MinimalLowerThirds4AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Blue 5',MinimalLowerThirds5AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Green 1',MinimalLowerThirds6AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Green 2',MinimalLowerThirds7AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Green 3',MinimalLowerThirds8AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Green 4',MinimalLowerThirds9AnimationController),
					new GshahAnimationLibraryItem('Minimal Lower Third Green 5',MinimalLowerThirds10AnimationController),
					new GshahAnimationLibraryItem('Fun Lower Third 1',FunLowerThirds1AnimationController),
					new GshahAnimationLibraryItem('Fun Lower Third 2',FunLowerThirds2AnimationController),
					new GshahAnimationLibraryItem('Fun Lower Third 3',FunLowerThirds3AnimationController),
					new GshahAnimationLibraryItem('Fun Lower Third 4',FunLowerThirds4AnimationController)]);
				
			}
			if(SystemSettings.licensingType==SystemSettings.LICENSING_TYPE_OTO1DOWNSELL||SystemSettings.licensingType==SystemSettings.LICENSING_TYPE_OTO1)
			{
				if(_lowerTirdsOtoDataProvider==null)
				{
					_lowerTirdsOtoDataProvider=new ArrayList([
						new GshahAnimationLibraryItem('Clean LowerThird 1',CleanLowerThird1AnimationController),
						new GshahAnimationLibraryItem('Clean LowerThird 2',CleanLowerThird2AnimationController),
						new GshahAnimationLibraryItem('Clean LowerThird 3',CleanLowerThird3AnimationController),
						new GshahAnimationLibraryItem('Clean LowerThird 4',CleanLowerThird4AnimationController),
						new GshahAnimationLibraryItem('Motion Block 1',MotionBlock1AnimationController),
						new GshahAnimationLibraryItem('Motion Block 2',MotionBlock2AnimationController),
						new GshahAnimationLibraryItem('Motion Block 3',MotionBlock3AnimationController),
						new GshahAnimationLibraryItem('Motion Block 4',MotionBlock4AnimationController),
						new GshahAnimationLibraryItem('Motion Block 5',MotionBlock5AnimationController),
						new GshahAnimationLibraryItem('Motion Block 6',MotionBlock6AnimationController),
						new GshahAnimationLibraryItem('Motion Block 7',MotionBlock7AnimationController),
						new GshahAnimationLibraryItem('Motion Block 8',MotionBlock8AnimationController),
						new GshahAnimationLibraryItem('Motion Block 9',MotionBlock9AnimationController),
						new GshahAnimationLibraryItem('Motion Block 10',MotionBlock10AnimationController),
						new GshahAnimationLibraryItem('Motion Block 11',MotionBlock11AnimationController),
						new GshahAnimationLibraryItem('Green Neon Thin Lines 1',GreenNeonThinLines1AnimationController),
						new GshahAnimationLibraryItem('Green Neon Thin Lines 2',GreenNeonThinLines2AnimationController),
						new GshahAnimationLibraryItem('Green Neon Thin Lines 3',GreenNeonThinLines3AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 1',SimpleLowerThirds1AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 2',SimpleLowerThirds2AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 3',SimpleLowerThirds3AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 4',SimpleLowerThirds4AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 5',SimpleLowerThirds5AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 6',SimpleLowerThirds6AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 7',SimpleLowerThirds7AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 8',SimpleLowerThirds8AnimationController),
						new GshahAnimationLibraryItem('Simple Lower Thirds 9',SimpleLowerThirds9AnimationController),
						new GshahAnimationLibraryItem('Swoosh Lines 1',SwooshLines1AnimationController),
						new GshahAnimationLibraryItem('Swoosh Lines 2',SwooshLines2AnimationController),
						new GshahAnimationLibraryItem('Swoosh Lines 3',SwooshLines3AnimationController),
						new GshahAnimationLibraryItem('Swoosh Lines 4',SwooshLines4AnimationController),
						new GshahAnimationLibraryItem('Thin Lined Frames 1',ThinLinedFrames1AnimationController),
						new GshahAnimationLibraryItem('Thin Lined Frames 2',ThinLinedFrames2AnimationController),
						new GshahAnimationLibraryItem('Thin Lined Frames 3',ThinLinedFrames3AnimationController),
						new GshahAnimationLibraryItem('Thin Lines Lower Third 1',ThinLinesLowerThird1AnimationController),
						new GshahAnimationLibraryItem('Thin Lines Lower Third 2',ThinLinesLowerThird2AnimationController),
						new GshahAnimationLibraryItem('Thin Lines Lower Third 3',ThinLinesLowerThird3AnimationController),
						new GshahAnimationLibraryItem('Video Marketing Lower Third 1',VideoMarketingLowerThird1AnimationController),
						new GshahAnimationLibraryItem('Video Marketing Lower Third 2',VideoMarketingLowerThird2AnimationController),
						new GshahAnimationLibraryItem('Video Marketing Lower Third 3',VideoMarketingLowerThird3AnimationController)]);
				}
				return new ArrayList(_lowerTirdsDataProvider.source.concat(_lowerTirdsOtoDataProvider.source));
			}
			else
			{
				return _lowerTirdsDataProvider;
				
			}
		}
		
		private var _outrosDataProvider:ArrayList;
		public function getOutrosDataProvider():ArrayList
		{
			if(_outrosDataProvider==null)
			{
				_outrosDataProvider=new ArrayList([new GshahAnimationLibraryItem('Motion Zoom Outro',Outro1AnimationController),
					new GshahAnimationLibraryItem('Hanging Out',Outro2AnimationController),
					new GshahAnimationLibraryItem('Presenting',Outro3AnimationController),
					new GshahAnimationLibraryItem('Spin',Outro4AnimationController),
					new GshahAnimationLibraryItem('Slip\'n\'Slide',Outro5AnimationController),
					new GshahAnimationLibraryItem('Twitter Bird Navy',Outro6AnimationController),
					new GshahAnimationLibraryItem('Twitter Bird Dark',Outro6aAnimationController),
					new GshahAnimationLibraryItem('Twitter Bird Red',Outro6bAnimationController),
					new GshahAnimationLibraryItem('Modern Tech Outro (Aqua)',Outro7AnimationController),
					new GshahAnimationLibraryItem('Modern Tech Outro (Pink)',Outro7aAnimationController),
					new GshahAnimationLibraryItem('Children\'s Outro',Outro8AnimationController),
					new GshahAnimationLibraryItem('Stickie Notes',Outro9AnimationController),
					new GshahAnimationLibraryItem('Pattern Change',Outro10AnimationController)]);
			}
			return _outrosDataProvider;
		}
	}
}