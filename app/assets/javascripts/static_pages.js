

$(document).ready(function() {

// ----------------------------- static_pages/home javascript ---------------------------
    if ( $('.hero-unit').length ) {

         // Set up all the slideshow files for the landing page slideshow.
        var bobafett = {
            "link" : $('<a />', {
                href : "http://uncannyknack.deviantart.com/art/Boba-Fett-468829138",
                text : "Boba Fett, by uncannyknack",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/bobafett.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var scifi = {
            "link" : $('<a />', {
                href : "http://tituslunter.deviantart.com/art/View-2142-340197340",
                text : "View 2142, by TitusLunter",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/scifi.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var nordiclake = {
            "link" : $('<a />', {
                href : "http://roblfc1892.deviantart.com/art/hallstatt-III-513046607",
                text : "hallstatt III, by roblfc1892",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/nordiclake.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var oldman = {
            "link" : $('<a />', {
                href : "http://xraystyle.deviantart.com/art/Coffee-And-A-Newspaper-252903156",
                text : "Coffee and a Newspapaer, by xraystyle",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/oldman.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var buick = {
            "link" : $('<a />', {
                href : "http://americanmuscle.deviantart.com/art/Angry-Buick-428736321",
                text : "Angry Buick, by AmericanMuscle",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/buick.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var cafegirl = {
            "link" : $('<a />', {
                href : "http://jay-jusuf.deviantart.com/art/19th-Avenue-Cafe-382301194",
                text : "19th Avenue Cafe, by Jay-Jusuf",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/cafegirl.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var starscape = {
            "link" : $('<a />', {
                href : "http://sa-nick86.deviantart.com/art/mind-s-eye-518103061",
                text : "mind's eye, by sa-nick86",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/starscape.png",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};


        var sunsetriver = {
            "link" : $('<a />', {
                href : "http://daroz.deviantart.com/art/Dusk-river-519343438",
                text : "Dusk river, by daRoz",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/sunsetriver.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var headphones = {
            "link" : $('<a />', {
                href : "http://yuumei.deviantart.com/art/Color-327928911 Girl With Headphones",
                text : "Color, by yuumei",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/headphones.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var chunli = {
            "link" : $('<a />', {
                href : "http://artgerm.deviantart.com/art/Chunli-Style-92438300",
                text : "Chun Li Style, by Artgerm",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/chunli.jpg",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};

        var fractal = {
            "link" : $('<a />', {
                href : "http://boxtail.deviantart.com/art/Dreaming-514578979 Fractal",
                text : "Dreaming, by BoxTail",
                target: "_blank",
                class : "next",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "assets/fractal.png",
                class : "next img-responsive hero-image",
                style : "display : none;" 
            })};


        var slideshowFiles = [ bobafett, scifi, nordiclake, oldman, buick, cafegirl, starscape, sunsetriver, headphones, chunli, fractal ];

        // End slideshow links.

        shuffle(slideshowFiles);

        $('.hero-unit').prepend(slideshowFiles[0]["image"]);
        $('.attribution').append(slideshowFiles[0]["link"]);
        $('.hero-image').fadeIn(1500);
        $('.attribution').fadeIn(1500);
        $('.attribution a').fadeIn(1500, function() {
           $('.next').addClass('current').removeClass('next');
        });


        startSlideshow(slideshowFiles);

        $(window).scroll(function() {
            var height = $(window).scrollTop();

            if ( height > 50 ) {
                $('.instructions').fadeIn(1500);
            }

        });

        
    } 
// ----------------------------- End static_pages/home javascript ---------------------------


});   // End document.ready


// --------------- Functions -------------------------------

function shuffle(array) {
    var counter = array.length, temp, index;

    while ( counter > 0 ) {
        index = Math.floor(Math.random() * counter);

        counter--;
        temp = array[counter];
        array[counter] = array[index];
        array[index] = temp;

    }

    return array;

}


// -------Do the slideshow thing because reasons.-------------------------
function startSlideshow(files) {
    
    var index = 1

    setInterval(function() {
       
        if ( files[index] !== undefined ) {
            rotateImage(files, index);
            index++;
        }   else {
            index = 0;
            rotateImage(files, index);
            index++;
        }

    }, 6500);

}


function rotateImage(array, i) {

    $('.hero-unit').prepend(array[i]["image"]);

    $('.attribution').append(array[i]["link"]);
    $('.attribution').fadeOut('1500');
    $('.current').fadeOut(1500, function() {
        
        $(this).addClass('next').removeClass('current');

        $(this).remove();

        $('.next').fadeIn(1500, function() {
            $(this).addClass('current').removeClass('next');
        });

        $('.attribution').fadeIn(1500);

    });

} 