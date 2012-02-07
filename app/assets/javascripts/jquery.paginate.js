(function( $ ){

  $.fn.paginate= function( options ) {  

    var defaults = {
      rowsPerPage : 5
    };

    //call in the default otions
    var options = $.extend(defaults, options);

    return this.each(function() {
	  var $table = $(this);
	  $table.find('tbody tr').hide();
	  $table.append('<div id="paginateNav"><a class="prev">Prev</a><a class="next">Next</a></div>')
	  
	  $('a.next').live('click', function() {
	  	var range = $table.find('tr').slice(1,10)
	  	range.show();
	  	console.log(tr)
	  	});
	  
	  $('a.prev').live('click', function() {
	    $table.find('tbody tr').hide();
	  	var range = $table.find('tr').slice(11,20)
	  	range.show()
	  	console.log(tr)
	  	});	  
      // Here you add your jQuery plugin code

    });

  };
})( jQuery );