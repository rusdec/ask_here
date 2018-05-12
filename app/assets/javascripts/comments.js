document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.new-comment').forEach((newCommentForm) => {
    newCommentForm.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      if (response.data.errors) {
        showErrors(response.data.errors, '.question .new-comment-errors')
      } else {
        // todo: add comment
        console.log(response.data)
      }
    })
  })
})
