var li_index = 0;
var find_food_string = 'e.g. 鼎泰豐, 豪大雞排, 牛肉麵...';
$(function(){

  // $('.food_info .right_arrow').click(function(){
  //   var li_width = $('.food_info_content>li').css("width");
  //   li_width = parseInt(li_width.replace('px', '')) + 120;
  //   $('.friend_info_content').animate({
  //     left: li_width * (li_index - 1)
  //   }, 500);
  //   li_index -= 1;
  //   $('.food_info .left_arrow').css('display', 'block');
  //   if( parseInt($('.friends_count').html()) + li_index == 1 ){
  //     $(this).css('display', 'none')
  //   }
  // });

  // $('.food_info .left_arrow').click(function(){
  //   var li_width = $('.food_info_content>li').css("width");
  //   li_width = parseInt(li_width.replace('px', '')) + 120;
  //   $('.friend_info_content').animate({
  //     left: li_width * (li_index + 1)
  //   }, 500);
  //   li_index += 1;
  //   $('.food_info .right_arrow').css('display', 'block');
  //   if( li_index == 0 ){
  //     $(this).css('display', 'none')
  //   }
  // });

  $('#gmaps').css('height', $(window).height());

  $('.X').click(function(){
    $(this).parent().removeClass('food_info_fadeIn');
    if (marker_animation != null){
      marker_animation.setAnimation(null);
    }
  });

  $('.find_food h2 span').click(function(){
    if ( !$(this).hasClass('select') ){
      $('.find_food h2 .select').removeClass('select');
      $(this).addClass('select');
      var string = $('#gmaps-place').attr('placeholder');
      $('#gmaps-place').attr('placeholder', find_food_string);
      find_food_string = string;
      if ( show_result == null ){
        show_result = map
      }else{
        show_result = null
      }
    }
  });

  $('.find_food h2 .search_area').click(function(){
    for(var i = 0; i < markers.length; i++){
      markers[i].setMap(map);
      cluster.addMarker(markers[i]);
    }
    for(var j = 0; j < markers_candidate.length; j++){
      markers_candidate[j].setMap(null);
    }

    $('#gmaps-place').val('');
  });

  $('.find_food h2 .recommend_restaurant').click(function(){
    for(var i = 0; i < markers.length; i++){
      markers[i].setMap(null);
    }
    for(var j = 0; j < markers_candidate.length; j++){
      markers_candidate[j].setMap(null);
    }
    cluster.clearMarkers();
    $('#gmaps-place').val('');
  });
})
