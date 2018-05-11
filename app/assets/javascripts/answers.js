function findAnswer(id) {
  return document.querySelector(`.answer[data-id='${id}']`)
}

function newOuterHtmlOfAnswerChild(params) {
  let element = findAnswer(params.id).querySelector(params.childSelector)
  if (element) {
    element.outerHTML = params.html
  }
}

function updateEditAnswerForm(id, html) {
  newOuterHtmlOfAnswerChild({id:id, childSelector:'.form-edit-answer', html:html})
}

function updateAnswerBody(id, text = '') {
  findAnswer(id).querySelector('.body').textContent = text
}

function updateAnswerAttachements(id, html) {
  newOuterHtmlOfAnswerChild({id:id, childSelector:'.answer_attachements', html:html})
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
