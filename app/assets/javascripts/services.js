$(document).ready(function(){
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


//  var data = [];
//var series = Math.floor(Math.random()*10)+1;
//for( var i = 0; i<series; i++)
//{
//data[i] = { label: "Series"+(i+1), data: Math.floor(Math.random()*100)+1 }
//}

//console.log(data)
//data = [{"data":95, "label":"Serie"}, {"data":95, "label":"Serie"}]

//  $.plot($("#graph1"), data, {
//    series: {
//      pie: {
//        show: true
//      }
//    },
//    legend: {
//      show: false
//    }
//  });


var data = [{"data":10, "label":"used"}, {"data":10, "label":"free"}];
var options = {
  series: {
    pie:{
      show: true,
      radius:1,
      label: {
         show: true,
         color: '#222',
         radius: 80,
         formatter: function(label, series){
            return '<div class="chart-label"> ' + Math.round(series.percent)+'%<br/>' + label + '</div>';
         }

      },
      background: { opacity: 0.8 }
    }

  },

  legend:{show: false}

  }

	$.getJSON('filesystem', "name=sda1", function(json) {
      $.plot($("#graph1"), json, options);

	})

	$.getJSON('filesystem', "name=sda3", function(json) {
      $.plot($("#graph2"), json, options);
	})

	$.getJSON('filesystem', "name=sda5", function(json) {
      $.plot($("#graph3"), json, options);
	})
//	setInterval(getData, 1000);


});
