$(function() {
  var itemWidth = $("#colour-chart li").width();
  // hide 50% of each window
  var itemPosition = itemWidth * 50 / 100;
  // slide each window 60% if its width    
  var itemMove = itemWidth * 60 / 100;        
  // move windows below eachother
  $("#colour-chart li").each(function(i) {
    $(this).attr("id", i).css("z-index", 100 - i).css("left", itemPosition * i);
  });

  $("#colour-chart li").click(function(e) {
    var currentID = parseInt($(".current").attr("id"));
    var clickedID = parseInt($(this).attr("id"));

    if (currentID != clickedID) {
      e.preventDefault();
      var currentZ = 99;
      var current = $(this);
      setTimeout(function() { $(".current").removeClass("current"); current.css("z-index", currentZ).addClass("current"); }, 500);

      if (clickedID > currentID) {
        var i = 1;
        var total = currentZ - currentID + 1;
        for (j = clickedID - 1; j >= 0; j = j - 1) {
          $("#" + j).animate({ "left": "-=" + itemMove * (i) + "px" }, 500);
          $("#" + j).animate({ "left": "+=" + itemMove * (i) + "px" }, 300);
          i = i + 1;
        }
        var i = 1;
        setTimeout(function() {
          for (j = clickedID - 1; j >= 0; j = j - 1) {
            $("#" + j).css("z-index", currentZ - i);
            i = i + 1;
          }
        }, 500);
      } else {
        var i = 1;
        var total = $("#container li").length;
        for (j = clickedID + 1; j <= total; j = j + 1) {
          $("#" + j).animate({ "left": "+=" + itemMove * i + "px" }, 500);
          $("#" + j).animate({ "left": "-=" + itemMove * i + "px" }, 300);
          $("#" + j).css("z-index", currentZ - i);
          i = i + 1;
        }
      }
    }
  });
});

