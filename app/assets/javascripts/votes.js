function updateVote(params) {
  let voteSelector = `#vote_${params.votableType}_${params.votableId}`
  document.querySelector(voteSelector).outerHTML = params.html
}
