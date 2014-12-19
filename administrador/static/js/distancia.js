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
    map = new google.maps.Map(document.getElementById("map"), a);
    if (document.getElementById("driving").checked) {
        directionsDisplay.setMap(map);
        calculateDistances(address1, address2)
    } else {
        if (document.getElementById("air").checked) {
            distance(address1, address2)
        }
    }
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
function calculateDistances(c, b) {
    var a = new google.maps.DistanceMatrixService();
    a.getDistanceMatrix({origins: [c], destinations: [b], travelMode: google.maps.TravelMode.DRIVING, unitSystem: google.maps.UnitSystem.METRIC, avoidHighways: false, avoidTolls: false}, callback)
}
function callback(c, b) {
    if (b != google.maps.DistanceMatrixStatus.OK) {
        alert("Error: " + b)
    } else {
        var h = c.originAddresses;
        var a = c.destinationAddresses;
        for (var f = 0; f < h.length; f++) {
            var e = c.rows[f].elements;
            for (var d = 0; d < e.length; d++) {
                var g = 0.621371192 * parseInt(e[d].distance.value)/1000;
                document.getElementById("totaldistancemiles").value = g.toFixed(2);
                document.getElementById("totaldistancekm").value = (g / 0.621371192).toFixed(2)
                document.getElementById("totaldistancenamiles").value = (g * 0.868976242).toFixed(2);
            }
        }
        calcRoute()
    }
}
function calcRoute() {
    var c = document.getElementById("distancefrom").value;
    var a = document.getElementById("distanceto").value;
    var b = {origin: c, destination: a, travelMode: google.maps.DirectionsTravelMode.DRIVING};
    directionsService.route(b, function(e, d) {
        if (d == google.maps.DirectionsStatus.OK) {
            directionsDisplay.setDirections(e)
        }
    })
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
                document.getElementById("totaldistancemiles").value = e.toFixed(2);
                document.getElementById("totaldistancekm").value = dist.toFixed(2);
                document.getElementById("totaldistancenamiles").value = (e * 0.868976242).toFixed(2);
                showMap(b, f)
            }
        }
    })
}
function showMap(f, e) {
    latlng = new google.maps.LatLng((f.lat() + e.lat()) / 2, (f.lng() + e.lng()) / 2);
    faddress1 = document.getElementById("distancefrom").value;
    faddress2 = document.getElementById("distanceto").value;
    var i = [f, e];
    var h = new google.maps.Polyline({path: i, strokeColor: "#FF0000", strokeOpacity: 0.5, geodesic: true, strokeWeight: 4});
    h.setMap(map);
    var h = new google.maps.Polyline({path: i, strokeColor: "#000000", strokeOpacity: 0.5, strokeWeight: 4});
    h.setMap(map);
    var g = "http://www.distancefromto.net/images/igreen.png";
    var c = new google.maps.Marker({map: map, icon: g, position: f});
    var j;
    j = new google.maps.LatLngBounds();
    j.extend(f);
    j.extend(e);
    map.fitBounds(j);
    var b = new google.maps.InfoWindow();
    b.setContent(faddress1);
    google.maps.event.addListener(c, "click", function() {
        b.open(map, c)
    });
    var a = new google.maps.Marker({map: map, icon: g, position: e});
    var d = new google.maps.InfoWindow();
    d.setContent(faddress2);
    google.maps.event.addListener(a, "click", function() {
        d.open(map, a)
    })
}
;
