var ksVis = function(){};

ksVis.files = [] ;

ksVis.loadStory = function(index){
    console.log("here");
       $.ajax({
	 url: "asp/exports/bundle.dat",
	 success: function(data){
		console.log(data);
		this.files = data.split("\n");	 
		this.files.pop();			// remove last blank line
		console.log(index%(this.files.length)); 
		var targetUrl = "asp/exports/" + this.files[index%(this.files.length)] ; 

		console.log(targetUrl) ;

		// original load call
		$.ajax({
    			
			url: targetUrl,
			success: function(data) {
				
				console.log("THE DATA: "+data);
				ksVis.setStory(data) ;
			},
			fail: function(data){
    				alert("Error: Unable to retrieve story from server.");
    			  }	
    		});

	 },

 	 fail: function(data){
		 alert("MalFunCtioN!");
	 	}
	 });
         

}

ksVis.setStory =  function(data){
			console.log("Asp: " + data);
			captions = new Array();
			//eval(data);
            var lines = data.split("\n");
            for(var i = 0; i < lines.length;i++){
                var index = eval(lines[i]);
                if(captions[index] == undefined){
                    captions[index] = new Array();
                    captions[index].code = lines[i] + "<br/>";
                }
                else if(captions[index].code == undefined){
                    captions[index].code = lines[i] + "<br/>";
                }
                else{
                    captions[index].code += lines[i] + "<br/>";
                }
            }
					
			printCaptionsImpress(captions, "#impress");
			impress().init();
		    console.log(captions);
}


