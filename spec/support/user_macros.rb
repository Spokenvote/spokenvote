module UserMacros
  def sign_in_as_a_valid_user
    @user ||= FactoryGirl.create(:user)

    case self.class.metadata[:type]
    when :request
      post_via_redirect(user_session_path, "user[email]" => @user.email, "user[password]" => @user.password)
    when :feature
      visit user_session_path
      fill_in("user_email", :with => @user.email)
      fill_in("user_password", :with => @user.password)
      click_button "Sign in"
    end
  end
end
