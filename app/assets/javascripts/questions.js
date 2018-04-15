document.addEventListener('DOMContentLoaded',() => {
  let linkEditQuestion = document.querySelector('.question-remote-links .link-edit-question')
  let linkCancelEditQuestion = document.querySelector('.form-edit-question .link-cancel-edit-question')

  if (linkEditQuestion) {
    linkEditQuestion.addEventListener('click', () => { toggleVisibleQuestion() })
  }

  if (linkCancelEditQuestion) {
    linkCancelEditQuestion.addEventListener('click', () => { toggleVisibleQuestion() })
  }
})

function toggleVisibleQuestion() {
  let formEditQuestion = document.querySelector('.form-edit-question')
  let question = document.querySelector('.question')

  if (formEditQuestion) {
    toggleVisible(formEditQuestion)
  }

  if (question) {
    toggleVisible(question)
  }
}
