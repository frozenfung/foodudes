var map;
var mapOptions;
var geocoder = new google.maps.Geocoder();

// receive marker data from controller
var map_infos = [];
map_infos = gon.map_infos; 


// Build initialize Gmap and build markers on it
//function initialize(){
  // mapOptions = {
  //   zoom: 14,
  //   center: new google.maps.LatLng(25.026, 121.523)
  // };


  //map = new google.maps.Map(document.getElementById('gmaps'), mapOptions);
//}  

// AutoComplete setting
function initialize() {
  mapOptions = {
    center: new google.maps.LatLng(25.026, 121.523),
    zoom: 17
  };

  map = new google.maps.Map(document.getElementById('gmaps'),
    mapOptions);

  var input = /** @type {HTMLInputElement} */(
      document.getElementById('gmaps-place'));
  var autocomplete = new google.maps.places.Autocomplete(input);
  //autocomplete.bindTo('bounds', map);

  //var infowindow = new google.maps.InfoWindow();
  var marker = new google.maps.Marker({
    map: map,
    anchorPoint: new google.maps.Point(0, -29)
  });
  google.maps.event.addListener(marker, 'click', function() {
    $('.food_info').addClass('food_info_fadeIn');
  });
  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    marker.setVisible(false);
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      return;
    }

    // If the place has a geometry, then present it on a map.
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
      map.setZoom(17);  // Why 17? Because it looks good.
    }
    marker.setIcon(/** @type {google.maps.Icon} */({
      url: place.icon,
      size: new google.maps.Size(71, 71),
      origin: new google.maps.Point(0, 0),
      anchor: new google.maps.Point(17, 34),
      scaledSize: new google.maps.Size(35, 35)
    }));
    marker.setPosition(place.geometry.location);
    marker.setVisible(true);

    // food_info setting
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
    var content = 
      '<li class="name_info">名稱 : ' + name + '</li>' +
      '<li class="phone_number_info">電話 : ' + phone_number + '</li>' +
      '<li class="address_info">地址 : ' + address + '</li>' +
      '<li class="lat_info">' + lat + '</li>' +
      '<li class="lng_info">' + lng + '</li>';

    $('.food_info_content').html(content);
  });

  if(gon.map_infos){
    addMarkers();
  }
}

google.maps.event.addDomListener(window, 'load', initialize);


// Add Markers on Map
function addMarkers() {
  //var rmarkers = [];
  for(var i = 0; i < map_infos.length; i++){
    var rmarker = new google.maps.Marker({
      position: new google.maps.LatLng(
          map_infos[i]["marker_lat"], 
          map_infos[i]["marker_lng"]
        ),
      map: map
    });
    // var rmarker = new RichMarker({
    //   position: new google.maps.LatLng(
    //       map_infos[i]["marker_lat"], 
    //       map_infos[i]["marker_lng"]
    //     ),
    //   content: '<div class="marker_background"><img src="'+map_infos[i]["friend_icon"]+'" class="friend_icon" /></div>',
    //   map: map
    // })
    // .setShadow('5px -3px 3px #555');
    google.maps.event.addListener(rmarker, 'click', function() {
      $('.food_info').addClass('food_info_fadeIn');
    });
    //rmarkers.push(rmarker);
  }
  //var cluster = new MarkerClusterer(map, rmarkers);  
}



// transfer Address to latlng
function address_to_latlng(address){
  geocoder.geocode(
    {'address': address},
    function(result, status){
      if (status == google.maps.GeocoderStatus.OK){
        var lat = result[0].geometry.location.lat();
        var lng = result[0].geometry.location.lng();
      }else{
        alert('failure!');
      }
    }
  );
}


