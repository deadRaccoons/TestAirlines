var calendar =  calendar || {
	/* the selector to show the calendar*/
	containerId : "calendar-js",
	date : {
		day : 1,
		month : 5,
		year : 2014,
		currentFormat : "MX",
		avaibleFormats : ["MX"],
		daysPerMonth : [31,28,31,30,31,30,31,31,30,31,30,31],
		months : [["Enero", "Febrero", "Marzo", "Abril",
					"Mayo", "Junio", "Julio", "Agosto", 
					"Septiembre","Octubre", "Noviembre", "Diciembre"]],
							
	},

	fillCalendar : function (year) {
		var isLeap = (year % 4 == 0 && year % 100 != 0 || year % 400 == 0);
		this.date.daysPerMonth[1] = (isLeap) ? 29 : 28;
		var days = this.date.daysPerMonth;
		var htmlString = "<div class='year'>"
		$.each(this.date.months[0], function (index, value) {
			htmlString += calendar.fillMonth (year, index, days[index], index+1, value);
		});

		htmlString += "</div>";
		return htmlString;

	},

	fillMonth : function(year, month, days, id, title) {
		
		var htmlString = "<div class='month' id='" + id + "'>";
		var date =  new Date(year, month, 1);
		date = date.getDay();
		htmlString += "<strong>"+ title + "</strong>";
		for (var i = 1; i <= days; i++) {
			var z =  new Date(year, month, i);
			htmlString += "<a href='#' data-date=" + (i + "/" + month + "/" + year) + " class='day_" + z.getDay() +" week_" + Math.floor((date + i -1)/7)+"'>" + i + "</a>";
		}
		htmlString += "</div>";
		return htmlString;
	}

};	
