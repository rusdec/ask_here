document.addEventListener('DOMContentLoaded', () => {
  let newComments = document.querySelectorAll('.new-comment')
  if (!newComments) {
    return
  }
  newComments.forEach(newComment => listenCreateSuccessEvent(newComment, true))
 
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

  let newCommentLinks = document.querySelectorAll('.link-new-comment, .link-cancel-new-comment')
  if (newCommentLinks) {
    newCommentLinks.forEach((newCommentLink) => {
      newCommentLink.addEventListener('click', () => toggleNewCommentVisibility({
        commentableId: newCommentLink.dataset.commentableId,
        commentableClass: newCommentLink.dataset.commentableClass
      }))
    })
  }

})

findComment = (id) => document.querySelector(`.comment[data-id="${id}"]`)
findCommentsContainer = (type) => document.querySelector(`${type} .comments`)
extractCommentableSelector = (data) => `.${data.commentable_type}[data-id="${data.commentable_id}"]`

function toggleNewCommentVisibility(params) {
  let container = document.querySelector(`.${params.commentableClass}[data-id="${params.commentableId}"]`)
  let newCommentForm = container.querySelector('.new-comment')
  let newCommentLink = container.querySelector('.link-new-comment')

  if (newCommentLink && newCommentForm) {
    newCommentForm.classList.toggle('hidden')
    newCommentLink.classList.toggle('hidden')
  }
}
