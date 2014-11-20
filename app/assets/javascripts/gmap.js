// define variable 

// transfer Address to latlng
var geocoder = new google.maps.Geocoder();
function address_to_latlng(address){
  var loc = [];
  geocoder.geocode(
    {'address': address},
    function(result, status){
      if (status == google.maps.GeocoderStatus.OK){
        loc[0] = result[0].geometry.location.lat();
        loc[1] = result[0].geometry.location.lng();
        $('.r_lat').val(loc[0]);
        $('.r_lng').val(loc[1]);
      }else{
        alert('failure!');
      }
    }
  );
}

// Build initialize Gmap and build markers on it


// initialize array
var map_infos = [];
// receive marker data from controller
map_infos = gon.map_infos; 

function initialize() {
  var mapOptions = {
    zoom: 8,
    center: new google.maps.LatLng(25.026, 121.523)
  };

  var map = new google.maps.Map(document.getElementById('map'), mapOptions);

  var rmarkers = [];
  for(var i = 0; i < map_infos.length; i++){
      // var rmarker = new google.maps.Marker({
      //   position: new google.maps.LatLng(
      //       map_infos[i]["marker_lat"], 
      //       map_infos[i]["marker_lng"]
      //     ),
      //   map: map
      // });
      var rmarker = new RichMarker({
        position: new google.maps.LatLng(
            map_infos[i]["marker_lat"], 
            map_infos[i]["marker_lng"]
          ),
        content: '<div class="marker_background"><img src="'+map_infos[i]["friend_icon"]+'" class="friend_icon" /></div>',
        map: map
      }).setShadow('5px -3px 3px #555');
      rmarkers.push(rmarker);
  }
  var markerCluster = new MarkerClusterer(map, rmarkers);
}

google.maps.event.addDomListener(window, 'load', initialize);
