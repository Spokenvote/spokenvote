$(document).ready(function () {
  var defaultBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(-33.8902, 151.1759),
    new google.maps.LatLng(-33.8474, 151.2631));

  var searchbox = document.getElementById('google_places_search_text_field');
  var options = {
    bounds: defaultBounds,
    types: ['(regions)']
  };

  autocomplete = new google.maps.places.Autocomplete(searchbox, options);

  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    var place = autocomplete.getPlace();
    // console.log(place.id);
    $('#hub_google_location_id').val(place.id);
  });
});