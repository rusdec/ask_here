function updateVote(params) {
  let vote = document.querySelector(`#vote-${params.votableType}-${params.votableId}`)
  if (vote) {
    vote.outerHTML = params.html
  }
}
