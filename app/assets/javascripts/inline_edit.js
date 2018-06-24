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

listenFor = (elements, callback) => { elements.forEach(element => this[callback](element)) }

function listenCreateSuccessEvent(element) {
  element.querySelector('form').addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) {
      showErrors(response.data.errors, findErrorsContainer(element))
    } else {
      element.querySelector('form').classList.toggle('hidden')
    }
  })

}

function listenUpdateSuccessEvent(element, callbacks = []) {
  element.querySelector('form').addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) {
      showErrors(response.data.errors, findErrorsContainer(element))
    } else {
      toggleEditVisibility(element)
    }
    callbacks.forEach(callback => this[callback.name](element, callback.params))
  })
}

function listenClickDeleteLink(element, errorsContainer = false) {
  element.querySelector('.link-delete').addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) {
      showErrors(response.data.errors, errorsContainer)
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

findErrorsContainer = (element) => element.querySelector('.errors')

/**
 * @param {Object} params
 * @param {string} params.id - value of data-id of baseElement X 
 * @param {Object} params.element - any baseElement X
 * @param {Object} params.elements - any baseElement Y who contain baseElements X
 * @param {Object} params.newElement - any baseElement Xi
 * @param {string} params.findMethod - metnod name which find baseElement X
*/
function createOrUpdateElement(params) {
  if (params.element) {
    // update
    params.element.outerHTML = params.newElement
  } else {
    //create
    params.elements.insertAdjacentHTML('beforeend', params.newElement)
  }
  element = this[params.findMethod](params.id)

  if (element) {
    listenClickEditLink(element)
    listenClickCancelLink(element)
    listenClickDeleteLink(element)
    listenUpdateSuccessEvent(element)
  }
}
