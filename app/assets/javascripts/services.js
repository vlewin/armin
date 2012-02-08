$(document).ready(function(){
  var list = 0;
  $('input.search').quicksearch('table.services tbody tr', {
    'noResults': 'tr#noresults'
  });

  $("#services a.remoteLink").live("click", function() {
    $("#flash").html("");
    var service = { "pid": $(this).data("pid"), "name" : $(this).data("name"), "action" : $(this).data("action")}
    var $parent = $(this).parents("tr")

    $parent.find("img").toggle()
    $parent.find("td.status").html("please wait …");

    $.ajax({
      url: "/services/action",
      data: service,
      success: function(data){
        $("#services").html(data);

        $('input.search').quicksearch('table.services tbody tr', {
          'noResults': 'tr#noresults',
          'onAfter': function () {
            console.log('on after');
          }
        });
      }
    });
  });

  $("a.action").live("click", function() {
    $("#slider").stop().animate({"margin-left":-940},200)
  })

  $('table').paginate({
    rowsPerPage: 10,
    startRow: 1
  });



/*

getFileSystemUsage();


function getFileSystemUsage() {
  console.log(list)
  $.getJSON('filesystem', "partition=rootfs", function(json) {
    $.plot($("#graph3"), json, options);
  })
}
*/

//	setInterval(getData, 1000);


});
