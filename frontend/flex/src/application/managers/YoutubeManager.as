package application.managers
{
	import com.adobe.protocols.oauth2.OAuth2;
	import com.adobe.protocols.oauth2.event.GetAccessTokenEvent;
	import com.adobe.protocols.oauth2.event.GetCodeEvent;
	import com.adobe.protocols.oauth2.grant.AuthorizationCodeGrant;
	import com.adobe.protocols.oauth2.grant.IGrantType;
	import com.adobe.serialization.json.JSON;
	
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.as3commons.logging.setup.LogSetupLevel;

	public class YoutubeManager extends EventDispatcher
	{
		private const AUTH_URL:String = "https://accounts.google.com/o/oauth2/auth";
		private const TOKEN_URL:String = "https://accounts.google.com/o/oauth2/token";
		private const USER_URL:String = "https://www.googleapis.com/youtube/v3/channels?part=snippet&mine=true";
		private const UPLOAD_URL:String = "https://www.googleapis.com/upload/youtube/v3/videos?part=snippet,status";
		private const UPDATE_URL:String = "https://www.googleapis.com/youtube/v3/videos?part=snippet,status";
		private const CLIENT_ID:String = "369398000027-qabstva6ev6srq6dkng3b7a8nb2gmpt2.apps.googleusercontent.com";
		private const REDIRECT_URI:String = "urn:ietf:wg:oauth:2.0:oob";
		private const RESPONSE_TYPE:String = "code";
		private const CLIENT_SECRET:String = "O8N1B2Fsr96u3cPreD-YoKTa";
		private const SCOPE:String = "https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/youtube.upload";
		private const STATES:Array = [""];
		
		private var loader:URLLoader;
		private var request:URLRequest;
		private var parameters:URLVariables;
		private var targetUI:*;
		private var accessToken:String;
		private var refreshToken:String;
		private var tokenType:String;
		private var expiresDate:Date;
		[Bindable]
		public var resource:File;
		
		
		
		private var currentUrl:String;
		
		public function YoutubeManager(target:*)
		{
			targetUI = target;
			
			authenticate();
		}
		
		public function authenticate():void
		{
			var oauth2:OAuth2 = new OAuth2(AUTH_URL, TOKEN_URL, LogSetupLevel.ALL);
			var grant:IGrantType = new AuthorizationCodeGrant(targetUI.webView, CLIENT_ID, CLIENT_SECRET, REDIRECT_URI, SCOPE);
			
			oauth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
			oauth2.addEventListener(GetCodeEvent.GOT_CODE, onFirstCodeGot);
			oauth2.getAccessToken(grant);
			targetUI.signing = true;
		}
		
		private function sendRequest(url:String, params:*=null, method:String=URLRequestMethod.GET):void
		{
			currentUrl = url;
			loader = new URLLoader();
			request = new URLRequest(url);
			if(params)
				request.data = params;
			request.method = method;
			if(currentUrl != USER_URL)
				request.contentType = "application/json";
			request.requestHeaders.push(new URLRequestHeader("Authorization", tokenType+" "+accessToken));
			loader.addEventListener(Event.COMPLETE, onResult);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(request);
		}
		
		private function onFirstCodeGot(event:GetCodeEvent):void
		{
			targetUI.webView.viewPort = null;
			targetUI.processing=true;
		}
		
		private function onGetAccessToken(getAccessTokenEvent:GetAccessTokenEvent):void
		{
			if (getAccessTokenEvent.errorCode == null && getAccessTokenEvent.errorMessage == null)
			{
				accessToken = getAccessTokenEvent.accessToken;
				tokenType = getAccessTokenEvent.tokenType;
				refreshToken = getAccessTokenEvent.refreshToken;
				expiresDate = new Date();
				expiresDate.time += Number(getAccessTokenEvent.expiresIn) * 1000;
				sendRequest(USER_URL);
			}
			else
			{
				targetUI.setAlert("Sorry, authentication failed, please try later.", "Authentication Failure");
				targetUI.signing = false;
				targetUI.isSigned = false;
				targetUI.processing=false;
			}
		}
		
		public function uploadVideo():void
		{
			resource = new File();
			resource.addEventListener(Event.SELECT, onSelect);
			resource.browse();
		}
		
		private function onSelect(event:Event):void
		{
			request = new URLRequest(UPLOAD_URL);
			request.method = URLRequestMethod.POST;
			request.requestHeaders.push(new URLRequestHeader("Authorization", tokenType+" "+accessToken));
			request.contentType = "application/octet-stream";
			resource.addEventListener(Event.COMPLETE, onComplete);
			resource.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onResultData);
			resource.addEventListener(ProgressEvent.PROGRESS, onProgress);
			resource.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			resource.addEventListener(IOErrorEvent.IO_ERROR, onError);
			resource.upload(request, "data");
			targetUI.setUploading(true, "The file " + resource.name + " is being uploaded...");
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			trace("Progress event: ", int(event.bytesLoaded/event.bytesTotal*100).toString(), "chunk:", event.bytesLoaded);
		}
		
		private function onComplete(event:Event):void
		{
			trace("Complete loading");
		}
		
		private function onResultData(event:DataEvent):void
		{
			trace("Result");
			try{
				var response:Object = com.adobe.serialization.json.JSON.decode(event.data);
			}
			catch(error:Error){
				targetUI.setAlert("Failed to set metadata to video uploaded.", "Upload Error");
				return;
			}
			targetUI.setUploading(false, "File " + resource.name + " successfully uploaded to Youtube!", response.id);
			sendRequest(UPDATE_URL, getVideoJSONData(response.id, response.snippet.categoryId), URLRequestMethod.PUT);
		}
		
		private function onResult(e:Event):void
		{
			trace("Result");
			if(currentUrl == USER_URL){
				currentUrl = null;
				targetUI.isSigned = true;
				targetUI.signing = false;
				var response:Object = com.adobe.serialization.json.JSON.decode(e.target.data);
				targetUI.userName.text = "Logged in as " + response.items[0].snippet.title;
			}
			else{
				targetUI.setUploading(false, "File " + resource.name + " successfully uploaded to Youtube!", response.id);
				targetUI.clearInputs();
			}
		}
		
		private function onError(event:ErrorEvent):void
		{
			try{
				var response:Object = com.adobe.serialization.json.JSON.decode(event.target.data);
				if(response.error.message == "Login Required"){
					targetUI.setAlert("Please, sign-in again.", "Authentication Failure");
				}
			}
			catch(error:Error){
				trace("No error answer from Youtube");
			}
			if(currentUrl != USER_URL && !targetUI.loadingSuccess)
				targetUI.setUploading(false, "Failed to upload " + resource.name ? resource.name : "updates metadata");
		}
		
		private function getVideoJSONData(id:String=null, cat:String=null):Object
		{
			var objData:Object = new Object();
			objData.snippet = new Object();
			objData.snippet.description = targetUI.descriptionInput.text;
			objData.snippet.title = targetUI.titleInput.text;
			var tagsString:String = targetUI.tagsInput.text;
			tagsString = tagsString.replace(/,#/g,"#");
			tagsString = tagsString.replace(/, /g,"#");
			tagsString = tagsString.replace(/,/g, "#");
			tagsString = tagsString.replace(/ #/g, "#");
			tagsString = tagsString.replace(/[#]{2,}/g,"#");
			if(tagsString.charAt(0) == "#")
				tagsString = tagsString.substr(1, tagsString.length - 1);
			if(tagsString.charAt(tagsString.length - 1) == "#")
				tagsString = tagsString.substr(0, tagsString.length - 1);
			var tags:Array = tagsString.split("#");
			objData.snippet.tags = tags;
			objData.status = new Object();
			objData.status.privacyStatus = targetUI.privacyChooser.selectedItem.data;
			if(id)
				objData.id = id;
			if(cat)
				objData.snippet.categoryId = cat;
			
			return com.adobe.serialization.json.JSON.encode(objData);
		}
		
		public function cancel():void
		{
			if(resource)
			{
				resource.cancel();
			}
		}
	}
}