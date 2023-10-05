// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
<<<<<<< HEAD
import "./channels"
import consumer from './channels/consumer'
import CableReady from "cable_ready"
import mrujs from "mrujs";
import { CableCar } from "mrujs/plugins"

mrujs.start({
  plugins: [
    new CableCar(CableReady)
  ]
})

$(document).on('turbolinks:load', function(){ $.rails.refreshCSRFTokens(); });
=======
import "trix"
import "@rails/actiontext"
>>>>>>> parent of 002b2ff (add pundit and hotwire/stimulus)
