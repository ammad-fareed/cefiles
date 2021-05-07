jQuery(document).ready(function($){

    // =========== navigation animation ============//
    jQuery(".navi-icon").click(function () {
        jQuery(this).toggleClass('open');
        jQuery(".navigation-holder").slideToggle();
    });
    jQuery("ul.navigation li a").click(function () {
        jQuery(".navi-icon").removeClass("open");
        if(jQuery(window).width() < 1000){
            jQuery(".navigation-holder").slideUp();
        }
    });



});
