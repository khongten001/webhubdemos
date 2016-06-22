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
        var e = $("#fileupload");



    e.fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: e.attr("action")
    });

        
         e.fileupload('option',{
            dropZone: $('#dropzone'),
            url: e.attr("action"),
            type: "POST",
            autoUpload: false,
            dataType: "json",
            sequentialUploads: false,
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
                console.log("fail")
            },
            success: function(e) {
                var t = decodeURIComponent($(e).find("Location").text());
                $("#photo_file").val(t)
            },
            done: function(e, t) {
                $(".progress").fadeOut(300, function() {
                    $(".bar").css("width", 0)
                })
            }
        });


/*        e.bind('fileuploadadded', function (e, n) {
            console.log(n);
             var localFilesArr       = new Array();
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
                        e.find("input[name=key]").val(t.key), e.find("input[name=policy]").val(t.policy), e.find("input[name=signature]").val(t.signature)
                    }
                })
        });
*/
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