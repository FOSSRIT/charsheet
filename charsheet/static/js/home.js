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

    // Have master account input field update all other fields
    /* THIS CODE IS BROKEN -- I will be fixing it ASAP
    $('input#charsheetform:master').keyup(function () {
        $('input#charsheetform:github').val(this.val());
        $('input#charsheetform:ohloh').val(this.val());
        $('input#charsheetform:coderwall').val(this.val());
    }); */
});
