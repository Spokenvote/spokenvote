module ControllerMacros
  module ClassMethods
    def login_admin
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in FactoryGirl.create(:admin) # Using factory girl as an example
      end
    end

    def login_user
      let(:user) { create(:user) }

      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end
    end
  end

  module InstanceMethods
    def login_with_user(user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end
end