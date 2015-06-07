/* wh-session.js */
function WHSessionInfo() {
	this.urlActiveAuthority = '';
	this.urlPath = '';
	this.urlDelimiter = '';
	this.urlSession = '';
	this.urlRand = '';
	this.urlSessionRand = '';
	this.urlMainAppID = '';
   this.appURLEx = appURLEx;
	function appURLEx(appId, pageId, command, includeSession, includeScheme, vmlOverride, downloadFileName) {
		var
			schemeAndAuthority,
			session,
			path,
			fileNamePhrase;
		//---
		if (includeScheme)
			schemeAndAuthority =  this.urlActiveAuthority
		else
			schemeAndAuthority = '';
		if ((includeSession) && (includeSession == false))
			session = ''
		else
			session = this.urlSessionRand;
		if (downloadFileName)
			fileNamePhrase = '/' + downloadFileName
		else
			fileNamePhrase = '';
		if (vmlOverride)
			path = '/' + vmlOverride + fileNamePhrase + '?'
		else {
			if (downloadFileName)
				path = this.urlPath.substring(0, this.urlPath.length - 1) + fileNamePhrase + '?'
			else
				path = this.urlPath;
		}
		return schemeAndAuthority + path + appId + this.urlDelimiter + pageId + this.urlDelimiter + session + this.urlDelimiter + (command || '');		
	}
	this.appURL = appURL;
	function appURL(pageId, command, includeSession, includeScheme) {
		return this.appURLEx(this.urlMainAppID, pageId, command, includeSession, includeScheme);
	}
	this.appURLWithSession = appURLWithSession;
	function appURLWithSession(pageId, session, command, includeScheme) {
		var
			schemeAndAuthority;
		//---
		if (includeScheme)
			schemeAndAuthority =  this.urlActiveAuthority
		else
			schemeAndAuthority = '';
		return schemeAndAuthority + this.urlPath + this.urlMainAppID + this.urlDelimiter + pageId + this.urlDelimiter + session + this.urlDelimiter + (command || '');		
	}
	this.appURLDownload = appURLDownload;
	function appURLDownload(pageId, command, includeSession, includeScheme, downloadFileName) {
		return this.appURLEx(this.urlMainAppID, pageId, command, includeSession, includeScheme, null, downloadFileName);
	}
}

var 
	whSession = new WHSessionInfo();
/* end */