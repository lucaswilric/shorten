$('#shorten').on('submit', function(e) {
  e.preventDefault();
  e.stopPropagation();

  var f = $(this);
  $.post(f.attr('action'), f.serialize(), function(data, textStatus) {
  	$('#short-url').text(data);
  });
});