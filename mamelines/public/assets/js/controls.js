 $(function() {
  
  $("#gallery-prev").on('click', function(){
    gallery.prev();
    blrr();
  });

  $("#gallery-next").on('click', function(){
      gallery.next();
      blrr();
    });

  blrr();


  var $menu = $('nav#menu'),
  $html = $('html, body');

  $menu
    .mmenu()
    .find( 'a' )
    .on( 'click',
      function()
      {
        var href = $(this).attr( 'href' );
        $menu.one(
          'closed.mm',
          function()
          {
            setTimeout(
              function()
              {
                $html.animate({
                  scrollTop: $( href ).offset().top
                }); 
              }, 10
            );  
          }
        );
      }
    )
    .end()
    .find( 'li' )
    .first()
    .trigger( 'setSelected' );
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

