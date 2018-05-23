document.addEventListener('DOMContentLoaded', () => {
  let newComments = document.querySelectorAll('.new-comment')
  newComments.forEach(newComment => listenCreateSuccessEvent(newComment))

  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      document.querySelectorAll('.question-container .question, .answer').forEach(commentable => {
        this.perform('follow', {
          commentable_id: commentable.dataset.id,
          commentable_type: commentable.classList[0]
        })
      })
    },
    received: function(data) {
      let newComment = JST['templates/comments/comment']({comment: data['comment']})
      let comment = findComment(data['comment'].id)
      createOrUpdateElement({
        id: data['comment'].id,
        element: comment,
        elements: findCommentsContainer(extractCommentableSelector(data)),
        newElement: newComment,
        findMethod: 'findComment'
      })
    }
  })
})

findComment = (id) => document.querySelector(`.comment[data-id="${id}"]`)
findCommentsContainer = (type) => document.querySelector(`${type} .comments`)
extractCommentableSelector = (data) => `.${data.commentable_type}[data-id="${data.commentable_id}"]`
