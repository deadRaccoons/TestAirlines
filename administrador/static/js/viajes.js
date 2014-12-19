function quita(){
    var x = document.getElementById("origen");
    var s = x.options[x.selectedIndex].value;
    var y = "Todos menos seleccionado "+ s;
    var n = document.getElementById("destino");
    var i;
    var j;
    for(j = 0; j < x.length; j++){
        n.remove(0);
    }
    if(s == "nada"){
	var d = document.getElementById("distancia");
	d.value = "0";
        fecha(0);
    } else {
	for(i = 1; i < x.length; i++){
	    if(s != x.options[i].value){
		var o = document.createElement("option");
		o.text = x.options[i].text;
              o.value = x.options[i].value;
              n.add(o);
	    }
	}
	fecha(1);
	initialize();
    }   
};
function fecha(p){
    var m = document.getElementById("mes");
    var v = m.value;
    var i;
    var meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sept", "Oct", "Nov", "Dic"];
    if(p == 1){
        for(i = 0; i < 12; i++){
            var o = document.createElement("option");
            o.text = meses[i];
            if(i < 10)
		o.value = "0"+ i;
            else o.value = ""+i
            m.add(o);
        }
    } else {
        for(i = 0; i < 12; i++){
            m.remove(0);
        }
    }
    dias();
};
function dias(){
    var d = document.getElementById("dia");
    for(i = 1; i < 32; i++){
        var o = document.createElement("option");
        if(i < 10){
            o.text = "0"+ i;
            o.value = "0"+i;
        } else{
            o.text = ""+ i;
            o.value = ""+ i;
        }
        d.add(o);
    }
    hora();
};
function hora(){
    var h = document.getElementById("hora");
    for(i = 1; i < 25; i++){
        var o = document.createElement("option");
        if(i < 10){
            o.text = "0"+ i;
            o.value = "0" +i;
        } else {
            o.text = ""+i;
            o.value = ""+i;
        }
        h.add(o);
    }
    var m = document.getElementById("minuto");
    var o = document.createElement("option");
    o.text = "00";
    o.value = "00";
    m.add(o);
};
function crear(){
    var o = document.getElementById("origen");
    var v = o.options[o.selectedIndex].value;
    var errores = "";
    var r = "0";
    if(v == "nada"){
	errores = errores +  "Selecciona un pais origen";
	r = "1";
    }
    if(document.getElementById("distancia").value == 0){
	errores = errores + "\nDistancia es cero";
	r = "1";
    }
    if(r == "1"){
	alert(errores);
	return false;
    }
    return false;
};
var geocoder;
var map;
var addresses;
var results;
var dist;
var markersArray = [];
var bounds = new google.maps.LatLngBounds();
var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
function initialize() {
    geocoder = new google.maps.Geocoder();
    directionsDisplay = new google.maps.DirectionsRenderer();
    address1 = document.getElementById("origen").value;
    address2 = document.getElementById("destino").value;
    var b = new google.maps.LatLng(0, 0);
    var a = {zoom: 1, center: b, mapTypeId: google.maps.MapTypeId.ROADMAP,scaleControl: true};
    map = new google.maps.Map(document.getElementById("googleMap"), a);
    distance(address1, address2)
}
function distance(b, a) {
    if (!geocoder) {
        return"Error, no geocoder"
    }
    addresses = new Array(2);
    addresses[0] = b;
    addresses[1] = a;
    results = new Array(2);
    results[0] = new Array(2);
    results[1] = new Array(2);
    results[0][0] = 0;
    results[0][1] = 0;
    results[1][0] = 0;
    results[1][1] = 0.87;
    geocoded(1)
}
function geocoded(a) {
    geocoder.geocode({address: addresses[a]}, function(d, c) {
        if (c == google.maps.GeocoderStatus.OK) {
            results[a][0] = parseFloat(d[0].geometry.location.lat());
            results[a][1] = parseFloat(d[0].geometry.location.lng());
            a--;
            if (a >= 0) {
                geocoded(a)
            } else {
                var b = new google.maps.LatLng(results[0][0], results[0][1]);
                var f = new google.maps.LatLng(results[1][0], results[1][1]);
                dist = google.maps.geometry.spherical.computeDistanceBetween(b, f) / 1000;
                var e = 0.621371192 * dist;
                document.getElementById("distancia").value = e.toFixed(0);
            }
        }
    })
}
