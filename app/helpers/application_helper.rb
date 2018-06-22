module ApplicationHelper
  def sign_out_text(user)
    "Sign out (#{user.email})"
  end
end
