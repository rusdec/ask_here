document.addEventListener('DOMContentLoaded',() => {
  let linkEditAnswer = document.querySelector('.answer-remote-links .link-edit-answer')
  let answerId = linkEditAnswer.parentElement.dataset.answerId
  let linkCancelEditAnswer = document.querySelector('.form-edit-answer .link-cancel-edit-answer')

  if (linkEditAnswer) {
    linkEditAnswer.addEventListener('click', () => { toggleVisibleAnswer(answerId) })
  }

  if (linkCancelEditAnswer) {
    linkCancelEditAnswer.addEventListener('click', () => { toggleVisibleAnswer(answerId) })
  }
})

function findAnswersContainer() {
  return document.querySelector('.answers')
}

function findAnswer(id) {
  return document.querySelector(`.answer[data-id='${id}']`)
}

function findBestAnswers() {
  return document.querySelectorAll('.best_answer')
}

function findBestAnswer() {
  let id = document.querySelector('.best_answer').dataset.id
  return findAnswer(id)
}

function placeBestAnswerOnTop() {
  findAnswersContainer().insertAdjacentElement('afterbegin', findBestAnswer())
}

function removeBestAnswerSelectors() {
  findBestAnswers().forEach((e) => e.remove())
}

function findEditAnswerForm(id) {
  return document.querySelector(`.answer[data-id='${id}'] .form-edit-answer`)
}

function findAnswerData(id) {
  return document.querySelector(`.answer[data-id='${id}'] p.body`)
}

function findAnswerRemoteLinks(id) {
  return document.querySelector(`.answer[data-id='${id}'] .answer-remote-links`)
}

function toggleVisibleAnswer(id) {
  [
    findEditAnswerForm(id),
    findAnswerRemoteLinks(id),
    findAnswerData(id)
  ].forEach((element) => {
    if (element) {
      toggleVisible(element)
    }
  })
}
