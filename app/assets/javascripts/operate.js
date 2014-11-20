$(function(){
// listen to focusOut of address
  
  $('.r_address').focusout(function(){
    var adr = $(this).val();
    address_to_latlng(adr);
  });
})
