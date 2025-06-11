import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "toggleAll", "journeyIds", "allJourneys", "selectedCount"]

  connect() {
    this.updateToggleAllState()
  }

  toggleAll(event) {
    const checked = event.target.checked
    this.checkboxTargets.forEach(el => {
      if (el.checked === checked) return
      el.checked = checked
    })
    this.allJourneysTargets.forEach(el => el.value = this.toggleAllTarget.checked)
    this.updateSelectedCount()
  }

  updateToggleAllState() {
    const checked = this.checkedCheckboxes()

    if (checked.length === 0) {
      this.toggleAllTarget.indeterminate = false
      this.toggleAllTarget.checked = false
    } else {
      this.toggleAllTarget.indeterminate = true
      this.toggleAllTarget.checked = false
    }

    const checkedIds = checked.map(checkbox => checkbox.dataset.journeyId)

    this.journeyIdsTargets.forEach(el => {
      el.value = checkedIds
    })
    this.updateSelectedCount()
  }

  checkedCheckboxes() {
    return this.checkboxTargets.filter(cb => cb.checked)
  }

  updateSelectedCount() {
    this.selectedCountTarget.innerHTML = this.toggleAllTarget.checked ? this.toggleAllTarget.dataset.count : this.checkedCheckboxes().length.toString()
  }
}

