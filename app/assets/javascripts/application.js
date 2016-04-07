//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

// blank
$.is_blank = function (obj) {
  if (!obj || $.trim(obj) === "") return true;
  if (obj.length && obj.length > 0) return false;

  for (var prop in obj) if (obj[prop]) return false;
  return true;
}

var parti_prepare_action = function($base) {
  if($base.data('parti-action-prepared') == 'completed') {
    return;
  }

  var parti_apply = function(query, callback) {
    $.each($base.find(query), function(i, elm){
      callback(elm);
    });
  }

  parti_apply('input:radio[data-action="parti-enable-submit-button"]', function(elm) {
    $(elm).on('click', function() {
      var $submit_button = $($(elm).data('parti-submit-button'));
      $submit_button.prop('disabled', false);
    });
  });

  parti_apply('input:text[data-action="parti-enable-submit-button"]', function(elm) {
    $(elm).on('keydown', function() {
      var $submit_button = $($(elm).data('parti-submit-button'));
      if($.is_blank($(elm).val())) {
        $submit_button.prop('disabled', true);
      } else {
        $submit_button.prop('disabled', false);
      }
    });
  });

  $base.data('parti-action-prepared', 'completed');
}

$(function(){
  parti_prepare_action($('body'));
});

