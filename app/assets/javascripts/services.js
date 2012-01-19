$(document).ready(function(){
  $("#services a").click(function() {
    var service = { "pid" : $(this).data("pid")}
    $.ajax({
      
      url: "/services/action",
      data: service,
      success: function(){
        $(this).addClass("done");
      }
    });
  });
});
