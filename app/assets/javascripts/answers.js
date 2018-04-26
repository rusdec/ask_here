document.addEventListener('DOMContentLoaded', () => {
  listenClickLinkEditAnswers()
  listenClickLinkCancelEditAnswers()
})

function listenClickLinkEditAnswers() {
  let linksEditAnswer = document.querySelectorAll('.link-edit-answer')
  if (linksEditAnswer) {
    linksEditAnswer.forEach((linkEditAnswer) => {
      let answerId = linkEditAnswer.parentElement.dataset.answerId
      linkEditAnswer.addEventListener('click', () => { toggleVisibleAnswer(answerId) })
    })
  }
}

function listenClickLinkEditAnswer(id) {
  let linkEditAnswer = findAnswerRemoteLinks(id).querySelector('.link-edit-answer')
  if (linkEditAnswer) {
    linkEditAnswer.addEventListener('click', () => { toggleVisibleAnswer(id) })
  }
}

function listenClickLinkCancelEditAnswer(id) {
  let linkCancelEditAnswer = findEditAnswerForm(id).querySelector('.link-cancel-edit-answer')
  if (linkCancelEditAnswer) {
    linkCancelEditAnswer.addEventListener('click', () => { toggleVisibleAnswer(id) })
  }
}

function listenClickLinkCancelEditAnswers() {
  let linksCancelEditAnswer = document.querySelectorAll('.link-cancel-edit-answer')
  if (linksCancelEditAnswer) {
    linksCancelEditAnswer.forEach((linkCancelEditAnswer) => {
      let answerId = linkCancelEditAnswer.dataset.answerId
      linkCancelEditAnswer.addEventListener('click', () => { toggleVisibleAnswer(answerId) })
    })
  }
}

function findAnswer(id) {
  return document.querySelector(`.answer[data-id='${id}']`)
}

function findAnswersContainer() {
  return document.querySelector('.answers')
}

function findAnswerAttachements(id) {
  return findAnswer(id).querySelector('.answer_attachements')
}

function findEditAnswerForm(id) {
  return findAnswer(id).querySelector('.form-edit-answer')
}

function findAnswerData(id) {
  return findAnswer(id).querySelector('p.body')
}

function findAnswerRemoteLinks(id) {
  return findAnswer(id).querySelector('.answer-remote-links')
}

function findAnswerSetAsBestAnswerLink(id) {
  return findAnswerRemoteLinks(id).querySelector('.link-set-as-best-answer')
}

function findAnswerUnsetBestAnswerLink(id) {
  return findAnswerRemoteLinks(id).querySelector('.link-unset-best-answer')
}

function updateEditAnswerForm(id, form) {
  let editAnswerForm = findEditAnswerForm(id)
  if (editAnswerForm) {
    editAnswerForm.outerHTML = form
  }
}

function updateAnswerAttachements(id, attachements) {
  let answerAttachements = findAnswerAttachements(id)
  if (answerAttachements) {
    answerAttachements.outerHTML = attachements
  }
}

function toggleVisibleAnswer(id) {
  let elements = [
    findEditAnswerForm(id),
    findAnswerRemoteLinks(id),
    findAnswerData(id),
    findAnswerAttachements(id)
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
