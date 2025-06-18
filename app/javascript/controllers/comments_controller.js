import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["replyForm"]

  toggleReply() {
    console.log("kek");
    this.replyFormTarget.classList.toggle("hidden");
  }
}
