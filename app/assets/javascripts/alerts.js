document.addEventListener('DOMContentLoaded',() => {
  document.querySelectorAll('.alert').forEach((e) => closeAlert(e))
})

function closeAlert(e) {
  setTimeout(function(){ $(e).alert('close') }, 5000);
}
