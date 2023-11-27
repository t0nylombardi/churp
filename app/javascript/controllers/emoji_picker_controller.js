import { Controller } from "@hotwired/stimulus";
import { Picker } from 'emoji-mart'

// Connects to data-controller="emoji-picker"
export default class extends Controller {
  static targets = ["trixEditor", "pickerContainer"];

  connect() {
    const trigger = document.querySelector('.trix-button');

    const pickerOptions = {
      theme: 'dark',
      previewPosition: 'none',
      onEmojiSelect: (emoji) => {
        this.trixEditorTarget.editor.insertHTML(emoji.native);
        this.trixEditorTarget.editor.expandSelectionInDirection('forward');
        picker.remove()
      },
      onClickOutside: () => {
        picker.remove()
      },
      data: () => fetch('https://cdn.jsdelivr.net/npm/@emoji-mart/data')
                  .then(res => res.json()),
    }
    const picker = new Picker(pickerOptions)

    trigger.addEventListener("click", (e) => {
      this.pickerContainerTarget.appendChild(picker)
    });

  }

}
