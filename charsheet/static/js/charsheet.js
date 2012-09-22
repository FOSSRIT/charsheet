$(document).ready(function() {

    // Hide flashed messages after a moment
    setTimeout(function() {
        $('.alert').fadeOut(2000);
    }, 2000);
    
    // Hide 20 of the 25 events displayed by default
    $("#recent-activity li").slice(5).hide();

    // Handle "more" and "less" buttons
    var showing = 5; // number of items showing
    
    $(".less-activity").on("click", function() {
        if (showing <= 5) return false;
        
        // Hide 5 more items
        $("#recent-activity li").slice(showing-5, showing).hide();
        showing = showing - 5;
        return false; // don't move to the top of the page
    });

    $(".more-activity").on("click", function() {
        if (showing >= 25) return false;

        // Show 5 more items
        $("#recent-activity li").slice(showing, showing+5).show();
        showing = showing + 5;
        return false; // don't move to the top of the page
    });

    // jQuery tooltip plugin stuff
    $('.tooltip').tooltip({
        track: true,
        delay: 250,
        showURL: false,
        showBody: " - ",
        extraClass: "tooltip-stat",
        fixPNG: true,
        opacity: 0.95,
        fade: 250,
        right: 60
    });
});
