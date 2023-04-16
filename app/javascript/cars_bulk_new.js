/*
$('select').focusout(function(){
  var text = $("option:selected", this).text();
  var car_class = $(this).parent().attr("class");
  var target_car = car_class.match(/car-\d+/);
  var target_car_class = "." + target_car;
  $(target_car_class).each(function(i,elem){
  	var child_elem = $(elem).find('input');
  	child_elem.removeClass();
  	if(text == '軽'){
  		child_elem.addClass("form-control border-success text-success");
  	}else{
  		child_elem.addClass("form-control border-danger text-danger");
  	}
  });
});
*/
$('td').focusout(function(){
//$('select').focusout(function(){
//$('select').change(function(){
  //var text = $('option:selected').text();
  var car_class = "." + $(this).attr("class").match(/car-\d+/)
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
  	//$(child_elem).css('background-color','red');
  });
});