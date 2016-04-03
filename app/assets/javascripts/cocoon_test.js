(function($) {
    console.log('load cocoontest-1');
    $(document).on('click', '.test-button', function(e) {
        console.log('click test_button');
    });
})(jQuery);

$(document).on('ready', function() {
    console.log('load cocoontest-2');
    $(document).on('click', '.test-button2', function(e) {
        console.log('click test_button2');
    });
});