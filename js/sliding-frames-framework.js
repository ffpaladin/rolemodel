        var MOVE_DURATION = 700;
        var CONTAINER_WIDTH;
        var LOOP = false;

        var keys = { left : 37, up : 38, right : 39, down : 40};
	
	$(document).keydown(function(e){
		if (e.keyCode==keys.left)
			slideItHorizontal(true);
		if (e.keyCode==keys.right)
			slideItHorizontal(false);
		
		//prevent scrolling
		var ar=new Array(32,33,34,35,36,37,38,39,40);
		var key = e.which;
		if($.inArray(key,ar) > -1) 
			e.preventDefault();
	});
        function init() {
            var frames = document.getElementsByClassName( 'frame' );
            CONTAINER_WIDTH =  frames.length*100;
            $("#container").css("width", CONTAINER_WIDTH+"%");
            //console.log(frames);
            for (var i = 0; i < frames.length; i++) {
                frames[i].style.width = (100/frames.length)+ "%";
            }
        }
        function slideItHorizontal(left) {
                if (this.pos == undefined) {
                    this.pos = 0;
                }
                if (!$("#container").is(':animated') ) {
                    var animate = false;
					var animateLong = false;
					//console.log(pos + " " + CONTAINER_WIDTH);
					//right, if the position can move one more bout over
                    if (!left && this.pos >= -CONTAINER_WIDTH+200) {
                        this.pos-=100;
                        animate = true;
                    }
                    else if (left && this.pos < 0) {
                        this.pos+=100;
                        animate = true;
                    }
                    if(LOOP){
    					//looping going right
                        if(!left && this.pos == -CONTAINER_WIDTH + 100){
    						this.pos = 0;
    						animate = true;
    						animateLong = true;
    					}
    					//looping going left
    					else if(left && this.pos == 0){
    						this.pos = -CONTAINER_WIDTH + 100;
    						animate = true;
    						animateLong = true;
    					}
                    }
                    if(animate){
						if(animateLong)
							duration = CONTAINER_WIDTH*MOVE_DURATION/300;
						else
							duration = MOVE_DURATION;
                        $("#container").animate({
                            left: this.pos+'%'
                            }, duration);
                    }
                }
        }