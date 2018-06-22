document.addEventListener('DOMContentLoaded',() => {
  document.querySelectorAll('.subscribes-links a').forEach((link) => initSubscribeLink(link))
})

function initSubscribeLink(link) {
  link.addEventListener('ajax:success', (response) => {
    response = parseAjaxResponse(response)
    if (response.data.errors) {
      showErrors(response.data.errors)
      return false
    }

    let parentNode = link.parentNode
    let newLink
    switch (link.dataset.method) {
      case 'post':
        newLink = JST['templates/subscriptions/unfollow_link']({
          subscription: response.data.subscription
        })
        break;
      case 'delete':
        newLink = JST['templates/subscriptions/follow_link']({
          subscribable: response.data.subscribable
        })
        break;
      default:
        return false
        break;
    }

    showNewLink(newLink)
    initSubscribeLink(parentNode.querySelector('a'))
  })
}

function showNewLink(newLink) {
  let linksContainer = document.querySelector('.subscribes-links .container-link')
  if (!linksContainer) {
    return false
  }
  linksContainer.innerHTML = newLink;
}
