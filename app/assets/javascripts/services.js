$(document).ready(function(){
  $('input.search').quicksearch('table.services tbody tr', {
    'noResults': 'tr#noresults',
  });

  $("#services a").live("click", function() {
    var service = { "pid": $(this).data("pid"), "name" : $(this).data("name"), "action" : $(this).data("action")}
    $.ajax({
      url: "/services/action",
      data: service,
      success: function(data){
        console.log(data)
        $("#services").html(data);

        $('input.search').quicksearch('table.services tbody tr', {
          'noResults': 'tr#noresults',
        });
      }
    });
  });
});
