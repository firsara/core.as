package core.ui
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import org.bytearray.gif.player.GIFPlayer;
	
	public class Activity extends Sprite
	{
		// ASSETS
		[Embed(source="/lib/ui/ajax/ajax.arrows.gif", mimeType="application/octet-stream")]         private static const ajaxArrows:Class;
		[Embed(source="/lib/ui/ajax/ajax.bar.gif", mimeType="application/octet-stream")]            private static const ajaxBar:Class;
		[Embed(source="/lib/ui/ajax/ajax.bar2.gif", mimeType="application/octet-stream")]           private static const ajaxBar2:Class;
		[Embed(source="/lib/ui/ajax/ajax.bert.gif", mimeType="application/octet-stream")]           private static const ajaxBert:Class;
		[Embed(source="/lib/ui/ajax/ajax.bert2.gif", mimeType="application/octet-stream")]          private static const ajaxBert2:Class;
		[Embed(source="/lib/ui/ajax/ajax.big.roller.gif", mimeType="application/octet-stream")]     private static const ajaxBigRoller:Class;
		[Embed(source="/lib/ui/ajax/ajax.big.snake.gif", mimeType="application/octet-stream")]      private static const ajaxBigSnake:Class;
		[Embed(source="/lib/ui/ajax/ajax.bouncing.ball.gif", mimeType="application/octet-stream")]  private static const ajaxBouncingBall:Class;
		[Embed(source="/lib/ui/ajax/ajax.circle.ball.gif", mimeType="application/octet-stream")]    private static const ajaxCircleBall:Class;
		[Embed(source="/lib/ui/ajax/ajax.facebook.gif", mimeType="application/octet-stream")]       private static const ajaxFacebook:Class;
		[Embed(source="/lib/ui/ajax/ajax.indicator.big.gif", mimeType="application/octet-stream")]  private static const ajaxIndicatorBig:Class;
		[Embed(source="/lib/ui/ajax/ajax.indicator.gif", mimeType="application/octet-stream")]      private static const ajaxIndicator:Class;
		[Embed(source="/lib/ui/ajax/ajax.indicator.lite.gif", mimeType="application/octet-stream")] private static const ajaxIndicatorLite:Class;
		[Embed(source="/lib/ui/ajax/ajax.kit.gif", mimeType="application/octet-stream")]            private static const ajaxKit:Class;
		[Embed(source="/lib/ui/ajax/ajax.roller.gif", mimeType="application/octet-stream")]         private static const ajaxRoller:Class;
		[Embed(source="/lib/ui/ajax/ajax.smallwait.gif", mimeType="application/octet-stream")]      private static const ajaxSmallwait:Class;
		[Embed(source="/lib/ui/ajax/ajax.snake.gif", mimeType="application/octet-stream")]          private static const ajaxSnake:Class;
		[Embed(source="/lib/ui/ajax/ajax.wheel.throbber.gif", mimeType="application/octet-stream")] private static const ajaxWheelThrobber:Class;
		
		public static const ARROWS         :String = 'arrows';
		public static const BAR            :String = 'bar';
		public static const BAR2           :String = 'bar2';
		public static const BERT           :String = 'bert';
		public static const BERT2          :String = 'bert2';
		public static const BIG_ROLLER     :String = 'bigRoller';
		public static const BIG_SNAKE      :String = 'bigSnake';
		public static const BOUNCING_BALL  :String = 'bouncingBall';
		public static const CIRCLE_BALL    :String = 'circleBall';
		public static const FACEBOOK       :String = 'facebook';
		public static const INDICATOR_BIG  :String = 'indicatorBig';
		public static const INDICATOR      :String = 'indicator';
		public static const INDICATOR_LITE :String = 'indicatorLite';
		public static const KIT            :String = 'kit';
		public static const ROLLER         :String = 'roller';
		public static const SMALLWAIT      :String = 'smallwait';
		public static const SNAKE          :String = 'snake';
		public static const WHEEL_THROBBER :String = 'wheelThrobber';
		
		
		public static function get(activityType:String = 'indicator'):Activity
		{
			return new Activity(activityType);
		}
		
		public function Activity(activityType:String = 'indicator'):void
		{
			activityType = activityType.substring(0, 1).toUpperCase() + activityType.substring(1);
			var bytes:ByteArray = (new Activity['ajax' + activityType]()) as ByteArray;
			
			var player:GIFPlayer = new GIFPlayer(true);
			player.loadBytes(bytes);
			
			this.addChild(player);
		}
		
	}
}