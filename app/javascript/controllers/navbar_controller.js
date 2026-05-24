import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    const expanded = !this.menuTarget.classList.contains("hidden")
    this.element.querySelector('button[aria-controls="mobile-menu"]').setAttribute("aria-expanded", expanded)
  }
}
