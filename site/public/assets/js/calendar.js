var calendar =  calendar || {
	/* the selector to show the calendar*/
	containerId : "calendar-js",
	date = {
		day : 1,
		month : 5,
		year : 2014,
		currentFormat : "MX",
		avaibleFormats : ["MX"],
		months = [["Enero", "Febrero", "Marzo", "Abril",
					"Mayo", "Junio", "Julio", "Agosto", 
					"Septiembre","Octubre", "Noviembre", "Diciembre"]],
		daysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31]					
	},

	fillCalendar : function (year) {
		var isLeap = (year % 4 == 0 && year % 100 != 0 || year % 400 == 0);
		this.date.daysPerMonth[1] = (isLeap) ? 29 : 28;
		var htmlString = "<div class='year'>"
		$.each(months[0], function (index, value) {
			htmlString += fillMonth (year, month, daysPerMonth[index], index+1, value);
		});

	}

	fillMonth : function(year, month, days, id, title) {
		var z =  new Date(year, month, days);
		var htmlString = "<div class='month' id='" + id + "'>";
		for (var i = 1; i <= days; i++) {
			htmlString += "<a href='#' class='day " + z.getDay() +"'>" + i + "</a>";
		}
		htmlString += "</div>"
	}

};	
