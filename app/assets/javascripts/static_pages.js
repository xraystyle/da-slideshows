
 

 // Set up all the attribution links for the landing page slideshow.
var bobafett = $('<a />', {
    href : "http://uncannyknack.deviantart.com/art/Boba-Fett-468829138",
    text : "Boba Fett, by uncannyknack",
    target: "_blank"
});

var scifi = $('<a />', {
    href : "http://tituslunter.deviantart.com/art/View-2142-340197340",
    text : "View 2142, by TitusLunter",
    target: "_blank"
});

var nordiclake = $('<a />', {
    href : "http://roblfc1892.deviantart.com/art/hallstatt-III-513046607",
    text : "hallstatt III, by roblfc1892",
    target: "_blank"
});

var oldman = $('<a />', {
    href : "http://xraystyle.deviantart.com/art/Coffee-And-A-Newspaper-252903156",
    text : "Coffe and a Newspapaer, by xraystyle",
    target: "_blank"
});

var buick = $('<a />', {
    href : "http://americanmuscle.deviantart.com/art/Angry-Buick-428736321",
    text : "Angry Buick, by AmericanMuscle",
    target: "_blank"
});

var cafegirl = $('<a />', {
    href : "http://jay-jusuf.deviantart.com/art/19th-Avenue-Cafe-382301194",
    text : "19th Avenue Cafe, by Jay-Jusuf",
    target: "_blank"
});

var starscape = $('<a />', {
    href : "http://sa-nick86.deviantart.com/art/mind-s-eye-518103061",
    text : "mind's eye, by sa-nick86",
    target: "_blank"
});


var sunsetriver = $('<a />', {
    href : "http://daroz.deviantart.com/art/Dusk-river-519343438",
    text : "Dusk river, by daRoz",
    target: "_blank"
});

var headphones = $('<a />', {
    href : "http://yuumei.deviantart.com/art/Color-327928911 Girl With Headphones",
    text : "Color, by yuumei",
    target: "_blank"
});

var chunli = $('<a />', {
    href : "http://artgerm.deviantart.com/art/Chunli-Style-92438300",
    text : "Chun Li Style, by Artgerm",
    target: "_blank"
});

var fractal = $('<a />', {
    href : "http://boxtail.deviantart.com/art/Dreaming-514578979 Fractal",
    text : "Dreaming, by BoxTail",
    target: "_blank"
});

// End slideshow links.



$(document).ready(function() {
    

    if ( $('.hero-unit').length ) {
        

        var h = $('.hidden>p'); //get the filenames of the slideshow images.
        
        var filenames = $.map(h, function(item) {  //map just the
            return item.textContent;
        });

        filenames = shuffle(filenames); // Randomize the slideshow images.
        

    } // End if .hero-unit statement.



});   // End document.ready




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