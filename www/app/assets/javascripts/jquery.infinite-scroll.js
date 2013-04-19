jQuery(document).ready(function() {
	
//if (getParameterByName("scroll") == "true") {
	
	var settings;
 	settings = jQuery.extend({
 		container: "#deals .deals",
 		next: "#deals .pager .next a",
 		//loading: "<%= asset_path('theme/loading.gif') %>",
 		loading: "/assets/theme/loading.gif",
 		pad: 500
	}, settings);
	
	var this_container = jQuery(settings.container);
	var more_content = jQuery(settings.next).length;
	if ( more_content ) { var next_url = jQuery(settings.next).attr("href").split("?"); }
	var scroll = true;
	
	jQuery(window).scroll(function() {
		if ( (jQuery(window).scrollTop() + settings.pad >= ( jQuery(document).height() - jQuery(window).height() )) && more_content && scroll ) {
			
			scroll = false;
			this_container.append( "<div class='loading'><img src='" + settings.loading + "' /></div>" );
			jQuery.ajax({
				type: "GET",
				url: next_url[0],
				data: next_url[1]
			}).done(function(data) {
				this_container.find(".loading").remove();
				this_container.append( jQuery(data).find(settings.container).html() );
				jQuery(".make-button").button();
				//jQuery(".products-grid").applyStyleGrid();
				more_content = jQuery(data).find(settings.next).length;
				if ( more_content ) { next_url = jQuery(data).find(settings.next).attr("href").split("?"); }
				scroll = true;
			});
		}
	});
	
//}
});