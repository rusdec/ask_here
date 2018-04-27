document.addEventListener('DOMContentLoaded', () => {
  listenClickLinkEditAnswers()
  listenClickLinkCancelEditAnswers()
})

function listenClickAnswerLinksForToggling(linkSelector) {
  let links = document.querySelectorAll(linkSelector)
  links.forEach((link) => {
    let answerId = link.parentElement.dataset.answerId
    link.addEventListener('click', () => { toggleVisibleAnswer(answerId) })
  })
}

function listenClickAnswerLinkForToggling(id, linkSelector) {
  let link = findAnswer(id).querySelector(selector)
  if (link) {
    link.addEventListener('click', () => { toggleVisibleAnswer(id) })
  }
}

function listenClickLinkCancelEditAnswers() {
  listenClickAnswerLinksForToggling('.link-cancel-edit-answer')
}

function listenClickLinkEditAnswers() {
  listenClickAnswerLinksForToggling('.link-edit-answer')
}

function listenClickLinkEditAnswer(id) {
  listenClickAnswerLinkForToggling(id, '.link-edit-answer')
}

function listenClickLinkCancelEditAnswer(id) {
  listenClickAnswerLinkForToggling(id, '.link-cancel-edit-answer')
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
