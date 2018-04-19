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

function findAnswer(id) {
  return document.querySelector(`.answer[data-id='${id}']`)
}

function findAnswersContainer() {
  return document.querySelector('.answers')
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

function findAnswerSetAsBestAnswerLink(id) {
  return document.querySelector(`.answer[data-id='${id}'] .link-set-as-best-answer`)
}

function findAnswerUnsetBestAnswerLink(id) {
  return document.querySelector(`.answer[data-id='${id}'] .link-unset-best-answer`)
}

function toggleVisibleAnswer(id) {
  let elements = [
    findEditAnswerForm(id),
    findAnswerRemoteLinks(id),
    findAnswerData(id)
  ]
  
  elements.forEach((element) => toggleVisible(element))
}

/*
 * BestAnswer
 */

function choseBestAnswer(id) {
  removeBestAnswer()
  newBestAnswer(id)
  placeBestAnswerOnTop()
}

function findBestAnswer() {
  return document.querySelector('#best_answer')
}

function placeBestAnswerOnTop() {
  let answers = findAnswersContainer()
  if (answers) {
    answers.insertAdjacentElement('afterbegin', findBestAnswer())
  }
}

function newBestAnswer(id) {
  let answer = findAnswer(id)
  if (answer) {
    togglebVisibleBestButtonAnswer(answer.dataset.id)
    findAnswer(id).id = 'best_answer'
  }
}

function removeBestAnswer() {
  let answer = findBestAnswer()
  if (answer) {
    togglebVisibleBestButtonAnswer(answer.dataset.id)
    answer.id = ''
  }
}

function togglebVisibleBestButtonAnswer(id) {
  toggleVisible(findAnswerSetAsBestAnswerLink(id))
  toggleVisible(findAnswerUnsetBestAnswerLink(id))
}
