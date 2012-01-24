$(document).ready(function(){
  $("#services a").click(function() {
    var service = { "pid": $(this).data("pid"), "name" : $(this).data("name"), "action" : $(this).data("action")}
    $.ajax({

      url: "/services/action",
      data: service,
      success: function(){
        $(this).addClass("done");
      }
    });
  });
});
