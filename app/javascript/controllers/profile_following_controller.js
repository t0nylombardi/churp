import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="following-button"
export default class extends Controller {
  static targets = ["follow", "profile"];

  connect() { 
    this.index = 1;
  }

  unfollow() {
    this.index--
    this.followTarget.classList.remove("primary")
    this.followTarget.classList.add("error")
    this.toggleTargets()
  }
  
  follow() {
    this.index++
    this.followTarget.classList.remove("error")
    this.followTarget.classList.add("primary")
    this.toggleTargets()

  }
  
  toggleTargets() {
    this.followTarget.innerText = this.index == 1 ? 'Following' : 'Unfollow';
  }

  
  disconnect() { 
    // this.channel.unsubscribe(); 
  } 
}
