import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="new_churps"
export default class extends Controller {
  static targets = ["container", "notification", "notificationParent"];
  static classes = ["change"]

  connect() {
    this.newChurps = [];
    window.addEventListener("newChurp", (e) => {
      this.newChurps.push(e.detail);
      this.showNotification();
    });
  }

  disconnect() {
    window.removeEventListener("newChurp", this.showNotification);
  }

  showNotification() {
    this.toggle()
    this.notificationTarget.innerText = `Load ${this.newChurps.length} new Churps`;
  }

  loadNewChurps() {
    this.newChurps.forEach((churp) => {
      // Convert the HTML string into a node
      const parser = new DOMParser();
      const html = parser.parseFromString(churp, "text/html");
      const churpNode = html.body.firstChild;
      console.log({'churpNode': churpNode });

      // Prepend the churp to the container
      this.containerTarget.prepend(churpNode);
    });
      this.newChurps = [];
      this.toggle();
  }

  toggle() {
    this.notificationParentTargets.forEach((el) => {
      el.hidden = !el.hidden;
    });
  }
}