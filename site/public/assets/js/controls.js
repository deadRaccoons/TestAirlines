 $(function() {

  $("#origin-query").focus(function() {
    console.log("focus");
    $( ".logo-head" ).css( "display", "none" ).fadeOut( 3000 );
  });
  
  

});





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

