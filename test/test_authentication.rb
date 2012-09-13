require 'test_helper.rb'

class TestAuthentication < Test::Unit::TestCase

  def test_auth
    assert_nil Protolink::Protonet.open(@api_server, nil, nil).auth
    assert Protolink::Protonet.open(@api_server, @api_user, @api_pass).auth
  end

  def test_reset_password
    assert_nil Protolink::Protonet.open(@api_server, nil, nil).reset_password(nil)
    assert Protolink::Protonet.open(@api_server, nil, nil).reset_password("admin@protonet.local")
  end

  def test_sign_up
    user = Protolink::Protonet.open(@api_server, nil, nil).sign_up
    
  end

end