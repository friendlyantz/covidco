import mapboxgl from 'mapbox-gl';
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';

const buildMap = (mapElement) => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    // STYLES
      // DEFAULT STYLE
      style: 'mapbox://styles/mapbox/streets-v11'
      // GREY STYLE
      // style: 'mapbox://styles/pdunleav/cjofefl7u3j3e2sp0ylex3cyb'
      // OIL COMPANY
      // style: 'mapbox://styles/trueyakuza/ckiggob2c5kgv19o5q5ld75zk'
      // BLUEPRINT
      // style: 'mapbox://styles/trueyakuza/ckiggm1oc5khu19msroauy2pr'

  });
  //   const map = new mapboxgl.Map({
  //   container: 'map',
  //   style: 'mapbox://styles/pdunleav/cjofefl7u3j3e2sp0ylex3cyb' // <-- use your own!
  // });

};

const addMarkersToMap = (map, markers) => {
  
  // DEFAUL MARKER
    // markers.forEach((marker) => {
    //   const popup = new mapboxgl.Popup().setHTML(marker.infoWindow); 
    // new mapboxgl.Marker()
    //   .setLngLat([ marker.lng, marker.lat ])
    //   .setPopup(popup)
    //   .addTo(map);
  // });

       // CUSTOM MARKERS 
    markers.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);
      // Create a HTML element for your custom marker
      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundImage = `url('${marker.image_url}')`;
      element.style.backgroundSize = 'contain';
      element.style.width = '50px';
      element.style.height = '50px';
      // Pass the element as an argument to the new marker
      new mapboxgl.Marker({
      element
    })
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(map);
  });
};

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  map.fitBounds(bounds, { padding: 10, maxZoom: 15,
  animate: false
 });
};




const initMapbox = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) {
    const map = buildMap(mapElement);

    const markers = JSON.parse(mapElement.dataset.markers);
    addMarkersToMap(map, markers);

    
    console.log(markers)
    // MAPBOX DEBUGGER
    // setTimeout(function() {  
      // }, 500)
      
      // fit to marker AFTER mapload
      map.on('load', function () {
        fitMapToMarkers(map, markers);
    });   

    // map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
    //                                     mapboxgl: mapboxgl }));


  }
};

export { initMapbox };