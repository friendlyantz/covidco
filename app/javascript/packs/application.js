// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import 'bootstrap';

// CSS
import 'mapbox-gl/dist/mapbox-gl.css';
// internal imports
import { initMapbox } from '../plugins/init_mapbox'
import { initSelect2 } from '../components/init_select2';

document.addEventListener('turbolinks:load', () => {
  initMapbox();
})
document.addEventListener("turbolinks:load", () => {
  initSelect2();
});

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("aos")
require("bigpicture")
require("flickity")
require("choices")
require("countup")
// require("dropzone")
require("flickity-as-nav-for")
require("flickity-fade")
require("flickity-imagesloaded")
require("imagesloaded")
require("isotope-layout")
require("jarallax")
require("lightgallery")
// require("popper")
require("quill")
require("smooth-scroll")
require("typed")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "controllers"
