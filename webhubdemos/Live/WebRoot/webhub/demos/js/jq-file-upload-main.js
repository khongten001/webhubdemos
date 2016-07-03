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
            sequentialUploads: true, //Set this option to true to issue all file upload requests in a sequential order instead of simultaneous requests.
            add: function(e, data) {
                 //console.log(data.files);
                //Validations will be here 
                if(data.files[0].size > maxFileSizeCustom){
                    var ErrMessage = "File is too large";
                    addShowErr(data.files[0].name+ ", " + ErrMessage +", "+ formatFileSize_jqupload(data.files[0].size));                  
                }else{
                    //No Error Good To Go
                    $(".fileupload-progress").fadeIn();
                    $(".current_file").fadeIn();
                    $(".current_file").html("Please wait...");
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
            progress: function(e, data) {
                var n = Math.round(data.loaded / data.total * 100);
                $(".current_file").html("<b>" +n + "%</b> " + " " + short_file_name(data.files[0].name) +"  &nbsp;&nbsp;(<b><i>"+ formatFileSize_jqupload(data.bitrate)+"/s</i></b>)");
               // console.log(n + "%");
            },
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
                            if(ResponseType == "OK"){
                                console.log("Upload Fail Action Ajax Complete");
                            }
                            
                        }
                    });
                }

                var ErrMessage  = $(data.jqXHR.responseXML).find("Message").text();
                if(ErrMessage){
                    addShowErr(data.files[0].name+ " " + ErrMessage);
                }else{
                    addShowErr(data.files[0].name+ ", <b><i>Unknown Error or (CORS)</i></b> ");
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
                        $(".fileupload-progress .progress").css("width", 0);
                        $(".current_file").html('').hide();
                    });
                },1500);
                setTimeout(function(){
                    $('.fileUploadErrMsgs').html('');
                    $('.fileUploadErrMsgs').hide('fast');
                },4500);
            },
            beforeSend: function(xhr, data) {
                
            }
        });

        /*  Additional Form Data  Required : Note if you trying to send
            data by using this method you have to also 
            add your input fields here , because this method ignore 
            the input fields data inside the form - (harman)
        */ 
        form.bind('fileuploadsubmit', function (e, data) {
               var file_type = data.files[0].type;
              // var ext_ = file.name.split('.').pop();
               if(file_type==""){
                    file_type = "application/octet-stream";
               }
               console.log("File Type : "+ file_type);
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
           var fcontentType =  file.type;
           if(fcontentType==""){
                    fcontentType = "application/octet-stream";
            }
            var row = $('<tr class="template-download fade">' +
                            '<td class="nameTD"><p class="fname"></p></td>' +
                            '<td class="extTD"><span class="fext"></span></td>' +
                            '<td class="sizeTD"><span class="fsize"></span></td>' +
                            '<td class="contentTypeTD"><span class="fcontentType"></span></td>' +
                            '<td class="downloadTD"><a title="Test download of your file from AWS CloudFront" data-file="" class="fdownload" onClick="downloadAjaxFile(this);"><span>&#x1f4be;</span></a></td>' +
                            '' +
                         '</tr>');
                row.find('.fsize').text(formatFileSize_jqupload(file.size));
                row.find('.fname').append(file.name);
                var ext_ = file.name.split('.').pop();
                row.find('.fext').append("."+ext_);
                row.find('.fcontentType').append(fcontentType);
                row.find('.fdownload').attr('data-file',file.name);
                rows = rows.add(row);
        });
        $('table.fileUploadList tbody.files').append(rows);
    }
}
function addShowErr(msg){
    $('.fileUploadErrMsgs').append("<p><b>Error :</b> " + msg +"</p>");
    $('.fileUploadErrMsgs').fadeIn("slow");
    setTimeout(function(){
        $('.fileUploadErrMsgs').fadeOut("slow");
        $('.fileUploadErrMsgs').html('');
    },10000);
}
 function downloadAjaxFile(aTagObj){
    var filename = $(aTagObj).attr('data-file');
    filename = (escapeJQFilename(filename));
    var jsonArg1            = new Object();
        jsonArg1.fileToSign          = filename;
     $.ajax({
        url: file_upload_options.download_url,
        type: "POST",
        dataType: "json",
        data: {
           fileDetails: JSON.stringify(jsonArg1),
           filetosign: filename
        },
        success: function(data) {
           
            var ResponseType = data.ShowcaseResponse.ResponseType;
            if(ResponseType == "OK"){
                 console.log("WH AJAX DATA (File Download Url) ");
                var download_url = data.ShowcaseResponse.URL;
                console.log(download_url);
                //alert(download_url);
               download_file_url(download_url,filename);
            }
            
        }
    });
}


function download_file_url(awsDownloadURL,fileName){
    $("<a href='"+awsDownloadURL+"' target='_blank' download='"+fileName+"' class='downloadLnk' style='display:none;'>Download File</a>").appendTo( "body" );
    setTimeout(function(){ $('.downloadLnk')[0].click(); },300);
    $(document).on('click','.downloadLnk',function(){
         var this_ = $(this); 
         setTimeout(function(){ this_.remove(); },2000);
    });
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
function short_file_name(str) {
  if (str.length > 35) {
    return str.substr(0, 20) + '...' + str.substr(str.length-10, str.length);
  }
  return str;
}