import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

// Connects to data-controller="view-churps"
export default class extends Controller {
  static targets = ['count'];
  connect() {
  }
}
