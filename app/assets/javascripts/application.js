//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

var parti_prepare_action = function($base) {
  if($base.data('parti-action-prepared') == 'completed') {
    return;
  }

  var parti_apply = function(query, callback) {
    $.each($base.find(query), function(i, elm){
      callback(elm);
    });
  }

  parti_apply('input:checkbox[data-action="parti-check-only-one"]', function(elm) {
    $(elm).click(function() {
      if ($(this).is(":checked")) {
        var group = "input:checkbox[name='" + $(this).attr("name") + "']";
        $(group).prop("checked", false);
        $(this).prop("checked", true);
      } else {
        $(this).prop("checked", false);
      }
    });
  });


  $base.data('parti-action-prepared', 'completed');
}

$(function(){
  parti_prepare_action($('body'));
});

