module Feature
  module Signing
    def sign_in(user)
      visit '/sign_in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end
  end
end
