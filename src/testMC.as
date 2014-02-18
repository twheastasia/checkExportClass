package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	
	
	[SWF(width="640", height="640", frameRate="60")]
	public class testMC extends Sprite
	{
		private var loader:Loader;
		private var btnLoader1:Loader;
		private var btnLoader2:Loader;
		private var btnLoader3:Loader;
		private var saybotmcClass:Class;
		private var mc:MovieClip;
		private var urlRequest:URLRequest;
		
		private var chooseFileRouteBtn:SimpleButton;
		private var fileRouteTf:TextField;
		private var checkExportNameBtn:SimpleButton;
		private var exportNameTf:TextField;
		private var resultTf:TextField;
		private var startBtn:SimpleButton;
		
		private var flag:int;
		private var file:File = new File;
		
		public function testMC()
		{
			loader = new Loader;
			initLayout();
		}
		
		private function loadMC(routePath:String = null):void
		{
			urlRequest = new URLRequest(routePath);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){
				saybotmcClass = getSaybotmcCls(loader);
				if(!saybotmcClass){
					resultTf.text += routePath + " does not contain ExportName named " + exportNameTf.text + "!\n";
					return;
				}
			});
			loader.load(urlRequest);
			
		}
		
		public function getSaybotmcCls(loader:Loader):Class{
			try{
				if(exportNameTf.text == ""){
					exportNameTf.text = "saybotmc";
					return loader.contentLoaderInfo.applicationDomain.getDefinition(exportNameTf.text) as Class;
				}else{
					return loader.contentLoaderInfo.applicationDomain.getDefinition(exportNameTf.text) as Class;
				}
				
			}catch(e:*){
			}
			return null;
		}
		
		
		private function initLayout():void
		{
			chooseFileRouteBtn = new SimpleButton;
			fileRouteTf = new TextField;
			checkExportNameBtn = new SimpleButton;
			exportNameTf = new TextField;
			resultTf = new TextField;
			startBtn = new SimpleButton;
			
			btnLoader1 = new Loader;
			btnLoader1.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){
				chooseFileRouteBtn = (event.target.content as MovieClip).getChildByName("chooseFileRouteBtn") as SimpleButton;
				chooseFileRouteBtn.x = 20;
				chooseFileRouteBtn.y = 20;
				stage.addChild(chooseFileRouteBtn);
				fileRouteTf.type = TextFieldType.INPUT;
				fileRouteTf.x = 120;
				fileRouteTf.y = 20;
				fileRouteTf.width = 400;
				stage.addChild(fileRouteTf);
				chooseFileRouteBtn.addEventListener(MouseEvent.CLICK, on_click_chooseFileRouteBtn);
			});
			btnLoader1.load(new URLRequest("chooseFileRouteBtn.swf"));
			
			btnLoader2 = new Loader;
			btnLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){
				checkExportNameBtn = (event.target.content as MovieClip).getChildByName("checkExportNameBtn") as SimpleButton;
				checkExportNameBtn.x = 20;
				checkExportNameBtn.y = 60;
				stage.addChild(checkExportNameBtn);
				exportNameTf.type = TextFieldType.INPUT;
				exportNameTf.x = 120;
				exportNameTf.y = 60;
				exportNameTf.width = 400;
				exportNameTf.multiline = false;
				stage.addChild(exportNameTf);
				checkExportNameBtn.addEventListener(MouseEvent.CLICK, on_click_checkExportNameBtn);
				
			});
			btnLoader2.load(new URLRequest("checkExportNameBtn.swf"));
			
			btnLoader3 = new Loader;
			btnLoader3.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){
				startBtn = (event.target.content as MovieClip).getChildByName("startBtn") as SimpleButton;
				startBtn.x = 540;
				startBtn.y = 60;
				stage.addChild(startBtn);
				startBtn.addEventListener(MouseEvent.CLICK, on_click_startBtn);
			});
			btnLoader3.load(new URLRequest("startBtn.swf"));
			
			resultTf.x = 20;
			resultTf.y = 180;
			resultTf.multiline = true;
			resultTf.mouseEnabled = false;
			resultTf.width = 600;
			resultTf.height = 1000;
			stage.addChild(resultTf);

		}
		
		private function on_click_checkExportNameBtn(event:Event):void
		{
			resultTf.text = "";
		}
		
		private function on_click_chooseFileRouteBtn(event:Event):void
		{
			flag = 0;
			file = null;
			file = new File;
			file.addEventListener(Event.SELECT,onSingleSelect);  
			file.browseForDirectory("请选择一个目录");  //激发Event.SELECT事件  
		}
		
		private function on_click_startBtn(event:Event):void
		{
			resultTf.text = "";
			if(flag==1){//flag标志位是否为最深目录
				var fileStream:FileStream;
				fileStream.open(file,FileMode.WRITE);
				var buf:ByteArray;
				buf.position=0;
				fileStream.writeBytes(buf);
				fileStream.close();
			}else{
				GetFiles(fileRouteTf.text);
			}
			if(resultTf.text == "") resultTf.text = "done!";
		}
		
		private function onSingleSelect(evt:Event):void{
			fileRouteTf.text = evt.target.nativePath;
		}
		
		public function GetFiles(strPath:String):void
		{
			try{
				//获取指定路径下的所有文件名
				var directory:File = new File(strPath); 
				var contents:Array = directory.getDirectoryListing(); 
				for (var i:uint = 0; i < contents.length; i++) 
				{ 
					var mfile:File = contents[i] as File;
					if(mfile.isDirectory){
						GetFiles(mfile.nativePath);
					}else{
						if(mfile.extension == "swf") loadMC(mfile.nativePath);
					}
				} 
			}catch(e:*){
				resultTf.text = "路径有问题！";
			}
			
		}
		
	}
}