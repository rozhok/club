import { Controller } from "@hotwired/stimulus"
import EditorJS from "@editorjs/editorjs"
import Header from "@editorjs/header"
import List from "@editorjs/list"
import Quote from "@editorjs/quote"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!";
  }
}
