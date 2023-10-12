import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="new_tweets"
export default class extends Controller {
  static targets = ["container", "notification"];
  connect() {
    console.log("New Tweet")
    this.newTweets = [];    
    window.addEventListener("newTweet", (e) => {
      // console.log(e.detail);
      this.newTweets.push(e.detail);
      this.showNotification();
    });
  }
  disconnect() {
    window.removeEventListener("newTweet", this.showNotification);
  }
  showNotification() {
    console.log("show: ", this.newTweets.length)
    this.notificationTarget.style.display = "block";
    this.notificationTarget.innerText = `Load ${this.newTweets.length} new Tweets`;
  }

  loadNewTweets() {
    this.newTweets.forEach((tweet) => {
      // Convert the HTML string into a node
      const parser = new DOMParser();
      const html = parser.parseFromString(tweet, "text/html");
      const tweetNode = html.body.firstChild;

      // Prepend the tweet to the container
      this.containerTarget.prepend(tweetNode);
    });
    this.newTweets = [];
    this.notificationTarget.style.display = "none";
  }
}