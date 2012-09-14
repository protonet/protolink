require 'test_helper.rb'

class TestAuthentication < Test::Unit::TestCase

  def teardown
    protonet = Protolink::Protonet.open(@api_server, @api_user, "admin")
    user_1 = protonet.find_user_by_login("some.dude")
    user_1.delete! if user_1
  end

  def test_auth
    assert_nil Protolink::Protonet.open(@api_server, nil, nil).auth
    assert Protolink::Protonet.open(@api_server, @api_user, @api_pass).auth
  end

  def test_reset_password
    assert_nil Protolink::Protonet.open(@api_server, nil, nil).reset_password(nil)
    response = Protolink::Protonet.open(@api_server, nil, nil).reset_password("admin@protonet.local")
    reset_password_token = response["reset_password_token"] 
    assert reset_password_token

    assert_nil Protolink::Protonet.open(@api_server, nil, nil).reset_password!("token", "pw", "pw")

    assert Protolink::Protonet.open(@api_server, nil, nil).reset_password!(
      reset_password_token,
      "admin",
      "admin"
    )

    assert Protolink::Protonet.open(@api_server, "admin@protonet.local", "protonet")
  end

  def test_sign_up
    response = Protolink::Protonet.open(@api_server, nil, nil).sign_up(
      :user => {
        :first_name => "Some",
        :last_name => "Dude",
        :password => "password",
        :email => "some.dude@example.com"
      }
    )
    assert_equal Protolink::User, response.class

    response = Protolink::Protonet.open(@api_server, nil, nil).sign_up(
      :user => {
        :first_name => "Some",
        :last_name => "Dude",
        :email => "some.dude2@example.com"
      }
    )
    assert_equal ["can't be blank"], response[:errors]["password"]
  end

end