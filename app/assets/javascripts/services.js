$(document).ready(function(){
  $('input.search').quicksearch('table.services tbody tr', {
    'noResults': 'tr#noresults',
  });

  $("#services a").live("click", function() {
    var service = { "pid": $(this).data("pid"), "name" : $(this).data("name"), "action" : $(this).data("action")}
    var $parent = $(this).parents("tr")
    $parent.find("img").toggle()

    $parent.find("td.status").html("please wait ...")
    $.ajax({
      url: "/services/action",
      data: service,
      success: function(data){
        $("#services").html(data);

        $('input.search').quicksearch('table.services tbody tr', {
          'noResults': 'tr#noresults',
        });
      }
    });
  });

  $("a.action").live("click", function() {
    console.log("sss")
    $("#slider").stop().animate({"margin-left":-940},200)
  })
});
