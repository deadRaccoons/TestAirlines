var cargar_ciudades  = function(json, contenedor) {
    $("#"+contenedor).empty();
    var img = "/assets/ciudades/"
	var html = "<div id='gallery'><ul>"
	$.each(json, function(key, ciudad){
        html += crear_tarjeta("/ciudad/" + ciudad.nombre, img + ciudad.IATA+".jpg" ,ciudad)
    });
    html += "</ul></div>";
    console.log(html);
    $("#"+contenedor).append(html);
}

var cargar_error =  function(contenedor) {
	  $("#"+contenedor).empty();

	cargar_contenido("/404.html", contenedor)
}

var cargar_contenido =  function(url, contenedor) {
	    $("#"+contenedor).empty();

	$contenedor = $("#"+contenedor);

}


var cargar_aviones =  function (json, contenedor) {
    $("#"+contenedor).empty();
        var img = "/assets/aviones/"

	var html = "<div id='gallery'><ul>"
	$.each(json, function(key, avion){
        html += crear_tarjeta("/aviones#" + avion.modelo, img  +avion.modelo + ".jpg" , info_avion(avion))
    });
    html += "</ul></div>";
    console.log(html);
    $("#"+contenedor).append(html);
}

var info_avion =  function (avion) {
	var s = " <strong>marca: </strong><span>" + avion.marca +"</span><br/>"        
          + "<strong>modelo: </strong><span>" + avion.modelo +"</span><br/>" 
          + "<strong>capacidad: </strong><span>"+ (avion.capacidadprimera + avion.capacidadturista)  + "</span><br/> ";
          return s;
}

var crear_tarjeta = function(href,imagen, info) {
	var s =  "<a href='"+href+"'><li>";
        s += "<img src='" +imagen + "'/>";
        s += "<div class='info'>" + info + "</div>";
		s += "</li></a>"
	return s;
}
