(function( $ ){

  $.fn.paginate= function( options ) {

    var defaults = {
      rowsPerPage : 10,
      startRow : 0,
    };

    var options = $.extend(defaults, options);

    return this.each(function() {

      var $table = $(this);
      var $rows = $table.find('tbody tr');
      var quantity = $rows.size();

      if(quantity > options.rowsPerPage) {
        var navigation = '<div id="navigationToolbar">';
        var counter = 1;

        $rows.hide();
        $rows.slice(options.startRow, (options.rowsPerPage+options.startRow)).show();

        for(var i=0; i< (quantity-options.startRow); i++) {
          if(i%options.rowsPerPage == 0 && i > (options.rowsPerPage-1)) {
            if(counter == 1) {
              navigation += '<a href="#" class="navigationLink selected">' + (i/options.rowsPerPage) +'</a>';
            } else {
              navigation += '<a href="#" class="navigationLink">' + (i/options.rowsPerPage) +'</a>';
            }
            counter += 1;
          }
        }

        if(quantity%options.rowsPerPage != 0) {
          navigation += '<a href="#" class="navigationLink">' + counter +'</a>';
        }

        navigation += '</div>';
        $table.after(navigation);

        $('#navigationToolbar a.navigationLink').live('click', function(e) {
          $('#navigationToolbar a.navigationLink').not(this).removeClass('selected');
          $(this).toggleClass('selected');

          $rows.hide();
          var range = 0;
          var start = options.startRow;
          var end = (parseInt($(this).html()) * options.rowsPerPage) + start;

          start = (end - options.rowsPerPage);
          range = $rows.slice(start, end).show();

          return false;
        });
      }

    });

  };
})( jQuery );
