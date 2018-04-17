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

function findBestAnswers() {
  return document.querySelectorAll('.best_answer')
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
  let editAnswerForm = findEditAnswerForm(id) 
  let answerRemoteLinks = findAnswerRemoteLinks(id)
  let answer = findAnswerData(id)

  if (answerRemoteLinks) {
    toggleVisible(answerRemoteLinks)
  }

  if (editAnswerForm) {
    toggleVisible(editAnswerForm)
  }

  if (answer) {
    toggleVisible(answer)
  }
}
