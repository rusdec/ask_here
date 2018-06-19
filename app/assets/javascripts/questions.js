document.addEventListener('DOMContentLoaded',() => {
  listenClickLinkEditQuestion()
  listenClickLinkCancelEditQuestion()

  if (document.querySelector('.questions')) {
    App.cable.subscriptions.create('QuestionsChannel', {
      connected: function() {
        this.perform('follow')
      },
      received: function(data) {
        appendQuestion(data)
      }
    })
  }
})

function appendQuestion(question) {
  let questions = document.querySelector('.questions')
  if (questions) {
    questions.insertAdjacentHTML('afterbegin', question)
  }
}

function listenClickLinkEditQuestion() {
  let linkEditQuestion = document.querySelector('.link-edit-question')
  if (linkEditQuestion) {
    linkEditQuestion.addEventListener('click', () => { toggleVisibleQuestion() })
  }
}

function listenClickLinkCancelEditQuestion() {
  let linkCancelEditQuestion = document.querySelector('.link-cancel-edit-question')
  if (linkCancelEditQuestion) {
    linkCancelEditQuestion.addEventListener('click', () => { toggleVisibleQuestion() })
  }
}

function updateQuestionErrors(errors = null) {
  let questionErrors = document.querySelector('.form-edit-question .errors')
  if (questionErrors) {
    questionErrors.innerHTML = ''
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

function updateQuestionEditForm(form) {
  let formEditQuestion = document.querySelector('.form-edit-question')
  if (formEditQuestion) {
    formEditQuestion.outerHTML = form
  }
}

function updateQuestionAttachements(attachements) {
  let questionAttachements = document.querySelector('.question .attachements')
  if (questionAttachements) {
    questionAttachements.outerHTML = attachements
  }
}

function findQuestionTitle() {
  return document.querySelector('.question .title')
}

function findQuestionBody() {
  return document.querySelector('.question .body')
}

function findQuestion() {
  return document.querySelector('.question')
}

function toggleVisibleQuestion() {
  toggleVisibleElements([
    document.querySelector('.form-edit-question'),
    document.querySelector('.question .data')
  ])
}
