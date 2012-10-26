
$(function() {

	$('#giftIndexWrapper').isotope({
		// options
	  itemSelector : '.item',
	  layoutMode : 'masonry',
	});

 	// cache container
 	var $container = $('#containerIsotope');
 	// initialize isotope
 	$container.isotope({
  	// options...
  	columnWidth: 180
 });

	$('#filters a').click(function(){
	  var selector = $(this).attr('data-filter');
	  $container.isotope({ filter: selector });
	  return false;
	});	
});

