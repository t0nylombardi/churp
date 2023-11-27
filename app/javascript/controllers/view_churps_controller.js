import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

// Connects to data-controller="view-churps"
export default class extends Controller {
  static targets = ['count'];
  connect() {

    let churpId = this.element.dataset.churpId;
    this.sub = this.showViewChurps(churpId, this.countTarget);
    // console.log("Element", this.element.InnerText = 1)
    // console.log("sub", this.sub);
  }

  showViewChurps(churpId, element) {
    return consumer.subscriptions.create(
      // room_#{params[:room_id]}_channel
      { channel: "ViewChurpsChannel", churp_id: churpId },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          this.perform("churp_data");
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          // Called when there's incoming data on the websocket for this channel
          // console.log("controllerJS data", data);
          // this.element.innerHTML = data.churp.view_count

          // console.log("target", this.countTarget.innerText)
          element.innerHTML = data.churp.view_count;
          // element.style.color = 'red';

          // console.log("countTarget", element)


        },
      }
    );
  }
}