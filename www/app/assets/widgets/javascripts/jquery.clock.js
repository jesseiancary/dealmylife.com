jQuery(document).ready(function(){
    
    var aClock = jQuery('#analog-clock');
    var clockWidthHeight = aClock.width();//width and height of the clock
    
    function startClock(){
        
        aClock.css({"height":clockWidthHeight +"px"});//sets the height if .js is enabled. If not, height = 0;
        aClock.fadeIn();//fade it in
        
        //call rotatehands function
        setInterval(function(){
        
            rotateHands();
            
        }, 200);//1000 = 1 second
            
        rotateHands();//make sure they start in the right position
        
    }
        
    function rotateHands(){
        
        //get current time/date from local computer
        var now = new Date();
        
        //set the second hand
        var secondAngle = 360/60 * now.getSeconds();//turn the time into angle
        jQuery('#secondHand').rotate(secondAngle, 'abs');//set the hand angle
        jQuery('#secondHand').css( { "left": (clockWidthHeight - jQuery('#secondHand').width())/2 + "px", "top":(clockWidthHeight - jQuery('#secondHand').height())/2 + "px" });//set x and y pos

        //set the minute hand
        var minuteAngle = 360/60 * now.getMinutes();//turn the time into angle
        jQuery('#minuteHand').rotate(minuteAngle, 'abs');//set the hand angle
        jQuery('#minuteHand').css( { "left": (clockWidthHeight - jQuery('#minuteHand').width())/2 + "px", "top":(clockWidthHeight - jQuery('#minuteHand').height())/2 + "px" });//set x and y pos
        
        //set the hour hand
        var hourAngle = 360/12 * now.getHours();//turn the time into angle
        jQuery('#hourHand').rotate((hourAngle + minuteAngle/12)%360, 'abs');//set the hand angle
        jQuery('#hourHand').css( { "left": (clockWidthHeight - jQuery('#hourHand').width())/2 + "px", "top":(clockWidthHeight - jQuery('#hourHand').height())/2 + "px" });//set x and y pos

    };
    
    startClock();
    
    
});