document.addEventListener('DOMContentLoaded',() => {
  document.querySelectorAll('.follow').forEach((link) => subscribesLinks(link))
})

function subscribesLinks(link) {
  link.addEventListener('ajax:success', () => {
    if (link.datast.method == 'delete') {
      console.log('was post now delete')
    } else {
      console.log('was delete now post')
    }
  })
}
