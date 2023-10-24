import { Controller } from "@hotwired/stimulus"
// import debounce from 'lodash/debounce'

// Connects to data-controller="show_churp
export default class extends Controller {
  static values = { 
    url: String 
  }
  connect() {}

  showChurp() {
    window.location.href = this.urlValue
  }
}
