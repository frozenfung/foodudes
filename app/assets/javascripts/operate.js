$(function(){
  $('#gmaps-place').keypress(function(){
    if ( event.which == 13 ) {
       event.preventDefault();
    }
  });

  $('.X').click(function(){
    $(this).parent().removeClass('food_info_fadeIn');
  });

  // $('.control_panel').hover(
  //   function(){
  //     $('.food_info').addClass('food_info_fadeIn');
  //   },
  //   function(){
  //     $('.food_info').removeClass('food_info_fadeIn');
  //   }
  // );
})
