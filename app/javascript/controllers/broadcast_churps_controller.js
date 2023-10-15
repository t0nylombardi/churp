import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="new_churps"
export default class extends Controller {
  static targets = ["container", "notification"];
  connect() {
    console.log("New Churp")
    this.newChurps = [];    
    window.addEventListener("newChurp", (e) => {
      // console.log(e.detail);
      this.newChurps.push(e.detail);
      this.showNotification();
    });
  }
  disconnect() {
    window.removeEventListener("newChurp", this.showNotification);
  }
  showNotification() {
    console.log("show: ", this.newChurps.length)
    this.notificationTarget.style.display = "block";
    this.notificationTarget.innerText = `Load ${this.newChurps.length} new Churps`;
  }

  loadNewChurps() {
    this.newChurps.forEach((churp) => {
      // Convert the HTML string into a node
      const parser = new DOMParser();
      const html = parser.parseFromString(churp, "text/html");
      const churpNode = html.body.firstChild;

      // Prepend the churp to the container
      this.containerTarget.prepend(churpNode);
    });
    this.newChurps = [];
    this.notificationTarget.style.display = "none";
  }
}