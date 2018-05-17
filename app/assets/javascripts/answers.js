document.addEventListener('DOMContentLoaded',() => {
  let question = findQuestion()
  if (question) {
    App.cable.subscriptions.create('AnswersChannel', {
      connected: function() {
        this.perform('follow', {id: question.dataset.id})
      },
      received: function(data) {
        let newAnswer = JST['templates/answer']({
          answer: data['answer'],
          votes: data['votes'],
          comments: data['comments'],
          partial_attachements: function() {
            return this.safe(JST['templates/attachements']({
              attachements: data['attachements']
            }))
          },
          partial_editable_attachements: function() {
            return this.safe(JST['templates/editable_attachements']({
              resource_type: 'answer',
              attachements: data['attachements']
            }))
          },
          partial_comments: function() {
            return this.safe(JST['templates/comments']({
              resource_type: 'answer',
              resource: data['answer'],
              comments: data['comments']
            }))
          },
        })

        let answer = findAnswer(data['answer'].id)
        createOrUpdateElement({
          id: data['answer'].id,
          element: answer,
          elements: document.querySelector('.answers'),
          newElement: newAnswer,
          findMethod: 'findAnswer'
        })
      }
    })
  }

  let newAnswer = document.querySelector('#new-answer')
  if (newAnswer) {
    listenCreateSuccessEvent(newAnswer)
  }
})

findAnswer = (id) => document.querySelector(`.answer[data-id='${id}']`)

function newOuterHtmlOfAnswerChild(params) {
  let element = findAnswer(params.id).querySelector(params.childSelector)
  if (element) {
    element.outerHTML = params.html
  }
}

function updateEditAnswerForm(id, html) {
  newOuterHtmlOfAnswerChild({id:id, childSelector:'.form-edit-answer', html:html})
}

function updateAnswerBody(answer, text = '') {
  answer.querySelector('.body').textContent = text
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
