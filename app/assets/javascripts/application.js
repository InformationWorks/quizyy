// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require turbolinks
//= require jquery.turbolinks
//= require jquery_ujs
//= require libs/jquery-ui-1.9.2.custom.min
//= require libs/modernizr.custom
//= require libs/d3.min
//= require bootstrap
//= require bootstrap-datepicker
//= require backbone/json2
//= require backbone/underscore
//= require backbone/backbone
//= require backbone/marionette/backbone.marionette
//= require backbone/backbone.routefilter
//= require backbone/backbone-associations
//= require backbone/marionette/jquery.resolved
//= require_tree ../templates
//= require gre340
//= require gre340.routing
//= require ./testcenter/gre340.testcenter
//= require ./testcenter/gre340.testcenter.layout
//= require ./testcenter/gre340.testcenter.data
//= require ./testcenter/gre340.testcenter.views
//= require ./testcenter/gre340.testcenter.controllers
//= require tinymce
//= require jquery-fileupload/basic
//= require practice_tests
//= require libs/jquery.calculator
//= require_tree .

Backbone.Marionette.Renderer.render = function(template, data){
    if (!JST[template]) throw "Template '" + template + "' not found!";
    return JST[template](data);
}

function scrollToElement(el) {
    $("html, body").stop().animate({
        scrollLeft: $(el).offset().left,
        scrollTop: $(el).offset().top-150
    }, 1500);
}