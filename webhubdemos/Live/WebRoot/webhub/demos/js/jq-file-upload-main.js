/*
 * jQuery File Upload Plugin JS Example
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */
/* global $, window */

/*$(function () {
    'use strict';

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: 'server/php/'
    });

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );

        // Demo settings:
        $('#fileupload').fileupload('option', {
            url: '//jquery-file-upload.appspot.com/',
            // Enable image resizing, except for Android and Opera,
            // which actually support image resizing, but fail to
            // send Blob objects via XHR requests:
            disableImageResize: /Android(?!.*Chrome)|Opera/
                .test(window.navigator.userAgent),
            maxFileSize: 999000,
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
        });
        // Upload server status check for browsers with CORS support:
      
    } else {
        // Load existing files:
        $('#fileupload').addClass('fileupload-processing');
        $.ajax({
            // Uncomment the following to send cross-domain cookies:
            //xhrFields: {withCredentials: true},
            url: $('#fileupload').fileupload('option', 'url'),
            dataType: 'json',
            context: $('#fileupload')[0]
        }).always(function () {
            $(this).removeClass('fileupload-processing');
        }).done(function (result) {
            $(this).fileupload('option', 'done')
                .call(this, $.Event('done'), {result: result});
        });
    }

});*/


$(function() {
        'use strict';
        // Initialize the jQuery File Upload widget:
        var form= $("#fileupload");

        
         form.fileupload({
            dropZone: $('#dropzone'),
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png|mp3|mp4)$/i,
            maxFileSize: 400000, //400kbytes //400000
            url: form.attr("action"),
            type: "POST",
            autoUpload: false,
            dataType: "XML",
            sequentialUploads: true,
/*            add: function(t, n) {
                console.log(n.files);
                var localFilesArr       = new Array();
                var jsonArg1            = new Object();
                jsonArg1.fname          = n.files[0].name,
                jsonArg1.ftype          = n.files[0].type,
                jsonArg1.fsize          = n.files[0].size,
                jsonArg1.flastmodified  =n.files[0].lastModified

                $.ajax({
                    url: file_upload_options.sign_url,
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
                            var key = SignData.awsResource;
                            var policy = SignData.awsPolicy64;
                            var signature = SignData.awsUploadSignature;
                            var awsDownloadURL = SignData.awsDownloadURL;
                            e.find("input[name=key]").val(key), e.find("input[name=policy]").val(policy), e.find("input[name=signature]").val(signature)
                        }
                        
                    }
                }),n.submit() 
            },*/
            send: function(e, t) {
                
                $(".progress").fadeIn()
            },
            progress: function(e, t) {
                var n = Math.round(e.loaded / e.total * 100);
                $(".bar").css("width", n + "%")
            },
            fail: function(e, t) {
              /*  console.log(t.context);*/
                var ErrMessage  = $(t.jqXHR.responseXML).find("Message").text();
                if(ErrMessage){
                    t.context.find('strong.error').html("Error : "+ ErrMessage);
                }else{
                   t.context.find('strong.error').html("Error : "+ file.error); 
                }
                 
                 //t.context.html(ErrMessage); 
            },
            success: function(e,t) {
               
               //if t=="nocontent" upload complete :) 

                /*var t = decodeURIComponent($(e).find("Location").text());
                   $.ajax({
                        url: file_upload_options.sign_url,
                        type: "POST",
                        dataType: "json",
                        data: {
                           fileDetails: JSON.stringify(jsonArg1)
                        },
                        success: function(data) {
                            var fileName = data.ShowcaseResponse.ConfirmedFname;
                            var ResponseType = data.ShowcaseResponse.ResponseType;
                            var SignData = data.ShowcaseResponse.SignData;
                            if(ResponseType == "OK"){
                                var key = SignData.awsResource;
                                var policy = SignData.awsPolicy64;
                                var signature = SignData.awsUploadSignature;
                                var awsDownloadURL = SignData.awsDownloadURL;
                                e.find("input[name=key]").val(key), e.find("input[name=policy]").val(policy), e.find("input[name=signature]").val(signature)
                            }
                            
                        }
                    });*/
            },
            done: function(e, t) {

                $(".progress").fadeOut(300, function() {
                    $(".bar").css("width", 0)
                })

            }
        });

        form.bind('fileuploadsubmit', function (e, n) {
               var file_type = n.files[0].type;
               n.formData = {
                    'Content-Type': file_type,
                    'key': form.find("input[name=key]").val(),
                    'acl': form.find("input[name=acl]").val(),
                    'Cache-Control': form.find("input[name=Cache-Control]").val(),
                    'AWSAccessKeyId': form.find("input[name=AWSAccessKeyId]").val(),
                    'policy': form.find("input[name=policy]").val(),
                    'signature': form.find("input[name=signature]").val(),
                };
        });
       form.bind('fileuploadadded', function (e, n) {
              //var file_type = n.files[0].type;
               //e.find("input[name=Content-Type]").val(file_type);
             /*var localFilesArr       = new Array();
                var jsonArg1            = new Object();
                jsonArg1.fname          = n.files[0].name;
                jsonArg1.ftype          = n.files[0].type;
                jsonArg1.fsize          = n.files[0].size;
                jsonArg1.flastmodified  =n.files[0].lastModified;

                $.ajax({
                    url: file_upload_options.sign_url,
                    type: "POST",
                    dataType: "json",
                    data: {
                       fileDetails: JSON.stringify(jsonArg1)
                    },
                    success: function(t) {
                        form.find("input[name=key]").val(t.key), e.find("input[name=policy]").val(t.policy), e.find("input[name=signature]").val(t.signature)
                    }
                })*/
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