$(document).ready(function() {

	// tell the server to change the slideshow image.
	$(".channel, .channel-selected").click(function() {
		
		if ( $(this).attr('class').match(/channel-selected/)  ) {
			// do nothing
		}	else {
			// select the new seed and send it to the server.
			old_selected = $(".channel-selected");
			uuid = $(this).find("img:first").data('uuid');

			$(this).addClass('channel-selected').removeClass('channel');

			old_selected.addClass('channel').removeClass('channel-selected');

			$.post('update_slideshow', { set_uuid: uuid }, function(data, textStatus, xhr) {
				console.log("Slideshow seed set to " + uuid);
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
	if ( $("#slideshow div img:first").length ) {
		console.log("I found an image.");
		$("#slideshow div img:first").fadeOut(1500, function() {
			$("#slideshow div img:first").remove();
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
	$("#slideshow div:first").append(spinner);
	// fade it in.
	$("#slideshow div img:first").animate({
		opacity: 1.0},
		1000, function() {
		console.log("Spinner loaded.");
	});

}








// What should I be displaying on the slideshow page?
function slideshowUpdate() {
	currentSeed = $("#current-seed p:first").text();
	// console.log("Current seed is " + currentSeed);

	$.getJSON('update_slideshow', { current_seed: currentSeed }, function(json, textStatus) {
		// console.log(json["update"])

		if ( json["update"] == "false" ) {
			// do nothing.
			console.log("No update.");
		}	else {
			console.log("Found an update.");
			// Change the text in the current-seed div to the new value.
			$("#current-seed p:first").text(json["seed"]);
			// run the startSlideshow function here, passing in the json object.
			startSlideshow(json);
		}
		

	});
}


function startSlideshow(imageList) {
	console.log("I'm starting the slideshow.");
	var imageIndex = 0;
	initialSeedValue = $("#current-seed p:first").text();

	// this is where the images are displayed:
	slideshowDiv = $("#slideshow div:first");

	while ( initialSeedValue == $("#current-seed p:first").text() ) {


		// get the current image if it exists.
		currentImage = $("#slideshow div img:first");

		// load the image at index imageIndex into the next-image div.
		nextImage = $("#next-image img:first");
		console.log("In the while loop now...");

		// if there's an image at imageIndex, use it. Otherwise set 
		// imageIndex back to 0 and continue, so we start over.
		if ( imageList.hasOwnProperty(imageIndex) ) {
			// 
			nextImage.attr('src', imageList[imageIndex]["url"]).css({
				"opacity": '0',
				"z-index": '1',
				"position": "absolute",
				"vertical-align": "middle"
			}).load(function() {
				var imgWidth = $(this).width();
				var imgHeight = $(this).height();
			});

			slideshowDiv.append(nextImage);

			windowWidth = $(window).width();
			windowHeight = $(window).height();

			leftValue = (windowWidth - imgWidth) / 2;
			topValue = (windowHeight - imgHeight) / 2;

			nextImage.css({
				left: leftValue,
				top: topValue
			});

			nextImage.animate({
				opacity: 1},
				2000, function() {
				currentImage.remove();
			});

			imageIndex++;


			break;
		}	else {
			console.log("Hit the else statement.");
			imageIndex = 0;
			continue;
		}

	}

}






















