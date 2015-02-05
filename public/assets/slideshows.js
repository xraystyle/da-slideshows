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

	windowWidth = $(window).width();
	windowHeight = $(window).height();

	spinner.css({
		"left": (windowWidth - 75) / 2,
		"top": (windowHeight - 75) / 2,
	});

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

			if ( typeof slideshowInterval === 'undefined' ) {
				// no slideshow interval yet. Don't worry about it.
			}	else {
				// clear the interval.
				window.clearInterval(slideshowInterval);
			}
			// start with the first image.
			whichImage = 0;
			var slideshowInterval = setInterval(function() {
				
				if ( json.hasOwnProperty(whichImage) ) {
					rotateImage(json, whichImage);
					whichImage++;
				}	else {
					whichImage = 0;
					rotateImage(json, whichImage);
					whichImage++;
				}

			}, 5000);
		}
		

	});
}


// This rotates the image at imageIndex into the slideshow div, then 
// removes the current one from the DOM.
function rotateImage(imageList, imageIndex) {
	// where the image is displayed.
	slideshowDiv = $("#slideshow div:first");

	// This is the placeholder div for each newly created image:
	placeholderDiv = $("#placeholder");

	// get the current image if it exists.
	currentImage = $("#slideshow div img:first");
	// send it to the back.
	currentImage.css('z-index', '0');

	// load the image at index imageIndex into the next-image div.
	var nextImage = $("<img />", { src: imageList[imageIndex]["url"], "css" : {"opacity" : "0"} }).appendTo(placeholderDiv);

	// Once the image is loaded, do some schmaculating about how big it should be and where to put it.
	// There should be a 15px space between the image and all sides of the window.

	// Get window height, width, and orientation(portrait|landscape|square).
	windowWidth = $(window).width();
	windowHeight = $(window).height();

	if ( windowWidth > windowHeight ) {
		windowAspect = "landscape";
	}	else if ( windowHeight > windowWidth ) {
		windowAspect = "portrait";
	}	else {
		// honestly, if your window is an exact square you're in the smallest
		// of conceivable edge cases and I don't even want to deal with you.
		windowAspect = "square";
	}

	nextImageAspect = imageList[imageIndex]["aspect"];

	// when nextImage has loaded, we can get it's height and width, then go from there.
	nextImage.load(function() {
		var imgWidth = $(this).width();
		var imgHeight = $(this).height();

		// portrait window case.
		if ( windowAspect == "portrait" ) {
			// portrait image in portrait window case.
			if ( nextImageAspect == "portrait" ) {
				var maxHeight = windowHeight - 30;
				var percentChange = imgHeight / maxHeight; // % change between current and max.
				imgHeight = maxHeight; //set imgHeight to max allowable.
				imgWidth = imgWidth * percentChange; // set width to the same percentage change.

				nextImage.attr({
					"height": imgHeight,
					"width": imgWidth,
				});

				// now calculate the css positioning.
				nextImage.css({
					"top": "15px",
					"left": (windowWidth - imgWidth) / 2,
				});
				// landscape/square image in portrait window case.
			}else {
				var maxWidth = windowWidth - 30;
				var percentChange = imgWidth / maxWidth; // % change between current and max.
				imgWidth = maxWidth; //set imgHeight to max allowable.
				imgHeight = imgHeight * percentChange; // set width to the same percentage change.

				nextImage.attr({
					"height": imgHeight,
					"width": imgWidth,
				});

				// now calculate the css positioning.
				nextImage.css({
					"top": (windowHeight - imgHeight) / 2,
					"left": "15px",
				});
			}

		}


	});


}







// old function, not using this.
function startSlideshow(imageList) {
	console.log("I'm starting the slideshow.");
	var imageIndex = 0;
	initialSeedValue = $("#current-seed p:first").text();

	// this is where the images are displayed:
	slideshowDiv = $("#slideshow div:first");

	// This is the placeholder div for each newly created image:
	placeholderDiv = $("#placeholder")

	while ( initialSeedValue == $("#current-seed p:first").text() ) {
		console.log("In the while loop now...");

		// get the current image if it exists.
		currentImage = $("#slideshow div img:first");

		currentImage.css('z-index', '0');

		
		// if there's an image at imageIndex, use it. Otherwise set 
		// imageIndex back to 0 and continue, so we start over.
		if ( imageList.hasOwnProperty(imageIndex) ) {


			// load the image at index imageIndex into the next-image div.
			var nextImage = $("<img />", { src: imageList[imageIndex]["url"], "css" : {"opacity" : "0"} }).appendTo(placeholderDiv);

			nextImage.load(function() {
				console.log("Hit load callback...");
				var imgWidth = $(this).width();
				var imgHeight = $(this).height();
				console.log("Width: " + imgWidth + ". Height: " + imgHeight);
				windowWidth = $(window).width();
				windowHeight = $(window).height();

				leftValue = (windowWidth - imgWidth) / 2;
				topValue = (windowHeight - imgHeight) / 2;
				
				console.log("Setting top and left. Should be " + topValue + " and " + leftValue);
				nextImage.css({
					"left": leftValue,
					"top": topValue,
					"z-index": '1',
					"position": "absolute",
					"vertical-align": "middle"
				});
				
			});

			slideshowDiv.append(nextImage);


			nextImage.animate({
				opacity: 1},
				2000, function() {
					console.log("Image should have faded in.");				
					currentImage.remove();
					nextImage.css('z-index', '0');
			});

			imageIndex++;


			// break;
		}	else {
			console.log("Hit the else statement.");
			imageIndex = 0;
			continue;
		}

	}

}






















