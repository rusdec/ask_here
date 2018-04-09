module Signing
  def sign_up(params)
    visit new_user_registration_path
    fill_in 'Email', with: params[:email]
    fill_in 'Password', with: params[:password]
    fill_in 'Password confirmation', with: params[:password_confirmation]
    click_on 'Sign up'
  end
end
