import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "hideable"]

  // hide modal
  // action: "profile-modal#hideModal"
  hideModal() {
    console.log("Hiding modal")

    this.hideableTargets.forEach(el => {
      el.hidden = true
    });
  }

  // hide modal on successful form submission
  // action: "turbo:submit-end->turbo-modal#submitEnd"
  submitEnd(e) {
    if (e.detail.success) {
      this.hideModal()
    }
  }

  // hide modal when clicking ESC
  // action: "keyup@window->turbo-modal#closeWithKeyboard"
  closeWithKeyboard(e) {
    if (e.code == "Escape") {
      this.hideModal()
    }
  }

  // hide modal when clicking outside of modal
  // action: "click@window->turbo-modal#closeBackground"
  closeBackground(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return;
    }
    this.hideModal()
  }
}