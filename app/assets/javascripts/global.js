function toggleVisible(element) {
  if (element) {
    element.classList.toggle('hidden')
  }
}

function toggleVisibleElements(elements) {
  elements.forEach((element) => toggleVisible(element))
}

function parseAjaxResponse(e) {
  return { data: e.detail[0], status: e.detail[1], response: e.detail[2] }
}

function clearErrors(container) {
  if (container) {
    container.innerHTML = ''
  }
}

function showErrors(errors = [], container) {
  container = container || document.querySelector('div.alert')
  if (container && errors) {
    clearErrors(container)
    errors.forEach((error) => {
      let p = document.createElement('p')
      p.textContent = error
      container.appendChild(p)
    })
  }
}
