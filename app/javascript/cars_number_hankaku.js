$(".hankaku-num-form").on('change', function(event){
	let str = $(this).val();
	str = str.replace(/[０-９]/g, function(s){
		return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
	});
	$(this).val(str);
});