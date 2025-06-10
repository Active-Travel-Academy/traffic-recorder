import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "toggleAll", "enableForm", "disableForm"]

  connect() {
    this.updateToggleAllState()
  }

  toggleAll(event) {
    const checked = event.target.checked
    this.checkboxTargets.forEach(cb => {
      if (cb.checked === checked) return
      cb.checked = checked
    })

    if (checked) {
      this.enableFormTarget.requestSubmit()
    } else {
      this.disableFormTarget.requestSubmit()
    }
  }

  updateToggleAllState() {
    const total = this.checkboxTargets.length
    const checked = this.checkboxTargets.filter(cb => cb.checked).length

    if (checked === 0) {
      this.toggleAllTargets.forEach(el => {
        el.indeterminate = false
        el.checked = false
      })
    } else if (checked === total) {
      this.toggleAllTargets.forEach(el => {
        el.indeterminate = false
        el.checked = true
     })
    } else {
      this.toggleAllTargets.forEach(el =>  { el.indeterminate = true })
    }
  }

  checkboxTargetConnected(element) {
    element.addEventListener("change", () => this.updateToggleAllState())
  }
}

