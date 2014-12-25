var map;
var mapOptions;
var recommend_marker = null;
var marker_animation = null;
var show_result = null;
// receive marker data from controller
var map_infos = [];
map_infos = gon.map_infos; 

// variables from addMarkers
var markers = [];
var markers_candidate = [];
var cluster;

function initialize() {
  mapOptions = {
    // disableDefaultUI: true,
    center: new google.maps.LatLng(25.026, 121.523),
    zoom: 16
  };

  map = new google.maps.Map(document.getElementById('gmaps'),
    mapOptions);

  var input = document.getElementById('gmaps-place');
  //var autocomplete = new google.maps.places.Autocomplete(input);
  var searchBox = new google.maps.places.SearchBox(input);
  
  //autocomplete.bindTo('bounds', map);
  //var infowindow = new google.maps.InfoWindow();
  var marker = new google.maps.Marker({
    map: map,
    anchorPoint: new google.maps.Point(0, -29)
  });

  google.maps.event.addListener(marker, 'click', function() {   
    $('.food_info').addClass('food_info_fadeIn');
  });

  // search box 
  google.maps.event.addListener(searchBox, 'places_changed', function() {
    var places = searchBox.getPlaces();
    if (places.length == 0) {
      return;
    }
    markers_candidate.forEach(function(marker){
      marker.setMap(null);
    });
    markers_candidate = [];

    var bounds = new google.maps.LatLngBounds();
    places.forEach(function(place){
      var image = {
        url: 'http://maps.google.com/mapfiles/kml/paddle/ylw-stars.png',
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(64, 64)
      };
      // Set Info of places
      var infos = [];
      infos.push(place.name);
      var address = '';
      if (place.address_components) {
        address = [
          (place.address_components[3] && place.address_components[3].short_name || ''),
          (place.address_components[2] && place.address_components[2].short_name || ''),
          (place.address_components[1] && place.address_components[1].short_name || ''),
          (place.address_components[0] && place.address_components[0].short_name || '')            
        ].join('');
      }
      infos.push(address);
      infos.push(place.formatted_phone_number ? place.formatted_phone_number : '');       
      infos.push(place.geometry.location.lat());
      infos.push(place.geometry.location.lng());
      var fake_cursor = infos.join('~_~');

      // Create a marker for each place
      var marker = new google.maps.Marker({
        map: map,
        icon: image,
        cursor: fake_cursor,
        position: place.geometry.location
      });
      marker.setMap(show_result);
      markers_candidate.push(marker);
      bounds.extend(place.geometry.location);
      set_marker_click_event(marker);
    });
    map.fitBounds(bounds);
    map.setZoom(15);
  });

  // Draw Markers from Database
  if(gon.map_infos){
    addMarkers();
  }

  // Listener
  google.maps.event.addListener(map, 'center_changed', function(){
    $('.food_info').removeClass('food_info_fadeIn');
    if(marker_animation != null){
      marker_animation.setAnimation(null);
    }
  }); 
  google.maps.event.addListener(map, 'bounds_changed', function() {
    var bounds = map.getBounds();
    searchBox.setBounds(bounds);
  }); 
}

google.maps.event.addDomListener(window, 'load', initialize);


// Add Markers on Map
function addMarkers() {
  map_infos.forEach(function(infos){
    var fake_cursor = infos.join('~_~');
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(
          parseFloat(infos[3]), 
          parseFloat(infos[4])
        ),
      cursor: fake_cursor,
      icon: infos[5],
      map: map
    });
    set_marker_click_event(marker);
    markers.push(marker);
  });
  cluster = new MarkerClusterer(map, markers);
}


var set_marker_click_event = function(marker){
  google.maps.event.addListener(marker, 'click', function() {
    if (this.getAnimation() != null) {
      this.setAnimation(null);    
    } else {
      if (marker_animation != null){
        marker_animation.setAnimation(null);
      }
      this.setAnimation(google.maps.Animation.BOUNCE);
      marker_animation = this;
    }
    recommend_marker = this;
    var info = this.getCursor();
    var info_array = info.split('~_~');
    setData(info_array);
  });  
}

// Set datas

var setData = function(info_array){
  setInfo(info_array);
  setForm(info_array);
  setFriend(info_array);
}

var setInfo = function(info_array){
  $('.name_info span:last-child').text(info_array[0]);
  $('.phone_number_info span:last-child').text(info_array[1]); 
  $('.address_info span:last-child').text(info_array[2]); 
  $('.food_info').addClass('food_info_fadeIn');
}

var setForm = function(info_array){
  $('.form_name').val(info_array[0]);
  $('.form_phone_number').val(info_array[1]);
  $('.form_address').val(info_array[2]);
  $('.form_lat').val(info_array[3]);
  $('.form_lng').val(info_array[4]);
}

var setFriend = function(info_array){
  li_index = 0;
  $('.friend_info_content').css("left", 0);
  $.ajax({
    url: '/restaurants',
    type: 'GET',
    data: {name: info_array[0], lat: info_array[3], lng: info_array[4]},
    contentType: 'script'
  }).done(function(){
    $('.friend_info_content>li').css('width', $(window).width()*0.31);
    if ($('.friend_info_content>li:first').text().length < 1) {
      $('.friend_info_content').append("<br><br><li></li>");
      $('.friend_info_content>li:first').text("你真幸運:)這家店還沒有被朋友推薦過！馬上成為第一個推薦這家餐廳的人！");
      $('.friends_count').text('0');  
    }
  });
}

// Ajax recommend data
var recommend_callback = function(restaurant_params){
  $('.form_content').val('');
  $('#recommend_form').modal('hide');
  $('.food_info').removeClass('food_info_fadeIn');
  marker_animation.setAnimation(null);
  recommend_marker.setIcon(restaurant_params[5]);
  recommend_marker.setAnimation(google.maps.Animation.DROP);
  markers.push(recommend_marker); 
  cluster.addMarker(recommend_marker);
}









