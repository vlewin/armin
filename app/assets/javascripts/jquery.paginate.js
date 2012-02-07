(function( $ ){

  $.fn.paginate= function( options ) {  

    var defaults = {
      rowsPerPage : 10,
      startRow : 1
      
    };

    //call in the default otions
    var options = $.extend(defaults, options);

    return this.each(function() {
	  var $table = $(this);
	  var $rows = $table.find('tbody tr').hide();
	  $rows.slice(options.startRow, options.rowsPerPage+options.startRow).show();
      
      var navigation = '<div id="navigation" style="text-align:center; margin:0px 0px 10px 0px;">';
      var counter = 1;
      for(var i=0; i<$rows.size() - options.startRow; i++) {
      	console.log(i%10)
      	if(i%10==0 && i > 9) {
      	  counter += 1;
      	  navigation += '<span>&nbsp;<a href="#" class="pageLink">' + (i/10) +'</a>&nbsp;</span>';
      	}
      }
      
      if($rows.size()%10 != 0) {
      	navigation += '<span>&nbsp;<a href="#" class="pageLink">' + counter +'</a>&nbsp;</span>';
      }
      
      navigation += '</div>';
      
	  $table.after(navigation);
	  
	  $('a.pageLink').live('click', function(e) {
	    e.preventDefault();
	    $rows.hide();
	    var end = (parseInt($(this).html())*10);
	    var start = options.startRow;
	    start += end - 10;
	     
	    
	    var range = $rows.slice(start, end).show();
		return false;
	  });	  
      // Here you add your jQuery plugin code

    });

  };
})( jQuery );