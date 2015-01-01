  var receive_sugesstions = true; 
  var origenDestino = 1;

 $(function() {

  updateDate();



  $("nav").find("a").each(function(k,v){ 
      loc = $(v).attr("href");
      $(v).removeClass("active")

      if(loc === location.pathname)
        $(v).addClass("active")
    });

  $("#destinos").delegate(".city_as_origin", "click", function(e){
    showSideBar();
    var IATA = $(this).attr("data-IATA");
    $("#origin-query").val(IATA);
  });

   $("#destinos").delegate(".city_as_destiny", "click", function(e){
  showSideBar();
    var IATA = $(this).attr("data-IATA");
    $("#destiny-query").val(IATA);

  });




  $logo = $("#ll");

  $("#origin-query").focus(function() {
    console.log("focus");
    showSideBar();
  });
  
  var destino = $("#destiny-query").val();


  $("#origin-query").keypress(function(e) {
      if (e.keyCode == 8) {
          receive_sugesstions =  true;
        }

      if (receive_sugesstions) {
        $.getJSON( "/ciudades/u/sugerencias", {
              q: $(this).val(),
            })
           .done(function( data ) {
              $data = $("#origin-suggestions");
              show_destiny_suggestions(data, $data);
              $data.show('slow');
            });
      } else {
        $("#origin-suggestions").hide();
      } 
      

    });


   $("#origin-suggestions").delegate(".ss", "click", function(){
        var name = $(this).attr("data-city_name");

      $(this).hide();
      receive_sugesstions =  false;
      $("#origin-query").val(name);

   })

   $("#destiny-query").focus(function() {
      $("#ll4").html($logo);
      $( ".logo-head" ).hide('slow');
      $("#fly-details").show('slow');
  });

   var rs = true;

   $("#destiny-query").keypress(function(e) {
    if (e.keyCode == 8) {
        rs =  true;
      }
      if (rs) {
        $.getJSON( "/ciudades/u/sugerencias", {
              q: $(this).val(),
            })
           .done(function( data ) {
              $data = $("#destiny-suggestions");
              show_destiny_suggestions(data, $data);
              $data.show('slow');
            });
      } else {
        $("#destiny-suggestions").hide();
      } 

    });

   $("#destiny-suggestions").delegate(".ss", "click", function() {
      var name = $(this).attr("data-city_name");

      $(this).hide();
      receive_sugesstions =  false;
      $("#destiny-query").val(name);

   })

   $("#control-up").on('click', function(e){
      e.preventDefault(); 
      flySearch.parameters.seats = (++flySearch.parameters.seats >= 8) ? 8 : flySearch.parameters.seats;
      $("#passenger-count").text(flySearch.parameters.seats);
   });

   $("#control-down").on('click', function(e){
      e.preventDefault(); 
      flySearch.parameters.seats = (--flySearch.parameters.seats <= 1) ? 1 : flySearch.parameters.seats;
      $("#passenger-count").text(flySearch.parameters.seats);
   });

   var $galleryDetails = $("#galley-details");
   var actualSelector = null; 


   /* controlador para el calendario */ 
   $("#calendar-departure-date").on("click", function(e){
      $galleryDetails.html(calendar.fillCalendar(12));
      $galleryDetails.show("slow");
      actualSelector = "calendar-departure-date";
   });

   /* controlador para el otro calendario */
   $("#calendar-land-date").on("click", function(e){
      $galleryDetails.show("slow");
      actualSelector = "calendar-land-date";
   });

  $container = $("#galley-details");

  $container.delegate(".day", "click", function(e){
      e.preventDefault();
      var prettyDate = JSON.parse($(this).attr("data-pretty-date").toString());
      var date = $(this).attr("data-date").split("/");
      var prefix = (actualSelector === "calendar-departure-date") ? "dep-" : "land-";

      $("#"+prefix + "day").text(prettyDate.day);
      $("#"+prefix + "month").text(prettyDate.month);
      $("#"+prefix + "year").text(prettyDate.year);

      if (prefix === "dep-") {
        prefix = "land-"
        var d  = new Date(date[2], date[1], date[0])
        var day =  d.setDate(d.getDate() + 7);
        $("#"+prefix + "day").text(d.getDate());
        $("#"+prefix + "month").text(calendar.date.getMonth(d.getMonth()).substr(0,3));
        $("#"+prefix + "year").text(d.getFullYear());
      }

      $container.hide("slow")

  });


  

});


var show_destiny_suggestions =  function(json, container) {
  container.empty();
  var html  = "<ul>";
    $.each(json, function( index, ciudad ) {
       html += "<li><a class='ss' data-IATA='"+ ciudad.IATA +"' data-city_name='"+ "[" + ciudad.IATA+"]" +  " " + ciudad.nombre  +"'><i>"+ ciudad.IATA +"</i><o>" + ciudad.nombre + "</o></a><li>"

    });
    html  += "</ul>";

    container.append(html);
    
}


var updateDate =  function () {
   var t = new Date();
  
  var prefix = "dep-";
  $("#"+prefix + "day").text(t.getDate());
  $("#"+prefix + "month").text(calendar.date.getMonth(t.getMonth()).substr(0,3));
  $("#"+prefix + "year").text(t.getFullYear());
  
  prefix = "land-";
  t.setDate(t.getDate() + 7)
  $("#"+prefix + "day").text(t.getDate());
  $("#"+prefix + "month").text(calendar.date.getMonth(t.getMonth()).substr(0,3));
  $("#"+prefix + "year").text(t.getFullYear());
}




var gallery = {};
gallery.sources = [["/assets/adds/1.jpg","Viaja al himalaya"],
                  ["/assets/adds/2.jpg","Cualquier parte"],
                    ["/assets/adds/3.jpg","Visita París"]];
gallery.index = 0;

gallery.next = function() {
  var i =(gallery.sources.length - gallery.index++)%gallery.sources.length;

     $("#iddi").css({
        backgroundImage:"url("+gallery.sources[Math.abs(i)][0]+")",
     });
       $("#add-msg-title").text(gallery.sources[Math.abs(i)][1]);

      console.log(i);

}

gallery.prev = function() {
    var i =(gallery.sources.length - gallery.index--)%gallery.sources.length;

  $("#iddi").css({
        backgroundImage:"url("+gallery.sources[Math.abs(i)][0]+")",
     });
  $("#add-msg-title").text(gallery.sources[Math.abs(i)][1]);

}

var blrr =  function() {
    /*
    $('#finder').blurjs({
      source: '#iddi',
      radius: 50,
    });
 */
}



var updateDestiny =  function () {
   origenDestino = location.toString().split("/").pop().split("?").pop("&").split("&")
   
   if (origenDestino.length  == 1) {
      return;
   }


}


var showSideBar =  function() {
      $("#ll4").html($logo);
      $( ".logo-head" ).hide('slow');
      $("#fly-details").show('slow');
}