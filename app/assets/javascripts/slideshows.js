var justHidden = false; // Used for mouse hide function. Needs to be declared before document.ready

var updateInterval  // Interval used for polling the server for updates to the slideshow.

$(document).ready(function() {

	// ------------ JS For the Channel Changer ----------------------------


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


// FLEX TORPEDO
// install some divs for torpedo grid.
	$(".torpedowrap img" ).each(function() {
		var torpedosource = $(this).prop('src');
		$(this).parent().css("background-image", 'url("' + torpedosource + '")');
	});




	// ------------ JS For the Slideshow ----------------------------

	if ($("#slideshow").length) {
		// Hide the mouse if it stops moving.
		var navHide;
		
		setTimeout(hide, 1500);

		$(document).mousemove(function() {
			if (!justHidden) {
				justHidden = false;
				// console.log('move');
				clearTimeout(navHide);
				$('html').css({cursor: 'default'});
				$("#back-button").fadeIn();
				$(".attribution-current").slideDown(100);
				navHide = setTimeout(hide, 1500);
			}
		});

		slideshowUpdate();
		// startSpinner();
		// setTimeout(function() {
		// 	updateInterval = setInterval(slideshowUpdate, 1000);
		// 	console.log("Starting update interval...");
		// }, 7000);
	}

});  // end document.ready


// mouse hide function.
function hide() {
    $('html').css({cursor: 'none'});
    $("#back-button").fadeOut();
    $(".attribution-current").slideUp(100);
    justHidden = true;
    setTimeout(function() {
        justHidden = false;
    }, 500);
}

// Start the loading spinner. Used when the page first loads
// and when slideshow is switched.
function startSpinner() {
	// find any current images, get rid of them.
	$("img").not("#spinner, #back-button").fadeOut(500, function() {
		$("img").not("#spinner, #back-button").remove();
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



var updated = false; // update the slideshow if it's false. Set it to true while updating, then back to false.
// What should I be displaying on the slideshow page?
function slideshowUpdate() {

	currentSeed = $("#current-seed p:first").text();

	$.getJSON('update_slideshow', { current_seed: currentSeed }, function(json, textStatus) {

		if ( json["update"] == "false" ) {
			// do nothing.
		}	else {

			if ( updated === false ) {
				updated = true;
				clearInterval(updateInterval);
				startSpinner();
				startRotator(json);
				setTimeout(function() {
					updated = false;
				}, 1000);
			}

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
		
	}, 14000); // Time per image.

	setTimeout(function() {
		updateInterval = setInterval(slideshowUpdate, 1000);
	}, 7000);
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

	// get the title and artist info for the attribution.
	var imageTitle = imageList[imageIndex]["title"];
	var imageAuthor = imageList[imageIndex]["author"];
	var deviationPage = imageList[imageIndex]["link"];
	var attributionText = "\"" + imageTitle + "\" by " + imageAuthor;
	// Once the image is loaded, do some schmaculating about how big it should be and where to put it.
	// There should be a 15px space between the image and all sides of the window.

	// Get window height, width.
	windowWidth = $(window).width();
	windowHeight = $(window).height();

	// when nextImage has loaded, we can get it's height and width, then go from there.
	nextImage.load(function() {

		// get the current attribution p so we can fade it out and replace it with the next one.
		var currentAttribution = $(".attribution-current");

		// create a new attribution p with the correct text.
		var nextAttribution = $("<p />", { "class" : "attribution-next", "css" : {"display" : "none"} } );
		var link = $("<a />", { "href" : deviationPage, "target" : "_blank" } );
		$(nextAttribution).append(link);
		link.text(attributionText);

		// append this new image to the placeholder.
		$(this).appendTo(placeholderDiv);

		// append the new attribution div to the .credited div.
		$(".credited").append(nextAttribution);

		// get the natural dimensions of the image.
		var imgWidth = $(this).get(0).naturalWidth;
		var imgHeight = $(this).get(0).naturalHeight;

		// get the maximum values the image can be displayed at.
		// There should be a 15px border on each side. That means the max = total - 30.
		var maxWidth = windowWidth - 30;
		var maxHeight = windowHeight - 30;

		formatImage(nextImage, maxWidth, maxHeight, imgWidth, imgHeight, windowWidth, windowHeight);

		slideshowDiv.append(nextImage);

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

			// fade out the current attribution if it's visible
			if ( $(".attribution-current").css("display") === "block" ) {
				
				currentAttribution.fadeOut(2000);
				// fade in the new one, then delete the old one and set the id in the callback.
				nextAttribution.fadeIn(2000, function() {
					currentAttribution.remove();
					// $(this).attr('id', 'attribution');
					$(this).addClass('attribution-current').removeClass('attribution-next');
				});

			}	else {
				// just swap 'em out if they're not visible.
				currentAttribution.remove();
				nextAttribution.addClass('attribution-current').removeClass('attribution-next');
			}

			
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

				// fade out the current attribution if it's visible
				if ( $(".attribution-current").css("display") === "block" ) {
					
					currentAttribution.fadeOut(2000);
					// fade in the new one, then delete the old one and set the id in the callback.
					nextAttribution.fadeIn(2000, function() {
						currentAttribution.remove();
						$(this).addClass('attribution-current').removeClass('attribution-next');
					});

				}	else {
					// just swap 'em out if they're not visible.
					currentAttribution.remove();
					nextAttribution.addClass('attribution-current').removeClass('attribution-next');
				}

			});

		}



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
		imgHeight = imgHeight * percentChange; // set height to the same percentage change.
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



