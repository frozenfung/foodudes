var li_index = 0;

$(function(){

  $('.food_info .right_arrow').click(function(){
    var li_width = $('.food_info_content>li').css("width");
    li_width = parseInt(li_width.replace('px', '')) + 120;
    $('.friend_info_content').animate({
      left: li_width * (li_index - 1)
    }, 500);
    li_index -= 1;
    $('.food_info .left_arrow').css('display', 'block');
    if( parseInt($('.friends_count').html()) + li_index == 1 ){
      $(this).css('display', 'none')
    }
  });

  $('.food_info .left_arrow').click(function(){
    var li_width = $('.food_info_content>li').css("width");
    li_width = parseInt(li_width.replace('px', '')) + 120;
    $('.friend_info_content').animate({
      left: li_width * (li_index + 1)
    }, 500);
    li_index += 1;
    $('.food_info .right_arrow').css('display', 'block');
    if( li_index == 0 ){
      $(this).css('display', 'none')
    }
  });

  $('.X').click(function(){
    $(this).parent().removeClass('food_info_fadeIn');
    if (marker_animation != null){
      marker_animation.setAnimation(null);
    }
  });

})
