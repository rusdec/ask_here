function toggleVisible(element) {
  if (element) {
    element.classList.toggle('hidden')
  }
}

function toggleVisibleElements(elements) {
  elements.forEach((element) => toggleVisible(element))
}
