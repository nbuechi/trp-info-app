/* code written by nicolas buechi, 2011, buechi@winterlife.com
all rights reserved.
simple setup file for touchscreens.

*/




	package
{
	import flash.display.*
	import flash.system.*
		import flash.display.Stage
		import flash.events.*
		import flash.text.*
		import flash.media.*
		import flash.net.*
		import flash.utils.Timer;      
		import flash.events.TimerEvent;
		import flash.ui.Mouse;	
			import com.greensock.*;
			import com.greensock.loading.*;
			import com.greensock.loading.ImageLoader;
			import com.greensock.events.LoaderEvent;
			import com.greensock.loading.display.*;
		import flash.geom.*; 
		import flash.text.Font;
		import com.greensock.plugins.TintPlugin;
		import com.greensock.plugins.TweenPlugin;
		TweenPlugin.activate([TintPlugin]);
		import flash.errors.IOError;

		import flash.events.IOErrorEvent;
		
		import flash.ui.Multitouch;
		import flash.ui.MultitouchInputMode;
		
		import com.shinedraw.controls.*;	
		import flash.events.Event;		
		import flash.display.MovieClip;
		import flash.filters.DropShadowFilter;
		


	public class Main extends Sprite
	{
		
		private var _iPhoneScroll : IPhoneScroll;

	var camPixRegex:RegExp = /bilder\/(\d+)\.jpg/i;

	var dataUrl:String = "http://www.therealpark.ch/fileadmin/user_upload/shaper/shape_data.xml";
	var xmlLoader:URLLoader = new URLLoader();
	var xmlData:XML = new XML();
	var schilder:Array = new Array;
	var scrollObj:IPhoneScroll;
	var netTester:XMLLoader;
	
	var dataUrlContests:String = "http://www.winterlife.com/trp_app/xml/trpevents.xml"
	var xmlLoaderContests:URLLoader = new URLLoader();
	var xmlDataContests:XML = new XML();
	var contests:Array = new Array;
	var contestsFlyer:Array = new Array();
	
	var contestSelecter:Sprite = new Sprite();
	var contestSelecterBg:SelecterBg = new SelecterBg();
	var contestSelecterBullet:Array = new Array();
	var contestMain:Sprite = new Sprite;
	var bigPic:ImageLoader;
	
	var flyerLoaders:Array = new Array();
	
	var swiper = 0;
	
	var livePHP:DataLoader;
	var camPic:ImageLoader;
	var camPicTal:ImageLoader;
	
	//var camContainer:Sprite = new Sprite();
	var parkPic;
	var posLoaded = false;
	var contestXMLLoaded = false;
	
	var houry:String;
	var monthy:String;
	var yeary:String;
	var datey:String;
	var montheer:Number;

	var minutey:String;
	var dateer:Number;
	var minuteer:Number;
	var houreer:Number;
	var urly:String;
	
	var viewNum:Number;
	var cam1Loaded:Boolean = false;
	var cam2Loaded:Boolean = false;
	var liveURLBerg:String = "http://www.livecams.flumserberg.ch/mobotix-prodcam2/live.php";
	var liveURLTal:String = "http://www.livecams.flumserberg.ch/mobotix-prodalp/live.php";
	var camURLBerg:String = "http://www.livecams.flumserberg.ch/mobotix-prodcam2/bilder/";
	var camURLTal:String = "http://www.livecams.flumserberg.ch/mobotix-prodalp/bilder/";
	
	var loaderlyBerg:Loaderly = new Loaderly();
	var loaderlyTal:Loaderly = new Loaderly();
	
	var camView:CamView = new CamView;
	var contestView:Sprite = new Sprite;
	var closer = new MediaClose();
	
	
	var dropShadow:DropShadowFilter; 
	

	var noCam:NoCam = new NoCam();
	var noNet:NoNetwork;
	var netz:Boolean = false;
	
	var firstRun:Boolean = true;
	
		//************************************************	
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, on_added_to_stage);
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			dropShadow =  new DropShadowFilter();
			
			// just for testing purposes
			stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKey);
			addChild(camView);
	
			setChildIndex(camView,0);
			infoW.linkbg.addEventListener(MouseEvent.CLICK, showWebsite);
			infoW.dev.addEventListener(MouseEvent.CLICK, showDev);
			cam.addEventListener(MouseEvent.CLICK, showCam);
			park.addEventListener(MouseEvent.CLICK, showPark);
			contestbtn.addEventListener(MouseEvent.CLICK, showEvents);
			info.addEventListener(MouseEvent.CLICK, showInfo);
			
			cam.alpha = 0;
			park.alpha = 0;
			contestbtn.alpha = 0;
			info.alpha = 0;
			
			infoW.visible = false;
			//contest.visible = false;
			
			parkSetup.visible = false;
			
			
			addChild(contestMain);
		//	contestMain.width = 960;
		//	contestMain.height = 640;
			contestMain.addChild(contestView);
			camView.visible = false;
			camView.addEventListener(TransformGestureEvent.GESTURE_SWIPE , onSwipe);
			contestView.addEventListener(TransformGestureEvent.GESTURE_SWIPE , onSwipeContest);
			contestMain.addEventListener(TransformGestureEvent.GESTURE_SWIPE , onSwipeContest);
			
			setChildIndex(bg,0);
			
			
			
			
			dropShadow.color =  0x000000;
			dropShadow.strength =  .5;
			dropShadow.quality =  100;
		
			
			
			camView.camPicSelecter.camSelecterBtn2.alpha = .5;
			 camView.camPicSelecter.camSelecterBtn.alpha = 1;

		}
		
		
		function detectKey(event:KeyboardEvent):void {
			if (event.keyCode==74) {
			   trace("The j has been pressed");
				//onSwipe(this.offsetX = 1);
			
			}
			if (event.keyCode==75) {
			   trace("The k has been pressed");
			//	onSwipe(this.offsetX = 1);
			}
			
			if (event.keyCode==69) {
			   trace("The e has been pressed");
			TweenLite.to(camView.noCam,.3, {x: 1440});
			
			}
			
			if (event.keyCode==87) {
			   trace("The w has been pressed");
			TweenLite.to(camView.noCam,.3, {x: 480});
			}
		}
		
		public function on_added_to_stage(e : Event):void{
				netTester = new XMLLoader("http://www.winterlife.com/trp_app/xml/netTest.xml",{onComplete:startApp, onError: noNetwork});
				netTester.load();
			
			
		}
		
		public function startApp(e:LoaderEvent){
			netz = true;
				xmlLoader.addEventListener(Event.COMPLETE, LoadXML); 
				xmlLoader.load(new URLRequest(dataUrl));

				xmlLoaderContests.addEventListener(Event.COMPLETE, LoadXMLContests); 
				xmlLoaderContests.load(new URLRequest(dataUrlContests));
			showCam();
			setChildIndex(bg,0);
			
		}
		
		public function noNetwork(e:LoaderEvent){
			netz =false;
			noNet = new NoNetwork();
			addChild(noNet);
			noNet.filters = new Array(dropShadow);
			noNet.x = 480 - (noNet.width/2);
			noNet.y = 70;
			trace("fuck, no net");
		}
		
		
		public function LoadXML(e:Event):void { 
			xmlData = new XML(e.target.data); 
			trace("XML YO! YO! Yeah! ");
			posLoaded = true;
			
		}
		public function LoadXMLContests(e:Event):void { 
			xmlDataContests = new XML(e.target.data); 
			trace("XML YO! YO! Contests Loaded! ");
			contestXMLLoaded = true;
			createContestWindows();
			
		}
		
		
		public function setPositions(){
			//catcher.addEventListener(MouseEvent.CLICK, openBigger);
			
			
				for(var i = 0; i < xmlData.spot.length(); i++){
					
				if(xmlData.spot[i].titel.@shaped == "1"){
					schilder[i] = new Richtig;
					}else if(xmlData.spot[i].titel.@shaped == "0"){
					schilder[i] = new Falsch;
					}
					parkSetup.addChild(schilder[i]);
					schilder[i].x = xmlData.spot[i].titel.@posX;
					schilder[i].y = xmlData.spot[i].titel.@posY;
					schilder[i].x += 90;
					schilder[i].y += 5;
				}
				parkSetup.updateField.text = xmlData.overview.@lastUpdate;
				setChildIndex(bg,0);
			}
			
			
			
		public function checkUnderage(wert){
			var ausgabe:String;
			if((wert)<10){
			ausgabe ="0"+(wert).toString();}
			if(wert>=10){
			ausgabe = (wert).toString();}
		
			
			return ausgabe;
		}
		
		
		
		
		public function showCam(e:Event=null){
			viewNum = 1;
			camView.visible = true;
			setChildIndex(camView,0);
			contestMain.visible = false;
			infoW.visible = false;
			parkSetup.visible = false;
			
			cam.alpha = 1;
			park.alpha = 0;
			contestbtn.alpha = 0;
			info.alpha = 0;	
			
			if(!cam1Loaded){
			loadCamBerg();
			}
			if(cam1Loaded && !cam2Loaded){
			loadCamTal();
			}
			
			if(cam1Loaded&&cam2Loaded){
					camView.camContainer.setChildIndex(camPic.content,0);
					camPic.content.visible = true;
					camView.camContainer.setChildIndex(camPicTal.content,0);
					camPicTal.content.visible = true;
			}
			setChildIndex(bg,0);
		}
		
	public function loadCamBerg(){
			
		camView.camContainer.addChild(loaderlyBerg);
		loaderlyBerg.x = 480;
		loaderlyBerg.y = 230;
		loaderlyBerg.loadingTF.text = "Connecting to webcam Prodkamm...";
		loaderlyBerg.visible = true;
		
		
		camView.camContainer.addChild(loaderlyTal);
		loaderlyTal.x = 1440;
		loaderlyTal.y = 230;
		loaderlyTal.loadingTF.text = "Connecting to webcam Prodalp...";
		loaderlyTal.visible = true;
		
		// also for cam Tal
		
		trace("loading Berg...");
		
		livePHP = new DataLoader(liveURLBerg, {format: "text", onComplete: livePHPComplete});
		livePHP.load();
		
		
	
		
	/*
		camView.setChildIndex(camPic.content,0);
		camPic.content.visible = true;
		camView.setChildIndex(camPicTal.content,0);
		camPicTal.content.visible = true;
	*/	
		setChildIndex(bg,0);
	}	
	
	public function loadCamTal(){
		camView.camContainer.setChildIndex(camPic.content,0);
		camPic.content.visible = true;
		
		
		
		livePHP = new DataLoader(liveURLTal, {format: "text", onComplete: livePHPCompleteTal});
		livePHP.load();
		
		
	}
		
	public function livePHPComplete(event :LoaderEvent) {
		var html :String = (event.target as DataLoader).content;
		var match :Object = html.match(camPixRegex);
		var timestamp:String;
				if (!match) {
					trace("Bilder-URL im HTML nicht gefunden.");
					timestamp = "noUrl";
				}else{

				 timestamp = match[1];
			}
		
		urly = camURLBerg+timestamp+".jpg";	
		camPic = new ImageLoader(urly,{alpha:1, x:0, y: -220, width:960, height: 720,onComplete: imgComplete, onError:errorHandler, alternateURL:"noCamProdkamm.png", onProgress:showLoadingBerg});
		camPic.load();
		setChildIndex(bg,0);
	}
	
	public function livePHPCompleteTal(event :LoaderEvent){
			var html :String = (event.target as DataLoader).content;
			var match :Object = html.match(camPixRegex);
			var timestamp :String;
			if (!match) {
				trace("Bilder-URL im HTML nicht gefunden.");
				timestamp = "noUrl";
			}else{
			
			 timestamp = match[1];
		}
		
		urly = camURLTal+timestamp+".jpg";		
		camPicTal = new ImageLoader(urly,{alpha:1, x:960, y: -14, width:960, height: 720, onComplete: imgTalComplete, onError:errorHandler, alternateURL:"noCamProdalp.png", onProgress:showLoadingTal});
		camPicTal.load();
		setChildIndex(bg,0);
	}
		
		
	public function imgComplete(i){
	trace("Berg loaded");
	cam1Loaded = true;
	loaderlyBerg.visible = false;
	camView.camContainer.addChild(camPic.content);
	//camContainer.setChildIndex(camPic.content,0);
	
	camView.camContainer.removeChild(loaderlyBerg);
	if(viewNum != 1){	
	camPic.content.visible = false;
	}
	
	camView.camPicSelecter.camSelecterBtn.alpha = 1;
	setChildIndex(bg,0);
	loadCamTal();
	}
	
	public function imgTalComplete(i){
	trace("loaded Tal");
	cam2Loaded = true;
	
		camView.camContainer.removeChild(loaderlyTal);
		camView.camContainer.addChild(camPicTal.content);
		noCam.visible = false;
	if(viewNum != 1){
	
	camPicTal.content.visible = false;
	
	}
	
//	bg.alpha = 0;
	setChildIndex(bg,0);
	}
	
	
	
	
	
	
	
	public function errorHandler(event:LoaderEvent):void
		{
			
			trace(":(");
	   }
	
	
	function onSwipe (e:TransformGestureEvent):void{
		
		if (e.offsetX == 1) { 
		 //User swiped towards right
		camView.camPicSelecter.camSelecterBtn2.alpha = .5;
		 camView.camPicSelecter.camSelecterBtn.alpha = 1;
		TweenLite.to(camView.camContainer,.3, {x: 0});

		setChildIndex(bg,0);
		 }
		if (e.offsetX == -1) { 
		 //User swiped towards left
		camView.camPicSelecter.camSelecterBtn2.alpha = 1;
		 camView.camPicSelecter.camSelecterBtn.alpha = .5;
		TweenLite.to(camView.camContainer,.3, {x: -960});

		setChildIndex(bg,0);
		 }
		}
	 
	
	
	
	
	
	
	
	
	public function showPark(e:Event=null){
		
		viewNum = 0;
	//	xmlLoader.addEventListener(Event.COMPLETE, LoadXML); 
	//	xmlLoader.load(new URLRequest(dataUrl));
		
		parkSetup.visible = true;
		contestMain.visible = false;
		camView.visible = false;
		
		cam.alpha = 0;
		park.alpha = 1;
		contestbtn.alpha = 0;
		info.alpha = 0;	
			
		infoW.visible = false;
//		camPic.content.visible = false;

		
		if(posLoaded){
		setPositions();
		
		setChildIndex(parkSetup,0);
	
		}else{
		showPark(null);
		}
	
	setChildIndex(bg,0);
	}


	public function showEvents(e:Event){
		contestMain.visible = true;
		viewNum = 2;
		camView.visible = false;
		//loaderly.visible = false;
		cam.alpha = 0;
		park.alpha = 0;
		contestbtn.alpha = 1;
		info.alpha = 0;
		infoW.visible = false;
		
		
		parkSetup.visible = false;
		setChildIndex(bg,0);
		
	}
	
	public function createContestWindows(){
		trace("BITCH FACE " + xmlDataContests.contest.length());
		for(var i = 0; i < xmlDataContests.contest.length(); i++){
		
			contests[i] = new ContestWindow;
			contestView.addChild(contests[i]);
			contests[i].contestText.autoSize =  TextFieldAutoSize.LEFT ;
			contests[i].contestText.htmlText = xmlDataContests.contest[i].maintext;
			contests[i].x = 960*i;
			
			flyerLoaders[i] = new Loaderly();
			contests[i].addChild(flyerLoaders[i]);
		
			flyerLoaders[i].loadingTF.text = "Connecting to server..."
			flyerLoaders[i].x = 200;
			flyerLoaders[i].y = 200;
			
				
			contestsFlyer[i] = new ImageLoader(xmlDataContests.contest[i].file.@big,{alpha:1,x:0, y:0, container:contests[i], onComplete:flyerComplete, alternateUrl: "noFlyer.png", onProgress: onProgressFlyer});
			contestsFlyer[i].load();
			
			contestsFlyer[i].content.addEventListener(MouseEvent.CLICK, bigPicture);
			contestsFlyer[i].content.filters = new Array(dropShadow);
			
		
			var th:Number = contests[i].contestText.textHeight;
			
			scrollObj = new IPhoneScroll(contests[i].contestText,stage, th);		
			scrollObj.canvasHeight = 500;
		}
			createBullets(xmlDataContests.contest.length());
			setChildIndex(contestMain,0);
			setChildIndex(bg,0);
	}
	

	
	public function flyerComplete(e:LoaderEvent){
		var faktor = 500/e.target.content.height;
		trace(faktor);
		e.target.content.scaleX = faktor;
		e.target.content.scaleY = faktor;
	
	}
	

	
	public function bigPicture(e:Event){
		 for(var i = 0; i <contestsFlyer.length; i++){
			if(contestsFlyer[i].content == e.currentTarget){
			var actSel:Number = i;
		}
	}
		
		contestsFlyer[actSel].content.rotation = 0;


		
		contestsFlyer[actSel].content.rotation= -90;
		contestsFlyer[actSel].content.x = 0;
		contestsFlyer[actSel].content.y = 640;
		contestsFlyer[actSel].content.scaleX = 1;
		contestsFlyer[actSel].content.scaleY = 1;
	
		setCenterPos(contestsFlyer[actSel].content);
		contestsFlyer[actSel].content.removeEventListener(MouseEvent.CLICK, bigPicture);
		contestsFlyer[actSel].content.addEventListener(MouseEvent.CLICK, killBigPicture);
	
		trace("bigPic loaded");
	
			if(viewNum != 2){
				killBigPicture(e);
				}
	

		
		contests[actSel].contestText.visible = false;
			

		setChildIndex(bg,0);
	
	}
	
	public function killBigPicture(e:Event){
	//	setChildIndex(contestMain,0);
		setChildIndex(bg,0);
	
			 for(var i = 0; i <contestsFlyer.length; i++){
				if(contestsFlyer[i].content == e.currentTarget){
				var actSel:Number = i;
			}
		}
			contestsFlyer[actSel].content.rotation = 0;
			
			var faktor = 500/contestsFlyer[actSel].content.height;
			contests[actSel].contestText.visible = true;
			contestsFlyer[actSel].content.scaleX = faktor;
			contestsFlyer[actSel].content.scaleY = faktor;
			contestsFlyer[actSel].content.x = 0;
			contestsFlyer[actSel].content.y = 0;
			
		
		
			setChildIndex(bg,0);
			
			trace("bigPic killed");
	contestsFlyer[actSel].content.removeEventListener(MouseEvent.CLICK, killBigPicture);
		contestsFlyer[actSel].content.addEventListener(MouseEvent.CLICK, bigPicture);
	}
	
	///////////////////////	///////////////////////	///////////////////////	///////////////////////	///////////////////////

	///////////////////////	///////////////////////	///////////////////////	///////////////////////	///////////////////////
	///////////////////////	///////////////////////	///////////////////////	///////////////////////	///////////////////////
	
	
	
	
	public function createBullets(anzahl){
		
		var zahl = anzahl;
		contestMain.addChild(contestSelecter);
		contestSelecter.addChild(contestSelecterBg);
		trace(contestSelecterBg.width + "segemal");
		contestSelecterBg.width = contestSelecterBg.width+(zahl-2)*19.5;
		contestSelecter.x = 480-(contestSelecterBg.width/2);
		contestSelecter.y = 26;
		
		for(var i = 0; i< zahl; i++){
			contestSelecterBullet[i] = new CamSelecterBtn();
			contestSelecter.addChild(contestSelecterBullet[i]);
	
			contestSelecterBullet[i].x =contestSelecterBg.x+ 3 +(i *20);
			contestSelecterBullet[i].y = 2.5;
			contestSelecterBullet[i].alpha = .5;
			
		}
			contestSelecterBullet[0].alpha = 1;
			trace(swiper + " swiper");
	}
	
	
	
		function onSwipeContest (e:TransformGestureEvent):void{
			killBigPicture(e);
				if (e.offsetX == 1) { 
					//User swiped towards right
					if(contestView.x<0 ){
						swiper -=1;
					TweenLite.to(contestView,.3,{x:contestView.x +960, onComplete:finiContestSwipe})
					killBigPicture(e);
				}
				}
				if (e.offsetX == -1) { 
					//User swiped towards left
					if( contestView.x > -(960 *(xmlDataContests.contest.length()-1))  ){
						swiper +=1;
					TweenLite.to(contestView,.3,{x:contestView.x -960, onComplete:finiContestSwipe})
					killBigPicture(e);
				}
				}
	
	}
	
	public function finiContestSwipe(){
		
		for(var i = 0; i< contestSelecterBullet.length; i++){
			contestSelecterBullet[i].alpha = .5;
		}
		trace(swiper + " swiper");
		contestSelecterBullet[swiper].alpha = 1;
		
		
	}
	
	
	public function showInfo(e:Event){

		viewNum = 3;
		contestMain.visible = false;
		camView.visible = false;
		//loaderly.visible = false;
		cam.alpha = 0;
		park.alpha = 0;
		contestbtn.alpha = 0;
		info.alpha = 1;
		
		infoW.visible = true;
	

		parkSetup.visible = false;
		setChildIndex(bg,0);
		
	}
	
	
	
	public function showWebsite(e:Event){
		var url:URLRequest = new URLRequest("http://www.therealpark.ch");
		 navigateToURL(url, "_blank");
		setChildIndex(bg,0);
		
	}
	
	public function showDev(e:Event){
		var url:URLRequest = new URLRequest("http://www.winterlife.com");
		 navigateToURL(url, "_blank");
		setChildIndex(bg,0);
		
	}
	
	
	public function setCenterPos(obj){
		
		trace("width "+ obj.width)
		obj.x = 480 -(obj.width/2);
		obj.y = 320 -(obj.height/2) +640;
		
		
	}
	
	public function showLoadingBerg(e:LoaderEvent){
	//	loaderly.visible = true;
		loaderlyBerg.loadingTF.text = "Loading, "+Math.round(e.target.progress*100)+"% finished.";
	
		
		
	}
	
	public function showLoadingTal(e:LoaderEvent){
	//	loaderly.visible = true;
		loaderlyTal.loadingTF.text = "Loading, "+Math.round(e.target.progress*100)+"% finished.";
	
		
		
	}
	
	public function onProgressFlyer(e:LoaderEvent){
		for(var i = 0; i <contestsFlyer.length; i++){
			if(contestsFlyer[i] == e.target){
			var actSel:Number = i;
		}
		
	}
		flyerLoaders[actSel].loadingTF.text"Loading, "+Math.round(e.target.progress*100)+"% finished.";
	
	}



////// the end

						}
					}