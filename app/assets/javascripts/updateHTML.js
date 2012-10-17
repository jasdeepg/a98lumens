jQuery(function($) {
  $("#day").click(function() {

  	var $div1 = $('#day-graph');
  	var $div2 = $('#week-graph');
  	var $div3 = $('#year-graph');

  	if ($div1.is(":hidden")) {
  		$div1.show();
  		$div2.hide();
  		$div3.hide();
	}
  	else {
  		$div1.hide();
  		$div2.hide();
  		$div3.show();
  	}
  	return false;
  //  alert("Thanks for clicking me");
  });
});

jQuery(function($) {
  $("#week").click(function() {

  	var $div1 = $('#day-graph');
  	var $div2 = $('#week-graph');
  	var $div3 = $('#year-graph');

  	if ($div2.is(":hidden")) {
  		$div1.hide();
  		$div2.show();
  		$div3.hide();
	}
  	else {
  		$div1.hide();
  		$div2.hide();
  		$div3.show();
  	}
  //  alert("Thanks for clicking me");
  });
});

jQuery(function($) {
  $("#year").click(function() {

  	var $div1 = $('#day-graph');
  	var $div2 = $('#week-graph');
  	var $div3 = $('#year-graph');

  	if ($div3.is(":hidden")) {
  		$div1.hide();
  		$div2.hide();
  		$div3.show();
	}
  	else {
  		$div1.hide();
  		$div2.hide();
  		$div3.show();
  	}
  //  alert("Thanks for clicking me");
  });
});