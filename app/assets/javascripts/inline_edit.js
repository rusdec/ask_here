document.addEventListener('DOMContentLoaded', () => {
  let editableElements = findEditableElements()
  if (editableElements) {
    [
      'listenClickDeleteLink',
      'listenClickEditLink',
      'listenClickCancelLink',
      'listenUpdateSuccessEvent'
    ].forEach(callback => listenFor(editableElements, callback))
  }
})

function listenFor(elements, callback) {
  elements.forEach(element => this[callback](element))
}

function listenUpdateSuccessEvent(element) {
  element.querySelector('form').addEventListener('ajax:success', (ev) => {
    toggleEditVisibility(element)
  })
}

function listenClickDeleteLink(element) {
  element.querySelector('.link-delete').addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) {
      showErrors(response.data.errors)
    } else {
      removeComment(element)
    }
  })
}

function removeComment(element = false) {
  if (element) {
    element.remove()
  }
}

function findEditableElements() {
  let elements = []
  document.querySelectorAll('.inline-edit-mode').forEach(edit => elements.push(edit.parentNode))
  return elements
}

function listenClickCancelLink(element) {
  element.querySelector('.link-cancel').addEventListener('click', () => toggleEditVisibility(element))
}

function listenClickEditLink(element) {
  element.querySelector('.link-edit').addEventListener('click', () => toggleEditVisibility(element))
}

function toggleEditVisibility(element) {
  [
    '.inline-edit-mode',
    '.inline-edit-data',
    '.link-cancel',
    '.link-edit'
  ].forEach(selector => {
    element.querySelector(selector).classList.toggle('hidden')
  })
}
