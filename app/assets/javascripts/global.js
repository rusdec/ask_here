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

function showErrors(errors = []) {
  let alerts = document.querySelector('div.alert')
  if (alerts && errors) {
    errors.forEach((error) => {
      let p = document.createElement('p')
      p.textContent = error
      alerts.appendChild(p)
    })
  }
}
