function quita(){
    var x = document.getElementById("origen");
    var s = x.options[x.selectedIndex].value;
    var y = "Todos menos seleccionado "+ s;
    var n = document.getElementById("destino");
    var a1 = document.getElementById("mys");
    var a2 = document.getElementById("aviones");
    var i;
    var j;
    for(j = 0; j < x.length; j++){
        n.remove(0);
    }
    for(j = 0; j < a1.length; j++){
        a2.remove(0);
    }
    if(s == "nada"){
	   var d = document.getElementById("distancia");
	   d.value = "0";
    } else {
	   for(i = 1; i < x.length; i++){
	        if(s != x.options[i].value){
		      var o = document.createElement("option");
		      o.text = x.options[i].text;
              o.value = x.options[i].value;
              n.add(o);
	    }
	}
	initialize();
    aviones();
    }   
};
function mes(){
    var m = document.getElementById("mes");
    var v = m.value;
    var i;
    var meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sept", "Oct", "Nov", "Dic"];
    for(i = 0; i < 12; i++){
        var o = document.createElement("option");
        o.text = meses[i];
        if(i < 9){
	    o.value = "0"+ i;
        } else {
	    o.value = ""+ i;
	}
        m.add(o);
    }
    dias();
    hora();
};
function dias(){
    var v = document.getElementById("mes").value;
    var d = document.getElementById("dia");
    var n = 32;
    for (var i = 0; i <32; i++) {
        d.remove(0);
    };
    if(v == "01")
	n = 29;
    if(v == "03" || v == "04" || v == "05" || v == "08" || v == "10")
	n = 31;
    for(i = 1; i < n; i++){
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
    aviones();
};
function hora(){
    var h = document.getElementById("hora");
    for(i = 0; i < 24; i++){
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
};
function crear(){
    var o = document.getElementById("origen");
    var v = o.options[o.selectedIndex].value;
    var today = new Date();
    var day = new Date(document.getElementById("anio").value, document.getElementById("mes").value, document.getElementById("dia").value, document.getElementById("hora").value, document.getElementById("minuto").value, 00, 00);
    var dif = parseInt((day.getTime()-today.getTime())/(24*3600*1000));
    var errores = "";
    var r = "0";
    if(v == "nada"){
	errores = errores +  "Selecciona un pais origen";
	r = "1";
    }
    if(document.getElementById("distancia").value < 200){
	errores = errores + "\nDistancia muy corta";
	r = "1";
    }
    if(document.getElementById("distancia").value > 7000){
	errores = errores + "\nDistancia muy grande";
	r = "1";
    }
    if(dif < 7){
        errores = errores + "\nLa Fecha debe ser mas de 7 dias apartir de este";
        r = "1";
    }
    if(r == "1"){
	alert(errores);
	return false;
    }
    return true;
};
var geocoder;
var map;
var addresses;
var results;
var dist;
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
function otra(){
    var a1 = document.getElementById("mys");
    var a2 = document.getElementById("aviones");
    for(j = 0; j < a1.length; j++){
        a2.remove(0);
    }
    aviones();
}
function aviones(){
    var a = document.getElementById("idavion");
    var a1 = document.getElementById("mys");
    var a2 = document.getElementById("aviones");
    var d = document.getElementById("origen").value;
    var j;
    var day = new Date(document.getElementById("anio").value, document.getElementById("mes").value, document.getElementById("dia").value, document.getElementById("hora").value, document.getElementById("minuto").value, 00, 00);
    for(j = 0; j < a1.length; j++){
        var o = document.createElement("option");
        o.value = a.options[j].value;
        o.text = a.options[j].text;
        if(a1.options[j].value == d){
            var fecha = new Date(a1.options[j].id +" "+ a1.options[j].text);
            var dif = parseInt((day.getTime()-fecha.getTime())/(60*1000));
            if(dif > 59){
                a2.add(o);
            }
        }
        if(a1.options[j].value == "Nada"){
            a2.add(o);
        }
    }
}