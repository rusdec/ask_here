document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.vote a').forEach((vote) => {
    vote.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      if (response.data.errors) {
        showErrors(response.data.errors)
      } else {
        updateVotesRate({element: vote, rate: response.data.votes.rate})
        updateVotes(vote)
      }
    })
  })
})

function updateVotesRate(params) {
  let rate = params.element.parentNode.querySelector('[data-vote="rate"]')
  if (rate) {
    rate.textContent = params.rate
  }
}

function updateVotes(vote) {
  let votePair = votePairFor(vote)
  switch(vote.dataset.method) {
    case 'post':
    case 'patch':
      updateVotesMethods([{vote: vote, method: 'delete'},{vote: votePair, method: 'patch'}])
      updateVotesMarkers([vote, votePair])
      break
    case 'delete':
      updateVotesMethods([{vote: vote, method: 'post'},{vote: votePair, method: 'post'}])
      updateVotesMarkers([vote, votePair])
      break
  }
}

function updateVotesMarkers(votes) {
  votes.filter(vote => {
    vote.dataset.method == 'delete' ? vote.classList.add('red')
                                    : vote.classList.remove('red')
  })
}

function updateVotesMethods(elements) {
  elements.forEach(element => element.vote.dataset.method = element.method)
}

function votePairFor(vote) {
  let votePairDict = { like: 'dislike', dislike: 'like' }
  let pair = votePairDict[vote.dataset.vote]
  return vote.parentNode.querySelector('[data-vote="'+pair+'"]')
}
