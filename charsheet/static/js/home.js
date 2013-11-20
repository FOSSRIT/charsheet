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
        $('#loading').fadeIn(1000);
    });

    // Assign account form fields to variables
    // (was doing this to do some logic with the below keyup function
    // to make it so that a field did not react to a master form change if
    // it was altered by the user. Unfortunately, the JS cannot seem to react
    // quickly enough to handle anything but slow typing. May attempt rewrite
    // later.
    var master_field = $('input#master');
    var ohloh_field = $('input#ohloh');
    var coderwall_field = $('input#coderwall');

    // Have master account input field update all other field
    master_field.keyup(function () {
        ohloh_field.val($(this).val());
        coderwall_field.val($(this).val());
    });
});

$(window).on('unload', function() {
    // Re-hide GNU-cat when we leave.
    $('loading').hide();
});
