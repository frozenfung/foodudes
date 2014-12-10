var map;
var mapOptions;
var recommend_marker = null;
var marker_animation = null;
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
    for (var i = 0, marker; marker = markers_candidate[i]; i++) {
      marker.setMap(null);
    }
    markers_candidate = [];
    var bounds = new google.maps.LatLngBounds();
    for (var i = 0, place; place = places[i]; i++) {
      var image = {
        url: 'http://maps.google.com/mapfiles/kml/paddle/ylw-stars.png',
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(64, 64)
      };

      // Set Info of places
      var name = place.name;
      var address = '';
      if (place.address_components) {
        address = [
          (place.address_components[3] && place.address_components[3].short_name || ''),
          (place.address_components[2] && place.address_components[2].short_name || ''),
          (place.address_components[1] && place.address_components[1].short_name || ''),
          (place.address_components[0] && place.address_components[0].short_name || '')            
        ].join('');
      }
      var phone_number = (place.formatted_phone_number) ? place.formatted_phone_number : '';       
      var lat = place.geometry.location.lat();
      var lng = place.geometry.location.lng();
      var fake_cursor = name + '~_~' + 
                        phone_number + '~_~' +
                        address + '~_~' +
                        lat + '~_~' +
                        lng;

      // Create a marker for each place.
      var marker = new google.maps.Marker({
        map: map,
        icon: image,
        cursor: fake_cursor,
        position: place.geometry.location
      });

      markers_candidate.push(marker);
      bounds.extend(place.geometry.location);

      google.maps.event.addListener(marker, 'click', function() {
        recommend_marker = this;
        var info = this.getCursor();
        var info_array = info.split('~_~');
        setInfo(info_array[0], info_array[1], info_array[2]);
        setFormData(info_array[0], info_array[1], info_array[2], info_array[3], info_array[4]);
        setFriendData(info_array[0], info_array[3], info_array[4]);
      });
    }
    map.fitBounds(bounds);
  });
  // autocomplete
  // google.maps.event.addListener(autocomplete, 'place_changed', function() {
  //   marker.setVisible(false);
  //   var place = autocomplete.getPlace();
  //   if (!place.geometry) {
  //     return;
  //   }else{
  //     // If the place has a geometry, then present it on a map.
  //     if (place.geometry.viewport) {
  //       map.fitBounds(place.geometry.viewport);
  //     } else {
  //       map.setCenter(place.geometry.location);
  //       map.setZoom(18);  // Why 17? Because it looks good.
  //     }
  //     marker.setIcon(/** @type {google.maps.Icon} */({
  //         url: 'http://maps.google.com/mapfiles/kml/paddle/ylw-stars.png',
  //         // size: new google.maps.Size(71, 71),
  //         origin: new google.maps.Point(0, 0),
  //         anchor: new google.maps.Point(17, 34),
  //         scaledSize: new google.maps.Size(64, 64)
  //     }));
  //     marker.setPosition(place.geometry.location);
  //     marker.setVisible(true);
  //     // food_info setting
  //     var name = place.name;
  //     var address = '';
  //     if (place.address_components) {
  //       address = [
  //         (place.address_components[3] && place.address_components[3].short_name || ''),
  //         (place.address_components[2] && place.address_components[2].short_name || ''),
  //         (place.address_components[1] && place.address_components[1].short_name || ''),
  //         (place.address_components[0] && place.address_components[0].short_name || '')            
  //       ].join('');
  //     }
  //     var phone_number = (place.formatted_phone_number) ? place.formatted_phone_number : '';
  //     var lat = place.geometry.location.lat();
  //     var lng = place.geometry.location.lng();
  //     setInfo(name, phone_number, address);
  //     setFormData(name, phone_number, address, lat, lng);
  //     setFriendData(name, address);
  //     if ( marker_recommend != null){
  //       marker_recommend.setMap(map);
  //     }
  //   }
  // });

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
  for(var i = 0; i < map_infos.length; i++){
    var fake_cursor = 
    map_infos[i]['name'] + '~_~' +
    map_infos[i]['phone_number'] + '~_~' +
    map_infos[i]['address'] + '~_~' +
    map_infos[i]['marker_lat'] + '~_~' +
    map_infos[i]['marker_lng'];  
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(
          map_infos[i]['marker_lat'], 
          map_infos[i]['marker_lng']
        ),
      cursor: fake_cursor,
      icon: map_infos[i]['friend_icon'],
      map: map
    });
    // var marker = new RichMarker({
    //   position: new google.maps.LatLng(
    //       map_infos[i]["marker_lat"], 
    //       map_infos[i]["marker_lng"]
    //     ),
    //   content: '<div class="marker_background"><img src="'+map_infos[i]["friend_icon"]+'" class="friend_icon" /></div>',
    //   title: titleList,
    //   map: map
    // })
    // .setShadow('5px -3px 3px #555');
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
      var info = this.getCursor();
      var info_array = info.split('~_~');
      setInfo(info_array[0], info_array[1], info_array[2]);
      setFormData(info_array[0], info_array[1], info_array[2], info_array[3], info_array[4]);
      setFriendData(info_array[0], info_array[3], info_array[4]);
    });
    markers.push(marker);
  }
  cluster = new MarkerClusterer(map, markers);
}

// Set recommend data

var setInfo = function(name, phone_number, address){
  $('.food_info_content').html(
    '<li class="name_info">名稱 : ' + name + '</li>' +
    '<li class="phone_number_info">電話 : ' + phone_number + '</li>' +
    '<li class="address_info">地址 : ' + address + '</li>'
  );
  $('.food_info').addClass('food_info_fadeIn');
}

var setFormData = function(name, phone_number, address, lat, lng){
  $('.form_name').val(name);
  $('.form_phone_number').val(phone_number);
  $('.form_address').val(address);
  $('.form_lat').val(lat);
  $('.form_lng').val(lng);
}

var setFriendData = function(name, lat, lng){
  li_index = 0;
  $('.friend_info_content').css("left", 0);
  $('.food_info .left_arrow').css('display', 'none');
  $('.food_info .right_arrow').css('display', 'none');
  $.ajax({
    url: '/restaurants',
    type: 'GET',
    data: {name: name, lat: lat, lng: lng},
    contentType: 'script'
  }).done(function(){
    $('.friend_info_content>li').css('width', $(window).width()*0.31);
    if ($('.friend_info_content').html() == '') {
      $('.friend_info_content').html("<li>你真幸運！這家店還沒有被朋友推薦過！<br>馬上成為第一個推薦這家餐廳的人！</li>");
      $('.friends_count').html('0');  
    }
  });
}

// Ajax recommend data
var recommend_callback = function(restaurant_params, count){
  $('.form_content').html('');
  $('#recommend_form').modal('hide');
  $('.food_info').removeClass('food_info_fadeIn');
  restaurant_params = restaurant_params.replace(/&quot;/g, '"');
  restaurant_params = JSON.parse(restaurant_params);
  recommend_marker.setIcon(restaurant_params[5]);
  recommend_marker.setAnimation(google.maps.Animation.DROP);
  markers.push(recommend_marker); 
  cluster.addMarker(recommend_marker);
}









