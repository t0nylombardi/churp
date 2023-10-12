import { Controller } from "@hotwired/stimulus"
// import debounce from 'lodash/debounce'

// Connects to data-controller="show_tweet
export default class extends Controller {
  static values = { url: String }
  connect() {}

  show() {
    window.location.href = this.urlValue
  }
}
