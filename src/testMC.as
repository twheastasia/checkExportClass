package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class testMC extends Sprite
	{
		private var loader:Loader;
		private var saybotmcClass:Class;
		private var mc:MovieClip;
		private var urlRequest:URLRequest;
		
		public function testMC()
		{
			loadMC();
		}
		
		private function loadMC():void
		{
//			var path:String = "file://192.168.0.43/vworld_swf/quest/beginner_fairy_fight/b231_s0_SceneObj_1.swf";
			var path:String = "http://img.guomii.com/2011/09/hosts.png";
			
			urlRequest = new URLRequest(path);
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(urlRequest);
			
		}
		
		private function loadComplete(event:Event):void
		{
			trace("load complete");
//			stage.addChild(event.target as MovieClip);
		}
	}
}