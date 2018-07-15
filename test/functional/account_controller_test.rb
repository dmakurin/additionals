require File.expand_path('../../test_helper', __FILE__)

class AccountControllerTest < ActionController::TestCase
  fixtures :users, :email_addresses, :roles

  def setup
    Setting.default_language = 'en'
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end

  def test_get_login_with_welcome_text
    Setting.plugin_additionals = ActionController::Parameters.new(
      account_login_bottom: 'Lore impsuum'
    )
    get :login
    assert_response :success
    assert_template 'login'

    assert_select 'input[name=username]'
    assert_select 'input[name=password]'
    assert_select 'div.login-additionals', text: /Lore impsuum/
  end

  def test_get_login_without_welcome_text
    Setting.plugin_additionals = ActionController::Parameters.new(
      account_login_bottom: ''
    )

    get :login
    assert_response :success
    assert_template 'login'

    assert_select 'input[name=username]'
    assert_select 'input[name=password]'
    assert_select 'div.login-additionals', count: 0
  end

  # See integration/account_test.rb for the full test
  def test_post_register_with_registration_on
    with_settings self_registration: '3' do
      assert_difference 'User.count' do
        post :register,
             params: { user: { login: 'register',
                               password: 'secret123',
                               password_confirmation: 'secret123',
                               firstname: 'John',
                               lastname: 'Doe',
                               mail: 'register@example.com' } }
        assert_redirected_to '/my/account'
      end
      user = User.order(id: :desc).first
      assert_equal 'register', user.login
      assert_equal 'John', user.firstname
      assert_equal 'Doe', user.lastname
      assert_equal 'register@example.com', user.mail
      assert user.check_password?('secret123')
      assert user.active?
    end
  end
end
