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
		$('html, body').css('cursor', 'none');
		slideshowUpdate();
		startSpinner();
		setInterval(slideshowUpdate, 1000);
	}

});



// Start the loading spinner. Used when the page first loads
// and when slideshow is switched.
function startSpinner() {
	// find any current images, get rid of them.
	$("img").not("#spinner").fadeOut(500, function() {
		$("img").not("#spinner").remove();
	});
	// make the spinner.
	if ( $("#spinner").length ) {
		// spinner already exists. make sure it's in the right spot and fade it in.
		windowWidth = $(window).width();
		windowHeight = $(window).height();

		$("#spinner").css({
			"left": (windowWidth - 75) / 2,
			"top": (windowHeight - 75) / 2,
		});
		$("#spinner").fadeIn(2000);
	}	else {
		makeSpinner();
	}
	
}

// Make the spinner.
function makeSpinner() {
	// make the element.
	var spinner = $("<img />", {id: "spinner", src: "../images/ajax_loader_vector.gif", width: "75", height: "75"});
	// spinner.css('opacity', '0.0');
	spinner.css({
		"opacity": '0',
		"z-index": '2',
	});

	windowWidth = $(window).width();
	windowHeight = $(window).height();

	spinner.css({
		"left": (windowWidth - 75) / 2,
		"top": (windowHeight - 75) / 2,
	});

	$("#slideshow div:first").append(spinner);
	// fade it in.
	$(spinner).animate({
		opacity: 1.0},
		2000, function() {
		spinner.css('z-index', '0');
	});

}






// What should I be displaying on the slideshow page?
function slideshowUpdate() {

	currentSeed = $("#current-seed p:first").text();

	$.getJSON('update_slideshow', { current_seed: currentSeed }, function(json, textStatus) {

		if ( json["update"] == "false" ) {
			// do nothing.
		}	else {
			
			startSpinner();
			startRotator(json);
		}
		

	});
}

// necessary to be able to stop the current slideshow and start a new one.
// Otherwise the interval goes out of scope and gets lost.
var slideshowInterval = 0;

function startRotator(jsonObj) {
	clearInterval(slideshowInterval);

	$("#current-seed p:first").text(jsonObj["seed"]);
	

	whichImage = 0;
	rotateImage(jsonObj, whichImage);
	whichImage++;

	slideshowInterval = setInterval(function() {

		if ( jsonObj.hasOwnProperty(whichImage) ) {
			rotateImage(jsonObj, whichImage);
			whichImage++;
		}	else {
			whichImage = 0;
			rotateImage(jsonObj, whichImage);
			whichImage++;
		}
		
	}, 15000); // Time per image.
}



// This rotates the image at imageIndex into the slideshow div, then 
// removes the current one from the DOM.
function rotateImage(imageList, imageIndex) {
	
	// where the image is displayed.
	slideshowDiv = $("#slideshow div:first");

	// This is the placeholder div for each newly created image:
	placeholderDiv = $("#placeholder");

	// get the current image if it exists.
	currentImage = $("#slideshow div img").not("#spinner");
	// send it to the back.
	currentImage.css('z-index', '0');

	// load the image at index imageIndex into the next-image div.
	var nextImage = $("<img />", { src: imageList[imageIndex]["url"], "css" : {"opacity" : "0"} });

	// Once the image is loaded, do some schmaculating about how big it should be and where to put it.
	// There should be a 15px space between the image and all sides of the window.

	// Get window height, width, and orientation(portrait|landscape|square).
	windowWidth = $(window).width();
	windowHeight = $(window).height();

	// when nextImage has loaded, we can get it's height and width, then go from there.
	nextImage.load(function() {
		$(this).appendTo(placeholderDiv);
		// get the natural dimensions of the image.
		var imgWidth = $(this).get(0).naturalWidth;
		var imgHeight = $(this).get(0).naturalHeight;

		// get the maximum values the image can be displayed at.
		// There should be a 15px border on each side. That means the max = total - 30.
		var maxWidth = windowWidth - 30;
		var maxHeight = windowHeight - 30;

		// get the difference between the natural dimensions of the image and their max values.
		var widthDifferece = maxWidth - imgWidth;
		var heightDifference = maxHeight - imgHeight;

		formatImage(nextImage, maxWidth, maxHeight, imgWidth, imgHeight, windowWidth, windowHeight);

		slideshowDiv.append(nextImage);

		// $("#spinner").fadeOut(1);

		if ( $("#spinner").css('display') == "none" ) {
			// No spinner to deal with. animate the images.
			currentImage.animate({
				"opacity": "0"},
				2000, function() {
				currentImage.remove();
			});

			nextImage.animate({
				opacity: 1},
				2000, function() {
					nextImage.css('z-index', '0');
			});


			
		}	else {
			// fade out the spinner, animate images with a callback.
			$("#spinner").fadeOut(300, function() {
				slideshowDiv.append(nextImage);

				nextImage.animate({
					opacity: 1},
					2000, function() {
						nextImage.css('z-index', '0');
				});


				currentImage.animate({
					"opacity": "0"},
					2000, function() {
					currentImage.remove();
				});
					
			});

		}



		// currentImage.animate({opacity: 0}, 2000);



	});  //end of load function.

}


// Size the image correctly for insertion into the slideshow.
function formatImage(image, maxWidth, maxHeight, imgWidth, imgHeight, windowWidth, windowHeight) {



	var percentChange = maxWidth / imgWidth;

	if ( (imgHeight * percentChange) > maxHeight ) {
		// width change won't bring height within tolerance. resize height.
		percentChange = maxHeight / imgHeight;
		imgHeight = maxHeight; //set imgHeight to max allowable.
		imgWidth = imgWidth * percentChange; // set width to the same percentage change.

		// Set image height & width.
		image.attr({
			"height": imgHeight,
			"width": imgWidth,
		});

		// Now calculate the CSS positioning.
		leftValue = (windowWidth - imgWidth) / 2;
		image.css({
			"top": "15px",
			"left": leftValue,
		});
		
		
	}	else {
		// width change will bring height within tolerance. resize width.
		imgWidth = maxWidth; //set imgWidth to max allowable.
		imgHeight = imgHeight * percentChange; // set width to the same percentage change.
		// Set image height & width.
		image.attr({
			"height": imgHeight,
			"width": imgWidth,
		});

		// Now calculate the CSS positioning.
		var topValue = (windowHeight - imgHeight) / 2;
		image.css({
			"top": topValue,
			"left": "15px",
		});

	}

}



