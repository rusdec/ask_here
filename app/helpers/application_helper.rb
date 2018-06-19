module ApplicationHelper
  def header_cache_key
    "header-#{auth_state}"
  end

  def auth_state
    current_user ? 'auth' : 'not_auth'
  end
end
