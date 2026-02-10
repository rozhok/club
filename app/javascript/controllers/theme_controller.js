import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "toggle" ];

  connect() {
    const savedTheme = localStorage.getItem("theme") || "light";
    const theme = savedTheme || this.getSystemTheme();

    this.applyTheme(theme);

    this.toggleTarget.checked = (theme === "dark");
  }

  toggle(event) {
    const theme = event.target.checked ? "dark" : "light"
    this.applyTheme(theme);
  }

  applyTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme);
    localStorage.setItem("theme", theme);
  }

  getSystemTheme() {
    if (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) {
      return "dark";
    }
    return "light";
  }
}