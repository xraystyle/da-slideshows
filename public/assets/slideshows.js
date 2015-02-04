$(document).ready(function() {

	// tell the server to change the slideshow image.
	$(".channel, .channel-selected").click(function() {
		
		if ( $(this).attr('class').match(/channel-selected/)  ) {
			// do nothing
		}	else {
			// select the new seed and send it to the server.
			old_selected = $(".channel-selected");
			uuid = $(this).find("img:first").data('uuid');

			$(this).addClass('channel-selected');

			console.log(uuid);
			old_selected.addClass('channel').removeClass('channel-selected');

			$.post('update_slideshow', { uuid: uuid }, function(data, textStatus, xhr) {
				console.log(data);
			});
		
		}

	});


	if ($("#slideshow").length) {
		startSpinner();
		setInterval(slideshowUpdate, 1000);
	}

});



// Start the loading spinner. Used when the page first loads
// and when slideshow is switched.
function startSpinner() {
	// if there's already an image there, fade it out and remove it.
	if ( $("#slideshow p img:first").length ) {
		console.log("I found an image.");
		$("#slideshow p img:first").fadeOut(1500, function() {
			$("#slideshow p img:first").remove();
			makeSpinner();
		});
		// If there isnt an image, just bring up the spinner.
	}	else {
		makeSpinner();
	}
	
}



// Make the spinner.
function makeSpinner() {
	// make the element.
	var spinner = $("<img />", {id: "spinner", src: "../images/ajax_loader_vector.gif", width: "75", height: "75"});
	spinner.css('opacity', '0.0');
	$("#slideshow p:first").append(spinner);
	// fade it in.
	$("#slideshow p img:first").animate({
		opacity: 1.0},
		1000, function() {
		console.log("Spinner loaded.");
	});

}








// What should I be displaying on the slideshow page?
function slideshowUpdate() {

	// get the current window height.
	// height = $(window).height();

	$.getJSON('update_slideshow', function(json, textStatus) {

	});
}





