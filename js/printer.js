function printStory (story, domElement){
	for(var i = 0; i < story.length; i++){
		var variation = story[0];
		for(var j = 0; j < variation['parts'].length; j++){
			var frame = variation['parts'][j];
			var htmlToAppend = '<div class="frame">';
			htmlToAppend += '<div class="frame-content">';
			htmlToAppend += '<img class="frame-image" src="images/comics/' + frame['asset'] + '"/><br/>';
			htmlToAppend += frame['caption'] + '</div></div>';
			$(domElement).append(htmlToAppend);
			console.log(frame);
		}
		$(domElement).append('<div class="frame" style="width: 20%;"><div class="frame-content"><iframe width="100%" height="600" src="https://docs.google.com/forms/d/1bawAfxVi-oN4ytm2WbYripX0uClvj7iXyXkNCSIs-F8/viewform">Your browser does not support iframes, so you cannot view the feedback form.</iframe><br>Feedback form.</div>');
		init();
	}
}


function printStoryImpress (story, domElement){
	var j, offset;
	for(var i = 0; i < story.length; i++){
		var variation = story[0];
		for(j = 0; j < variation['parts'].length; j++){
			var frame = variation['parts'][j];
			offset = j*1024;
			console.log("offset" + offset);
			var htmlToAppend = '<div class="step" data-x="'+offset+' " data-y="0">';
			htmlToAppend += '<div class="frame-content">';
			htmlToAppend += '<img class="frame-image" src="images/comics/' + frame['asset'] + '"/><br/>';
			htmlToAppend += frame['caption'] + '</div></div>';
			//console.log(frame);
			$(domElement).append(htmlToAppend);
		}
		offset = j*1024;
		console.log(offset);
		$(domElement).append('<div class="step" data-x="'+offset+'"><div class="frame-content"><iframe width="100%" height="600" src="https://docs.google.com/forms/d/1bawAfxVi-oN4ytm2WbYripX0uClvj7iXyXkNCSIs-F8/viewform">Your browser does not support iframes, so you cannot view the feedback form.</iframe><br>Feedback form.</div>');
	}
}
/*
 * Used to print a story taken from a text
 * file.
 */
function printCaptionsImpress (captions, domElement){
	var i;
	var offset = 0;

	for(i = 0; i < captions.length; i++){
		var caption = captions[i]
		if(caption != "null" && caption != undefined){
			offset += 1024;
			//impress step
			var htmlToAppend = '<div class="step" data-x="'+offset+' " data-y="0">';

			//inside the step
			htmlToAppend += '<div class="frame-content">';

			//code display
			htmlToAppend += '<div class="code-hidden" onclick="toggleCode()"></div>';	//a helper for code hiding
			htmlToAppend += '<div class="code" onclick="toggleCode()">' + caption.code + "<br/></div>";

			//image
			htmlToAppend += '<img class="frame-image" onclick="impress().next()" src="'
			if(i<=5)
				htmlToAppend += "images/comics/storyasset0" + i + ".jpg";
			else
				htmlToAppend += 'images/comics/filler.jpg'
			htmlToAppend += '"/></br/>'
			//caption
			htmlToAppend += '<div class="caption">' + caption.text + "</div></div></div>;"
			$(domElement).append(htmlToAppend);
		}
	}
	offset += 1024;
	$(domElement).append('<div class="step" data-x="'+offset+'"><div class="frame-content"><iframe width="100%" height="600" src="https://docs.google.com/forms/d/1bawAfxVi-oN4ytm2WbYripX0uClvj7iXyXkNCSIs-F8/viewform">Your browser does not support iframes, so you cannot view the feedback form.</iframe><br>Feedback form.</div>');
}

//toggles the visibility of the
//raw rolemodel code
function toggleCode(){
	$(".code").animate({
	    height: "toggle",
	    opacity: "toggle",
	    easing: "quad"
	  }, 300, function() {  });
}
