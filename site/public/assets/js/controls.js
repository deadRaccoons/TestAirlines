 $(function() {

  $logo = $("#ll");

  $("#origin-query").focus(function() {
    console.log("focus");
    $("#ll4").html($logo);

    $( ".logo-head" ).hide('slow');
    $("#fly-details").show('slow');
  });
  
  var destino = $("#destiny-query").val();
  var sugesstions = "?q=";

  $("#origin-query").keyup(function(e){
      $.getJSON( "/ciudads", {
            q: $(this).val(),
          })
         .done(function( data ) {
            $data = $("#origin-suggestions");
            show_destiny_suggestions(data, $data);
            $data.show('slow');
          });
    });
  

});


var show_destiny_suggestions =  function(json, container) {
  container.empty();
  var html  = "<ul>";
    $.each(json, function( index, ciudad ) {
       html += "<li><a data='hola'><i>"+ ciudad.IATA +"</i><o>" + ciudad.nombre + "</o></a><li>"

    });
    html  += "</ul>";

    container.append(html);
    
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

