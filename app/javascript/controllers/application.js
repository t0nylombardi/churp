import { Application } from "@hotwired/stimulus"
import NestedForm from 'stimulus-rails-nested-form'

const application = Application.start()
application.register('nested-form', NestedForm)
// const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
