$(document).ready(function() {

    // Hide GNU-cat
    $('#loading').hide();
    
    // jQuery cycle plugin usage for screenshot slideshow
    $('.slideshow').cycle({
        fx:     'fade',
        speed: 1000,
        timeout: 6000,
    });

    // Show GNU-cat when the submit button is pressed
    $('input#submit').click(function() {
        $('#loading').show();
    });
});
