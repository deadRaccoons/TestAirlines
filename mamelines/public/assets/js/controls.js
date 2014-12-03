 $(function() {
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

 $(function(){
  $("#login").on('click',function(e){
    var request = $.ajax({
      url: "/logins/",
    });
     
    request.done(function( msg ) {
      $("#overlay").show();
      $( "#overlay" ).html( msg );
    });
 
  })
 });