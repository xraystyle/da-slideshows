$(document).ready(function() {
	
	// tell the server to change th slideshow image.
	$(".channel, .channel-selected").click(function() {
		old_selected = $(".channel-selected");
		uuid = $(this).find("img:first").data('uuid');

		$(this).addClass('channel-selected');

		console.log(uuid);
		old_selected.addClass('channel').removeClass('channel-selected');

		$.post('update_slideshow', { uuid: uuid }, function(data, textStatus, xhr) {
			console.log(data);
		});

	});

	if ($("#slideshow").length) {
		setInterval(updateMe, 1000);
	}


	// What should I be displaying on the slideshow page?
	function updateMe() {
		$.getJSON('update_slideshow', function(json, textStatus) {
				// img = $("#slideshow img:first");

				// if (img.attr('src') !== json["url"]) {
				// 	img.attr('src', json["url"]);
				// }

				// background = $("#slideshow").css('background');

				// console.log(background)

				// if (background !== json["url"]) {
				$("#slideshow").css('background', 'url("' + json["url"] + '") no-repeat center center');					
				// }

				// $("#slideshow img:first")
				console.log(json["url"])
		});
	}


});