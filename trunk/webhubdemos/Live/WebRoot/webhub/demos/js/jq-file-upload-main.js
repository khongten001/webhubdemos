$(function() {
        'use strict';
        // Initialize the jQuery File Upload widget:
        var form= $("#fileupload");
        var maxFileSizeCustom =  400*1024; //400kb

         form.fileupload({
            dropZone: $('#dropzone'),
           /* acceptFileTypes: /(\.|\/)(gif|jpe?g|png|mp3|mp4)$/i,*/
           /* maxFileSize: 4000, //400kbytes //400000 //*/
            url: form.attr("action"),
            type: "POST",
            dataType: "XML",
            uploadTemplateId: null,
            downloadTemplateId: null,
            add: function(e, data) {
                $(".fileupload-progress").fadeIn();
                 //console.log(data.files);
                //Validations will be here 
                if(data.files[0].size > maxFileSizeCustom){
                    var ErrMessage = "File is too large";
                    addShowErr(data.files[0].name+ ", " + ErrMessage +", "+ formatFileSize_jqupload(data.files[0].size));                  
                }else{
                     if(file_upload_options.allow_start_action==true){
                            var jsonArg1            = new Object();
                            jsonArg1.fname          = data.files[0].name,
                            jsonArg1.ftype          = data.files[0].type,
                            jsonArg1.fsize          = data.files[0].size,
                            jsonArg1.flastmodified  =data.files[0].lastModified
                            $.ajax({
                                url: file_upload_options.upload_start_action,
                                type: "POST",
                                dataType: "json",
                                data: {
                                   fileDetails: JSON.stringify(jsonArg1)
                                },
                                success: function(data) {
                                    console.log(data);
                                    var fileName = data.ShowcaseResponse.ConfirmedFname;
                                    var ResponseType = data.ShowcaseResponse.ResponseType;
                                    var SignData = data.ShowcaseResponse.SignData;
                                    if(ResponseType == "OK"){
                                        console.log("start Upload Action Ajax Complete");
                                    }
                                    
                                }
                            }),data.submit();
                    }else{
                        data.submit();
                    }
                }//End Validation 
                
            },
            send: function(e, data) { },
            success: function(e,t) { },
            progressall: function(e, data) {
                var n = Math.round(data.loaded / data.total * 100);
                $(".fileupload-progress .progress").css("width", n + "%");
               // console.log(n + "%");
            },
            fail: function(e, data) {
                if(file_upload_options.allow_fail_action==true){
                    var jsonArg1            = new Object();
                    jsonArg1.fname          = data.files[0].name,
                    jsonArg1.ftype          = data.files[0].type,
                    jsonArg1.fsize          = data.files[0].size,
                    jsonArg1.flastmodified  =data.files[0].lastModified

                    $.ajax({
                        url: file_upload_options.upload_fail_action,
                        type: "POST",
                        dataType: "json",
                        data: {
                           fileDetails: JSON.stringify(jsonArg1)
                        },
                        success: function(data) {
                            console.log(data);
                            var fileName = data.ShowcaseResponse.ConfirmedFname;
                            var ResponseType = data.ShowcaseResponse.ResponseType;
                            var SignData = data.ShowcaseResponse.SignData;
                            if(ResponseType == "OK"){
                                console.log("Upload Fail Action Ajax Complete");
                            }
                            
                        }
                    });
                }

                var ErrMessage  = $(data.jqXHR.responseXML).find("Message").text();
                if(ErrMessage){
                    addShowErr(data.files[0].name+ " " + ErrMessage);
                }
            },
            
            done: function(e, data) {

                var that_data = data;

                var jsonArg1            = new Object();
                jsonArg1.fname          = data.files[0].name,
                jsonArg1.ftype          = data.files[0].type,
                jsonArg1.fsize          = data.files[0].size,
                jsonArg1.flastmodified  =data.files[0].lastModified

                if(file_upload_options.allow_complete_action==true){
                    //Add Upload complete Call back 
                    $.ajax({
                        url: file_upload_options.upload_complete_action,
                        type: "POST",
                        dataType: "json",
                        data: {
                           fileDetails: JSON.stringify(jsonArg1)
                        },
                        success: function(dataWH) {
                            console.log(dataWH);
                            var ResponseType = dataWH.ShowcaseResponse.ResponseType;
                            if(ResponseType == "OK"){
                                //Build File List
                                addFileToList(that_data);
                            } //if(ResponseType == "OK")
                        }, //success
                        fail:function(e, t){
                            addShowErr("WH Upload Complete CallBack Failed!");
                        }
                    }); //$.ajax
                }else{ //file_upload_options.allow_complete_action
                     addFileToList(that_data);
                }
                
            },
            stop: function(e,data){
                console.log("All upload Complete");
                 setTimeout(function(){
                     $(".fileupload-progress").fadeOut(300, function() {
                        $(".fileupload-progress .progress").css("width", 0)
                    });
                },1500);
                setTimeout(function(){
                    $('.fileUploadErrMsgs').html('');
                    $('.fileUploadErrMsgs').hide('fast');
                },4500);
            }
        });

        /*  Additional Form Data  Required : Note if you trying to send
            data by using this method you have to also 
            add your input fields here , because this method ignore 
            the input fields data inside the form - (harman)
        */ 
        form.bind('fileuploadsubmit', function (e, data) {
               var file_type = data.files[0].type;
               data.formData = {
                    'Content-Type': file_type,
                    'key': form.find("input[name=key]").val(),
                    'acl': form.find("input[name=acl]").val(),
                    'Cache-Control': form.find("input[name=Cache-Control]").val(),
                    'AWSAccessKeyId': form.find("input[name=AWSAccessKeyId]").val(),
                    'policy': form.find("input[name=policy]").val(),
                    'signature': form.find("input[name=signature]").val(),
                };
        });

        //DropZone setup 
        $(document).bind('dragover', function (e) {
            var dropZone = $('#dropzone'),
                timeout = window.dropZoneTimeout;
            if (!timeout) {
                dropZone.addClass('in');
            } else {
                clearTimeout(timeout);
            }
            var found = false,
                node = e.target;
            do {
                if (node === dropZone[0]) {
                    found = true;
                    break;
                }
                node = node.parentNode;
            } while (node != null);
            if (found) {
                dropZone.addClass('hover');
            } else {
                dropZone.removeClass('hover');
            }
            window.dropZoneTimeout = setTimeout(function () {
                window.dropZoneTimeout = null;
                dropZone.removeClass('in hover');
            }, 100);
        });
        $(document).bind('drop dragover', function (e) {
            e.preventDefault();
        });

});
//Render Table row on success 
function addFileToList(data){
    if(typeof data.files[0] !=="undefined"){
          var rows = $();
          $.each(data.files, function (index, file) {
           // console.log(file);
            var row = $('<tr class="template-download fade">' +
                            '<td class="nameTD"><p class="fname"></p></td>' +
                            '<td class="extTD"><span class="fext"></span></td>' +
                            '<td class="sizeTD"><span class="fsize"></span></td>' +
                            '<td class="downloadTD"><a title="Test download of your file from AWS CloudFront" data-file="" class="fdownload" onClick="downloadAjaxFile(this);"><span>&#x1f4be;</span></a></td>' +
                            '' +
                         '</tr>');
                row.find('.fsize').text(formatFileSize_jqupload(file.size));
                row.find('.fname').append(file.name);
                row.find('.fext').append("."+file.name.split('.').pop());
                row.find('.fdownload').attr('data-file',file.name);
                rows = rows.add(row);
        });
        $('table.fileUploadList tbody.files').append(rows);
    }
}
function addShowErr(msg){
    $('.fileUploadErrMsgs').append("<p>Error : " + msg +"</p>");
    $('.fileUploadErrMsgs').fadeIn("slow");
    setTimeout(function(){
        $('.fileUploadErrMsgs').fadeOut("slow");
    },10000);
}
 function downloadAjaxFile(aTagObj){
    var filename = $(aTagObj).attr('data-file');
    filename = (escapeJQFilename(filename));
    var jsonArg1            = new Object();
        jsonArg1.fname          = filename;
     $.ajax({
        url: file_upload_options.download_url,
        type: "POST",
        dataType: "json",
        data: {
           fileDetails: JSON.stringify(jsonArg1)
        },
        success: function(data) {
            console.log("WH AJAX DATA (File Download Url) ");
            console.log(data);
            var fileName = data.ShowcaseResponse.ConfirmedFname;
            var ResponseType = data.ShowcaseResponse.ResponseType;
            var SignData = data.ShowcaseResponse.SignData;
            if(ResponseType == "OK"){
                var key = SignData.awsResource;
                var policy = SignData.awsPolicy64;
                var signature = SignData.awsUploadSignature;
                var awsDownloadURL = SignData.awsDownloadURL;
                console.log("Download Url : " + awsDownloadURL);
               download_file_url(awsDownloadURL);
            }
            
        }
  });
}


function download_file_url(awsDownloadURL){
    if(window.VBArray){
        //alert('1');
        var alink = document.createElement('a');
        alink.href = awsDownloadURL;
        alink.target = '_Blank';
        document.body.appendChild(alink);
        alink.click();
    }else{
        window.location.href = awsDownloadURL;
    }
}
function escapeJQFilename(filename) {
    var temp = filename;
    temp = temp.replace('/','_');
    temp = temp.replace('\\','_');
    temp = temp.replace(' ','_');
    temp = temp.replace('#','_');
    temp = temp.replace('%','_');
    temp = temp.replace('?','_');
    temp = temp.replace('&','_');
    temp = temp.replace('<','_');
    temp = temp.replace('>','_');
    return temp;
}
function formatFileSize_jqupload(bytes) {
    if (typeof bytes !== 'number') {
        return '';
    }
    if (bytes >= 1000000000) {
        return (bytes / 1000000000).toFixed(2) + ' GB';
    }
    if (bytes >= 1000000) {
        return (bytes / 1000000).toFixed(2) + ' MB';
    }
    return (bytes / 1000).toFixed(2) + ' KB';
} 