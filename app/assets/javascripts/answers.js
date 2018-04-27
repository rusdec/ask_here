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
  let linkEditAnswer = findAnswer(id).querySelector('.link-edit-answer')
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

function findEditAnswerForm(id) {
  return findAnswer(id).querySelector('.form-edit-answer')
}

function updateEditAnswerForm(id, form) {
  let editAnswerForm = findEditAnswerForm(id)
  if (editAnswerForm) {
    editAnswerForm.outerHTML = form
  }
}

function updateAnswerBody(id, body) {
  let answerBody = findAnswer(id).querySelector('.body')
  if (answerBody) {
    answerBody.textContent = body
  }
}

function updateAnswerAttachements(id, attachements) {
  let answerAttachements = findAnswer(id).querySelector('.answer_attachements')
  if (answerAttachements) {
    answerAttachements.outerHTML = attachements
  }
}

function toggleVisibleAnswer(id) {
  toggleVisibleElements([
    findEditAnswerForm(id),
    findAnswer(id).querySelector('.data')
  ])
}

/*
 * BestAnswer
 */

function choseBestAnswer(id) {
  unsetBestUnswer()
  updateBestAnswerMarker(findAnswer(id), 'best_answer')
  placeBestAnswerOnTop()
}

function unsetBestUnswer() {
  updateBestAnswerMarker(findBestAnswer())
}

function findBestAnswer() {
  return document.querySelector('#best_answer')
}

function placeBestAnswerOnTop() {
  let answers = document.querySelector('.answers')
  if (answers) {
    answers.insertAdjacentElement('afterbegin', findBestAnswer())
  }
}

function updateBestAnswerMarker(answer, marker = '') {
  if (answer) {
    toggleVisibleBestButtonAnswer(answer.dataset.id)
    answer.id = marker
  }
}

function toggleVisibleBestButtonAnswer(id) {
  toggleVisibleElements([
    findAnswer(id).querySelector('.link-set-as-best-answer'),
    findAnswer(id).querySelector('.link-unset-best-answer')
  ])
}
