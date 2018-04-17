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


function updateQuestionErrors(errors = null) {
  let questionErrors = document.querySelector('#question_errors')

  if (questionErrors) {
    questionErrors.childNodes.forEach((node) => node.remove())
    if (errors) {
      questionErrors.insertAdjacentHTML('afterbegin', errors)
    }
  }
}

function updateQuestionBody(body) {
  let questionBody = findQuestionBody()
  if (questionBody) {
    questionBody.textContent = body
  }
}

function updateQuestionTitle(title) {
  let questionTitle = findQuestionTitle()
  if (questionTitle) {
    questionTitle.textContent = title
  }
}

function findQuestionTitle() {
  return document.querySelector('.question .title')
}

function findQuestionBody() {
  return document.querySelector('.question .body')
}

function toggleVisibleQuestion() {
  let elements = [
    document.querySelector('.form-edit-question'),
    document.querySelector('.question')
  ]

  elements.forEach((element) => {
    if (element)
      toggleVisible(element)
  })
}
