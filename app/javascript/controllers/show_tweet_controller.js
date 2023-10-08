import { Controller } from "@hotwired/stimulus"
// import debounce from 'lodash/debounce'

// Connects to data-controller="tweet"
export default class extends Controller {
  static values = { url: String }
  connect() {}

  show() {
    console.log({url: this.urlValue})
    window.location.href = this.urlValue
  }
}
