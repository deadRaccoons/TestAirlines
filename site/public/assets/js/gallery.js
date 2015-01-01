$(function(){
	console.log("function cargada")
	$("#controls_b").delegate(".circle","click", function(){
		alert("cambiar div");
	});

})