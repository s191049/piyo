$(".hankaku-num-form").on('change', function(event){
	let str = $(this).val();
	str = str.replace(/[０-９]/g, function(s){
		return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
	});
	$(this).val(str);
});

$(function(){
	$('.clear-form-btn').on('click', function(){
	  $("#search_form").find("textarea, :text, select").val("").end().find(":checked").prop("checked", false);
	});
});

$(function(){
	$('.enter-number').keypress(function(e){
		const key = e.keyCode;
		if(key === 13){
			$('.hankaku-num-form').focus();
			return false;
		}
		
	});
});