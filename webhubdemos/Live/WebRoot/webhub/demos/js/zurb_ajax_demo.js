/* zurb_ajax_demo */

function sendDemoMessage() {

	$('#divDataEntryFeedback').html('<img src="https://openclipart.org/download/195700/loader.svg" style="height: 50px;" alt="Please Wait" />');
	$('#divDataEntryFeedback').show();

	$.ajax( {
		url:  'http://lite.demos.href.com/htfd:ajaxtest::001', 
		data:  $('#formContact').serialize(),
		type: "POST",
		crossDomain: true, /* enable this */
		headers: { "cache-control": "no-cache" },
		dataType: "json",
		//
		success: function(json) {
			if (json.responseStatus == 'OK') {
				$('#divDataEntryFeedback').hide();
				$('#messageThanksModal').foundation('reveal', 'open');
			}
			else
			if (json.responseStatus == 'ERROR') {
				/*alert('Error: ' + json.errorMsg);*/
				$('#divDataEntryFeedback').html(json.errorMsg);
				$('#divDataEntryFeedback').show();
			}
			else {
				alert('Unexpected Error');
				$('#dataEntryFeedback').html('Unexpected Error');
				$('#divDataEntryFeedback').show();
			}
		},
		//
		error: function(jqXHR, exception) {
			alert(exception);
		}
		}
	);	
}

function addRevealEvents_FeedbackMessage() {
	$('#messageInputModal').bind('opened.fndtn.reveal', function() {
		$('#divDataEntryFeedback').hide();
		document.getElementById("btnSendAnswers").addEventListener("click", sendDemoMessage);
	});
}

$(document).ready(addRevealEvents_FeedbackMessage);

