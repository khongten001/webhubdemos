/*wh-designrefresh.js*/	
function refreshPage( ) {
	setTimeout("document.location=refreshLocation", refreshTimeout);
}
function initDesignRefresh() {
	/*$('designRefresh').onclick = function(){ new Ajax.Updater('', '	/scripts/runisa.dll?appid:remoterefresh:1199125823.7035', {asynchronous:true, evalScripts:true, method:'get', onLoading:function(request){refreshPage()}}); return false; };*/
	$('#' + refreshElementId).click(function() {
		$.ajax({
			url: refreshURL,
			data: {},
			type: "GET",
			dataType: "text",
			success: function(response) {refreshPage(); return false;},
			error: function(jqXHR, exception) {
				if (jqXHR.status === 0) {
					 alert('No connection.\n Verify Network.');
				} else if (jqXHR.status == 403) {
					var reason = jqXHR.getResponseHeader('X-Status-Reason');
					//var headers = jqXHR.getAllResponseHeaders(); useful for debug
					/*reason has format(s)
					  phrase
					  phrase, WHRunner xxx
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
					  var pos = reason.indexOf(',');
					  if (pos > 0)
							reason = reason.substring(0, pos)
						else
							reason = reason;
					 alert('Requested page is not currently available. (403) ' + reason);
				} else if (jqXHR.status == 404) {
					 alert('Requested page not found. [404]');
				} else if (jqXHR.status == 500) {
					 alert('Internal Server Error [500].');
				} else if (exception === 'parsererror') {
					 alert('Requested JSON parse failed.\n' + jqXHR.responseText);
				} else if (exception === 'timeout') {
					 alert('Time out waiting for page.');
				} else if (exception === 'abort') {
					 alert('Ajax request aborted.');
				} else {
					 alert('Uncaught Error.\n' + jqXHR.responseText);
				}
				return false;
			}
		});
	});
}
document.addEventListener("DOMContentLoaded", initDesignRefresh, true);		
/* end */
