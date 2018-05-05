document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.vote a').forEach((link) => {
    link.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      if (response.data.errors) {
        showErrors(response.data.errors)
      } else {
        updateVotesRate({element: link, rate: response.data.votes.rate})
        switchVoteMethod(link)
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

function switchVoteMethod(vote) {
  switch(vote.dataset.method) {
    case 'post':
      inversePair(vote)
    case 'patch':
      break
    case 'delete':
      resetPair(vote)
      break
  }
}

function inversePair(vote) {
  inverseMarker(vote)
  inverseMethods({vote: vote, methods: {vote: 'delete', pair: 'patch'}})
}

function resetPair(vote) {
  [vote, votePairFor(vote)].forEach(v => resetMarker(v))
  inverseMethods({vote: vote, methods: {vote: 'post', pair: 'post'}})
}

function inverseMethods(params) {
  updateVoteMethod({vote: params.vote, method: params.methods.vote})
  updateVoteMethod({vote: votePairFor(params.vote), method: params.methods.pair})
}

function inverseMarker(vote) {
  vote.classList.add('red')
  resetMarker(votePairFor(vote))
}

function resetMarker(vote) {
  vote.classList.remove('red')
}

function updateVoteMethod(params) {
  params.vote.dataset.method = params.method
}

function votePairFor(vote) {
  let votePairDict = { like: 'dislike', dislike: 'like' }
  let pair = votePairDict[vote.dataset.vote]
  return vote.parentNode.querySelector('[data-vote="'+pair+'"]')
}
