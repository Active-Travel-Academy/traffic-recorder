import { Controller } from "@hotwired/stimulus"
import Choices from "choices.js"

// Connects to data-controller="choices"
export default class extends Controller {
  static targets = ["select"]

  connect() {
    if (!this.choices) {
      this.choices = new Choices(this.selectTarget, {
        removeItemButton: true,
        searchEnabled: true,
        shouldSort: false,
        position: 'top',
      })
      this.selectTarget.addEventListener("change", (event) => {
        const category = event.target.value
        this.dispatch("categorySelected", { detail: { category } })
      })
    }
  }

  disconnect() {
    if (this.choices) {
      this.choices.destroy()
      this.choices = null
    }
  }
}
