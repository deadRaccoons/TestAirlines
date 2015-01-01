/* search for FLY */
var flySearch = flySearch || {

	solidState : false ,
	/* parameters for the query */
	parameters : {
		seats : 1,
		// 0 for turist, 1 for first class
		seatsClass : 0,
		originIATA : null,
		destinyIATA : null,
		returnDate : null,
		dapartureDate : null,
	},


	apiURI : "viajes/0/u/search",
	method: "get",

	/* request for a json response to the server */
	search: function (parameters) {

		var $extra = $("#actions");
		var	$trigger = $("#search");
		var $container = $("#flys");

		if (!flySearch.solidState)
					return;

		$aa = $.ajax({
			url: flySearch.apiURI,
			type: "GET",
			data: flySearch.parameters,
			dataType: "json",
			beforeSend: function() {
				$extra.hide("slow");
				$container.show("slow")
			},
			success: function(json){

				var html  = flySearch._showResults(json);
				$("#flyss").html(html);
			},
			error: function(dato){

			}
		});

		console.log($aa)
	},

	init : function() {
		var origin = $("#destiny-query").val();
		flySearch.parameters.destinyIATA   = flySearch.extractIata(origin)
		var destiny = $("#origin-query").val();
		flySearch.parameters.originIATA = flySearch.extractIata(destiny)
		
		if (origin == destiny){
			alert("Escoge un destino diferente, o un metodo distinto de transporte");
			flySearch.solidState = false;
		}


		flySearch.solidState = (origin != null && destiny != origin && destiny != null);

		


	},

	extractIata : function(word) {
		var z =  word.split("[");
		z =  z.pop();
		z = z.split("]")[0];
		return z;
	},

	/* render the json data to the container */
	_showResults : function (json) {
		if(json.length == 0)
			return "<h1>No existen vuelos en esta tiempo espacio</h1>"
		console.log(json);
		var html = "<ul id='flights-results'>";

		html += "<li id='results-header'><div class='pricing'>"
			+ "<strong>" + "Costo viaje" + "</strong></div>" 
			+ "<div class='class-details'>"
			+ "<strong> Clase </strong>"
			+ "</div>"
			+ "<div class='departure-on'>"
			+ "<strong>" + "Despega en " + "</strong></div>"
			+ "<div class='duration'>"
			+ "<strong>" + "Duración" + "</strong>"
			+"</div>"
			+"<div class='start'>Salida</div>"
			+"<div class='end'>Llegada</div>"
			+ "</li>"

		var moneda = "MXN"
		$.each(json, function(k, v) {
			html += "<li class='result'><div class='pricing'><span>" + moneda + " </span>"
			+ "<strong>" + v.costoviaje + "</strong></div>" 
			+ "<div class='class-details'>"
			+ "<strong> Turista </strong>"
			+ "<span> Pocos asientos disponibles </span>"
			+ "</div>"
			+ "<div class='departure-on'>"
			+ "<strong>" + "5n horas " + "</strong></div>"
			+ "<div class='duration'>"
			+ "<strong>" + v.tiempo + "</strong>"
			+"</div>"
			+"<div class='start'>11:00</div>"
			+"<div class='end'>18:45</div>"
			+ "</li>";
		});

		return html += "</ul>";
	}
};

$(function(){
	$("#search").on("click", function(e){
		flySearch.init();
		flySearch.search();
	});

	$("#back-2-search").on("click", function(e){
		$("#flys").hide("slow");
		$("#actions").show();
	});
});