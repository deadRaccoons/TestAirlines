  var receive_sugesstions = true; 

 $(function() {

  $logo = $("#ll");

  $("#origin-query").focus(function() {
    console.log("focus");
    $("#ll4").html($logo);

    $( ".logo-head" ).hide('slow');
    $("#fly-details").show('slow');
  });
  
  var destino = $("#destiny-query").val();


  $("#origin-query").keypress(function(e) {
      if (e.keyCode == 8) {
          receive_sugesstions =  true;
        }

      if (receive_sugesstions) {
        $.getJSON( "/ciudads", {
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
        $.getJSON( "/ciudads", {
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
      rs =  true;
      $(this).hide();
      $("#destiny-query").val(name);

   })

   $("#control-up").on('click', function(e){
    e.preventDefault();

   });

  

});


var show_destiny_suggestions =  function(json, container) {
  container.empty();
  var html  = "<ul>";
    $.each(json, function( index, ciudad ) {
       html += "<li><a class='ss' data-city_name='"+ "[" + ciudad.IATA+"]" +  " " + ciudad.nombre  +"'><i>"+ ciudad.IATA +"</i><o>" + ciudad.nombre + "</o></a><li>"

    });
    html  += "</ul>";

    container.append(html);
    
}


var buscaVuelo = {};
buscaVuelo.origenIATA = null;
buscaVuelo.destinoIATA =  null;


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

