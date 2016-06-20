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
$(function() {
        'use strict';
        var e = $("#fileupload");
        e.fileupload({
            url: e.attr("action"),
            type: "POST",
            autoUpload: !0,
            dataType: "json",
            add: function(t, n) {
                console.log(n);
                $.ajax({
                    url: file_upload_options.sign_url,
                    type: "POST",
                    dataType: "json",
                    data: {
                        fname: n.files[0].name,
                        ftype: n.files[0].type,
                        fsize: n.files[0].size,
                        flastmodified: n.files[0].lastModified
                    },
                    success: function(t) {
                        e.find("input[name=key]").val(t.key), e.find("input[name=policy]").val(t.policy), e.find("input[name=signature]").val(t.signature)
                    }
                }), n.submit()
            },
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
        })
});