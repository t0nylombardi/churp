import { Controller } from "@hotwired/stimulus"
// import debounce from 'lodash/debounce'

// Connects to data-controller="show_churp
export default class extends Controller {
  static values = { 
    url: String 
  }
  connect() {
    console.log("Connectting to data-controller='how-churp'");
  }

  showChurp() {
    console.log("show_churp");
    window.location.href = this.urlValue
  }
}
