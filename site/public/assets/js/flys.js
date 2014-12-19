/* search for FLY */
var flySearch = flySearch || {


	/* parameters for the query */
	parameters : {
		seats : 1,
		// 0 for turist, 1 for first class
		seatsClass : 0,
		originIATA : null,
		destinyIATA : null,
		departureDate : null,
		returnDate : null,
	},

	apiURI : "/viajes",
	method: "get",

	/* request for a json response to the server */
	search: function (parameters) {

		var $extra = $("#actions");
		var	$trigger = $("#search");
		var $container = $("#flys");


		$.ajax({
			url: flySearch.apiURI,
			type: "GET",
			dataType: "json",
			beforeSend: function() {
				$extra.hide("slow");
				$container.show("slow")
			},
			success: function(json){
				var html  = flySearch._showResults(json);
				$container.html(html);
			},
			error: function(dato){

			}
		});
	},

	/* render the json data to the container */
	_showResults : function (json) {
		console.log(json);
		var html = "<ul id='flights-results'>";
		var moneda = "MXN"
		$.each(json, function(k, v) {
			html += "<li><div class='pricing'><strong>" + v.costoviaje 
			+ "</strong><span>" + moneda + " </span></div>" 
			+ "<div class='class-details'>"
			+ "<strong> Turista </strong>"
			+ "<span> Pocos asientos disponibles </span>"
			+ "</div>"
			+ "<div class='departure-on'>"
			+ "<strong>" + "despega en 5n horas " + "</strong>"
			+ "<div class='duration'>"
			+ "<strong>" + v.tiempo + "</strong>"
			+"</div>"
			+ "</li>"
		});

		return html += "</ul>";
	}
};

$(function(){
	$("#search").on("click", function(e){
		flySearch.search();
	});
});