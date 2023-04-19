$('td').focusout(function(){
  var car_class = "." + $(this).attr("class").match(/car-\d+/);
  var select_elem = $(car_class).find('select');
  var text = $("option:selected", select_elem).text();
  $(car_class).each(function(i,elem){
  	var child_elem = $(elem).find('input');
  	child_elem.removeClass();
  	if(text == '軽'){
  		child_elem.addClass("form-control border-success text-success");
  	}else{
  		child_elem.addClass("form-control border-danger text-danger");
  	}
  });
});


/*
$("[class^='car-']").on('keypress', function(event){
	console.log("aaa");
	//$(this).keydown(function(event){
		console.log("hoge");
		if(event.which === 13){
			alert("hoge");
		}
	});
});
*/

//$("[class^='car-'] input").on('keypress', function(event) {
$("input").on('keypress', function(event) {
  if (event.which === 13) {
    if(event.shiftKey){
    	if(! $('form')[0].reportValidity()){
    		return false;
    	}
    	$('form').submit();
    	return false;
    }else{
  	    event.preventDefault();
	    var car_class = "." + $(this).parent().attr("class").match(/car-\d+/);
	    var car_num = car_class.match(/\d+/);
    	var next_car_num = Number(car_num) + 1;
	    var next_car_class = ".car-" + next_car_num;
	    var next_car = $(next_car_class);
	    if(next_car.length){
	    	$(next_car_class).find('select').focus();
	    }else{
	    }
	    return false;
    }    
  }
});
