require 'test_helper.rb'

class TestAuthentication < Test::Unit::TestCase

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
      "protonet",
      "protonet"
    )
    
    assert Protolink::Protonet.open(@api_server, "admin@protonet.local", "protonet")
  end

  def test_sign_up
    # user = Protolink::Protonet.open(@api_server, nil, nil).sign_up
    
  end

end