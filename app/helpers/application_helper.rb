module ApplicationHelper
  def sign_out_text(user)
    "Sign out (#{user.email})"
  end
  
  def header_cache_key
    "header-#{auth_state}"
  end

  def auth_state
    current_user ? 'auth' : 'not_auth'
  end
end
