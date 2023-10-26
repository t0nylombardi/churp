import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="new_churps"
export default class extends Controller {
  static targets = ["container", "notification", "notificationParent"];
  connect() {
    this.newChurps = [];    
    window.addEventListener("newChurp", (e) => {
      this.newChurps.push(e.detail);
      setTimeout(() => {
        console.log("Delayed for 1 second.");
        this.showNotification();
      }, "1000");
    });
  }
  disconnect() {
    window.removeEventListener("newChurp", this.showNotification);
  }
  showNotification() {
    this.notificationParentTarget.style.display = "block";
    this.notificationTarget.style.display = "block";
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
      this.notificationTarget.style.display = "none";
  }
}