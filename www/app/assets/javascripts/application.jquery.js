jQuery(document).ready(function() {
	
	/*
	jQuery(".show_debug[rel]").overlay({
		left: 10,
		top: 10
	});
	*/
	
	/* jQuery(".account-links, .site-links").shade(); */
	
	jQuery(".portlet-container").sortable({
		connectWith: ".portlet-container",
		items: ".portlet:not(.fixed)",
		cursorAt: { cursor:"move", top:10, left:50 },
		handle: ".portlet-header",
		dropOnEmpty: true,
		distance: 15,
		revert: true,
		stop: function(event, ui) {
			id = jQuery(ui.item).attr("id");
			container = jQuery(ui.item).parent().attr("id");
			order = jQuery(ui.item).index();
			url = "/users/" + jQuery("#user_id").attr("value") + "/widget?id=" + id + "&container=" + container + "&order=" + order;
			//alert(url);
			jQuery.ajax({ url: url, type: "PUT" });
		}
	});
	
	/*
	var scrollingElement = jQuery("#side_left .portlet.categories");
	jQuery(window).scroll(function() {
		if (scrollingElement.offset().top - jQuery(window).scrollTop() < 0) {
			scrollingElement.stop().animate({"marginTop": (jQuery(window).scrollTop()) + "px"}, "fast" );
		}
	});
	*/
	
	jQuery(".marquee, .portlet").prepend("<div class='opaque radius-10'></div>").find(".portlet-header").addClass("radius-10-top");
	
	jQuery("#header").mouseenter(function() {
		jQuery(this).find(".updateaddress .form").stop(true, false).animate({"marginTop":55}, 500);
	});
	jQuery("#header").mouseleave(function() {
		jQuery(this).find(".updateaddress .form").stop(true, false).animate({"marginTop":0}, 500);
	});
	
	jQuery(".portlet:not(.fixed)").find(".portlet-header").prepend("<span class='toggle'>-</span>");
	jQuery(".portlet-header .toggle").button()
		//.find(".ui-button-text").addClass("rotate-180").end()
		.toggle(
			function() {
				//jQuery(this).find(".ui-button-text").removeClass("rotate-180").parents(".portlet-header:first").siblings(".portlet-content").slideUp();
				jQuery(this).find(".ui-button-text").html("+").parents(".portlet-header:first").siblings(".portlet-content").slideUp();
			},
			function() {
				//jQuery(this).find(".ui-button-text").addClass("rotate-180").parents(".portlet-header:first").siblings(".portlet-content").slideDown();
				jQuery(this).find(".ui-button-text").html("-").parents(".portlet-header:first").siblings(".portlet-content").slideDown();
			}
		);
	
	jQuery("input,select,textarea").addClass("ui-corner-all");
	
	//jQuery(".portlet-container").disableSelection();
	
	// add .first and .last classes to lists of items
	/*
	jQuery(".portlet-container").find(".portlet:first").addClass("first");
	jQuery(".portlet-container").find(".portlet:last").addClass("last");
	jQuery("ul").find("li:first").addClass("first");
	jQuery("ul").find("li:last").addClass("last");
	jQuery("form").find(".field:first").addClass("first");
	jQuery("form").find(".field:last").addClass("last");
	*/
	
	/*jQuery(".portlet-container .portlet-header h3").addClass("inset-1");*/
	jQuery("input[type='submit'], .make-button").button();
	/*jQuery("input[type='text'], input[type='password'], textarea").addClass("radius-10");*/
	
	// show/hide deal content
	/*
	jQuery("#deals > li").hover(
		function() {
			jQuery(this).children(".highlights").stop(true, true).fadeIn(500);
		},
		function() {
			jQuery(this).children(".highlights").stop(true, true).fadeOut(500);
		}
	).mousemove(function(e){
		scroll_offset = jQuery(window).scrollTop();
		jQuery(this).children(".highlights").css('left', e.clientX + 50).css('top', scroll_offset + e.clientY - 50);
	});
	
	jQuery("#deals").find(".excerpt").each(function(index) {
		//alert(jQuery(this).height());
	});
	*/
	
	// show/hide excerpts
	/*
	jQuery("#deals").find(".excerpt").excerpt({
		lines: "5",
		showtext: "Read More..."
	});
	*/
	
	jQuery("#deals > li").addClass("radius-2");
	//jQuery("#deals .highlights").addClass("radius-10 shadow-4");
	jQuery("#deals .pitch a").attr("target", "_blank");
	
	//alert(jQuery(window).scrollTop());
	//alert(jQuery("#side_left .portlet.categories").offset().top);
	
});

jQuery.fn.noScroll = function() {
	var so = jQuery(this);
    var o = so.offset().top;
    jQuery(window).scroll(function() {
		var p = jQuery(window).scrollTop();
		var s = (p+52)>o;
		//so.css("position", (s) ? "fixed" : "relative").css("top", (s) ? t : "");
		if (s) { so.addClass("static"); } else { so.removeClass("static"); }
	});
};

jQuery.fn.shade = function(params) {
	
	this.each(function() {
		var e = jQuery(this);
		var e_width = e.outerWidth();
		var e_height = e.outerHeight();
		
		e.prepend('<div class="shade-background"></div>');
		bg = e.children(".shade-background");
		
		bg.width(e_width);
		bg.height(e_height);
		
	});
	
};

jQuery.fn.excerpt = function(params) {
	
	this.each(function() {
		//alert(jQuery(this).height());
		
	    var excerpt = jQuery(this);
	    
	    var lines = 6;
	    var showtext = "Show";
	    var hidetext = "Hide";
	    
	    if (typeof(params) != "undefined") {
		    lines = "lines" in params ? params["lines"] : lines;
		    showtext = "showtext" in params ? params["showtext"] : showtext;
		    hidetext = "hidetext" in params ? params["hidetext"] : hidetext;
		}
	    
	    excerpt.wrapInner('<div class="text"></div>');
	    var textdiv = excerpt.children(".text");
	    var o_height = textdiv.innerHeight(); // - ( textdiv.css("padding-bottom").replace("px", "") + textdiv.css("margin-bottom").replace("px", "") );
	    var n_height = lines * textdiv.css("line-height").replace("px", "");
	    
	    textdiv.css("height", n_height);
	    
	    /*
	    excerpt.append('<div class="showtext">' + showtext + '</div>');
	    excerpt.children(".showtext").click(function() {
	    	e = jQuery(this);
	    	
	    	if (e.hasClass("expanded")) {
	    		e.removeClass("expanded").text(showtext).siblings(".text").animate( {"height": n_height + "px"}, 1000);
	    	} else {
		    	e.addClass("expanded").text(hidetext).siblings(".text").animate( {"height": o_height + "px"}, 1000);
		    }
	    });
	    */
	});
    
};