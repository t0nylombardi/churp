import { Controller } from "@hotwired/stimulus"
import Tribute from "tributejs"
import Trix from "trix"

export default class extends Controller {
  static targets = [ "field" ]

  connect() {
    this.initializeTribute()
  }

  disconnect() {
    this.tribute.detach(this.fieldTarget)
  }

  get editor() {
    return this.element.editor
  }

  initializeTribute() {
    this.tribute = new Tribute({
      allowSpaces: true,
      lookup: 'username',
      values: this.fetchUsers,
      menuItemTemplate(item) {
        return `<div class="mentionsListContainer">
                <div class="mentions-list-centered">
                  <div class="flex flex-row">
                    <img class="w-10 h-10 rounded-full" src="${item.original.profile_pic}" alt="${item.original.name}"/>
                    <div class="flex flex-col ml-2">
                      <h1 class="mentions-list-header">
                        ${item.original.name}
                      </h1>
                      <p class="text-gray-400 text-sm">${item.original.username}</p>
                    </div>
                  </div>
                </div>
              </div>`
      },
    })
    this.tribute.attach(this.fieldTarget)
    this.tribute.range.pasteHtml = this._pasteHtml.bind(this)
    this.fieldTarget.addEventListener("tribute-replaced", this.replaced)
  }

  fetchUsers(text, callback) {
    fetch(`/mentions.json?query=${text}`)
      .then(response => response.json())
      .then(users => callback(users))
      .catch(error => callback([]))
  }

  replaced(e) {
    let mention = e.detail.item.original
    let attachment = new Trix.Attachment({
      sgid: mention.sgid,
      content: mention.content,
      contentType : 'inline-element mention'
    })
    this.editor.insertAttachment(attachment)
    this.editor.insertString(" ")
  }

  _pasteHtml(html, startPos, endPos) {
    let range = this.editor.getSelectedRange()
    let position = range[0]
    let length = endPos - startPos
    this.editor.setSelectedRange([range[0] - length, range[0]])
    this.editor.deleteInDirection("backward")
  }
}