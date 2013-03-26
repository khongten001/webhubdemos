/* jquery-webhub.js */

function AjaxErrorInfoObject() {
	this.statusCode = 0;
	this.summary = '';
	this.detail = '';
}

function getAJAXErrorInfo(jqXHR, exception, ajaxErrorInfo) {
	var
		statusCode,
		summary,
		detail,
		whSituation,
		pos;
	statusCode = 0;	
	if (jqXHR.status == 0) {
		summary = 'No connection.';
		detail = 'Please check the internet network connection.'
	}
	else
	if (jqXHR.status == 403) {
		statusCode = 403;
		whSituation = jqXHR.getResponseHeader('X-Status-Reason');
		//var headers = jqXHR.getAllResponseHeaders(); useful for debug
		/*	whSituation has format:     phrase  OR  phrase, WHRunner xxx
			  where phrase is one of
					HubNotFound
					AppCoverPage
					AppNotDefined
					AppNotRunning
					AppShuttingDown
					RequestTimeout
					HubCapacityExceeded
					SessionMaxActive
		  */
		pos = whSituation.indexOf(',');
		if (pos > 0)
			whSituation = whSituation.substring(0, pos);
		if (whSituation == 'RequestTimeout') {
			summary = 'Timeout waiting for response';
			detail = 'Please try again.'
		}
		else {
			summary = 'The web application is not currently available.';
			detail = whSituation;							 
		}	
	}
	else 
	if (jqXHR.status == 404) {
		statusCode = 404;
		summary = 'Requested page not found';
		detail = '404';
	}
	else if (jqXHR.status == 500) {
		statusCode = 500;
		summary = 'Internal Server Error [500].';
		detail = '';	
	}
	else
	if (exception == 'parsererror') {
		summary = 'JSON response failed to parse.';
		/*allow for html markup and only show first 100 characters*/
		if (jqXHR.responseText.length > 100)
			detail =  htmlEncode(jqXHR.responseText.substring(0,100)) + '...'
		else
			detail =  htmlEncode(jqXHR.responseText);
	} 
	else
	if (exception == 'timeout') {
		summary = 'Timeout waiting for response';
		detail = 'Please try again.'
	}
	else
	if (exception === 'abort') {
		summary =  'Ajax request aborted.';
		detail = '';
	}
	else {
		summary = 'Unexpected Error.';
		detail =  jqXHR.responseText;
	}
	ajaxErrorInfo.statusCode = statusCode
	ajaxErrorInfo.summary = summary;
	ajaxErrorInfo.detail = detail;
}	

/* end */