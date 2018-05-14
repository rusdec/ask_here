document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.votes .vote').forEach((vote) => listenVoteClick(vote))
})

function listenVoteClick(vote) {
  if (!vote) {
    return
  }
  vote.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) {
      showErrors(response.data.errors)
    } else {
      updateVotesRate({element: vote, rate: response.data.votes.rate})
      updateVotes(vote)
    }
  })
}

function updateVotesRate(params) {
  let rate = params.element.parentNode.querySelector('[data-vote="rate"]')
  if (rate) {
    rate.textContent = params.rate
  }
}

function updateVotes(vote) {
  updateVotesMethods(vote, findVotesIn(vote.parentNode))
  updateVotesMarkers(findVotesIn(vote.parentNode))
}

function updateVotesMarkers(votes) {
  votes.forEach(vote => {
    vote.dataset.method == 'delete' ? vote.classList.add('red')
                                    : vote.classList.remove('red')
  })
}

function updateVotesMethods(vote, votes = []) {
  let inverseMethodsDict = {post: 'delete', delete: 'post'}
  votes.forEach(element => {
    if (element != vote) {
      element.dataset.method = 'post'
    }
  })
  vote.dataset.method = inverseMethodsDict[vote.dataset.method]
}

function findVotesIn(element) {
  return element.querySelectorAll('.vote')
}
