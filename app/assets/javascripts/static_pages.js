

$(document).ready(function() {

// ----------------------------- static_pages/home javascript ---------------------------
    if ( $('.hero-unit').length ) {

        // $('.hero-unit').css('height', ($(window).width() * .53416));

         // Set up all the slideshow files for the landing page slideshow.
        var bobafett = {
            "link" : $('<a />', {
                href : "http://uncannyknack.deviantart.com/art/Boba-Fett-468829138",
                text : "Boba Fett, by uncannyknack",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/bobafett.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var scifi = {
            "link" : $('<a />', {
                href : "http://tituslunter.deviantart.com/art/View-2142-340197340",
                text : "View 2142, by TitusLunter",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/scifi.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var nordiclake = {
            "link" : $('<a />', {
                href : "http://roblfc1892.deviantart.com/art/hallstatt-III-513046607",
                text : "hallstatt III, by roblfc1892",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/nordiclake.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var oldman = {
            "link" : $('<a />', {
                href : "http://xraystyle.deviantart.com/art/Coffee-And-A-Newspaper-252903156",
                text : "Coffe and a Newspapaer, by xraystyle",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/oldman.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var buick = {
            "link" : $('<a />', {
                href : "http://americanmuscle.deviantart.com/art/Angry-Buick-428736321",
                text : "Angry Buick, by AmericanMuscle",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/buick.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var cafegirl = {
            "link" : $('<a />', {
                href : "http://jay-jusuf.deviantart.com/art/19th-Avenue-Cafe-382301194",
                text : "19th Avenue Cafe, by Jay-Jusuf",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/cafegirl.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var starscape = {
            "link" : $('<a />', {
                href : "http://sa-nick86.deviantart.com/art/mind-s-eye-518103061",
                text : "mind's eye, by sa-nick86",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/starscape.png",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};


        var sunsetriver = {
            "link" : $('<a />', {
                href : "http://daroz.deviantart.com/art/Dusk-river-519343438",
                text : "Dusk river, by daRoz",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/sunsetriver.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var headphones = {
            "link" : $('<a />', {
                href : "http://yuumei.deviantart.com/art/Color-327928911 Girl With Headphones",
                text : "Color, by yuumei",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/headphones.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var chunli = {
            "link" : $('<a />', {
                href : "http://artgerm.deviantart.com/art/Chunli-Style-92438300",
                text : "Chun Li Style, by Artgerm",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/chunli.jpg",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};

        var fractal = {
            "link" : $('<a />', {
                href : "http://boxtail.deviantart.com/art/Dreaming-514578979 Fractal",
                text : "Dreaming, by BoxTail",
                target: "_blank",
                style : "display : none;",
                }),
            "image" : $('<img />', {
                src : "images/fractal.png",
                class : "img-responsive hero-image",
                style : "display : none;" 
            })};


        var slideshowFiles = [ bobafett, scifi, nordiclake, oldman, buick, cafegirl, starscape, sunsetriver, headphones, chunli, fractal ];

        // End slideshow links.

        shuffle(slideshowFiles);

        $('.hero-unit').prepend(slideshowFiles[0]["image"]);
        $('.attribution').append(slideshowFiles[0]["link"]);
        $('.hero-image').fadeIn(3000);
        $('.attribution a').fadeIn(3000);
        // $('.hero-unit').removeAttr('style');

        // setTimeout(function() {
        //     $('.hero-unit').prepend(slideshowFiles[0]["image"]);
        // }, 3000);



        
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