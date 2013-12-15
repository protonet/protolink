$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require "rubygems"
require "protolink"
require "test/unit"

# change this if you need to connect to another server
require "./lib/protolink.rb"
PTN_SERVER = "http://localhost:3001"
PTN_USER   = "ali.jelveh"
PTN_PASS   = "something"
protonet = Protolink::Protonet.open(PTN_SERVER, PTN_USER, PTN_PASS)
user = protonet.find_user_by_username("first_name.last_name")
user.subscribed_projects.first.create_topic("foonar")

class TestAll < Test::Unit::TestCase
  
  def teardown
    protonet = Protolink::Protonet.open(PTN_SERVER, PTN_USER, PTN_PASS)
    user_1 = protonet.find_user_by_username("first_name.last_name")
    # user_3 = protonet.find_user_by_username("test_2")
    # user_4 = protonet.find_user_by_username("test_3")

    # project = protonet.find_rendezvous(user_3.id, user_1.id)
    # project && project.delete!

    user_1.destroy!
    # user_3.delete!
    # user_4.delete!
    # ["test_foobar", "test_foobar_2"].each do |project_name|
      # protonet.find_project_by_name(project_name).delete! rescue nil
    # end
    
  end
  
  def test_all
    protonet = Protolink::Protonet.open(PTN_SERVER, PTN_USER, PTN_PASS)
    assert protonet, "Couldn't create connection instance"
    
    user_1 = protonet.create_user(:first_name => 'first_name', :last_name => 'last_name', :email => 'test@test.com', :password => 'geheim12')
    p user_1
    assert user_1.is_a?(Protolink::User), "Couldn't create user"
    assert_equal 'first_name.last_name', user_1.username
    assert_equal 'test@test.com', user_1.email

    assert_raise(Protolink::Protonet::ApiException) {
      protonet.create_user(:first_name => 'first_name', :last_name => 'last_name', :email => 'test@test.com')
    }

    # we're still subscribing to the default project
    assert_equal 1, user_1.subscribed_projects.size

    project = protonet.create_project("foobar")

    project.subscribe_user(user_1)

    assert user_1.projects.detect {|user_project| user_project.id == project.id}

    project.topics

    topic = projects.create_topic

    project.topics == +1

    project = protonet.find_project_by_name(name)

    topic = protonet.find_topic(id)

    topic = project.find_topic_by_name(name)

    topic.send_meep("foobar")

    topic.meeps

    protonet.meeps(:stream_id, :lt, :gt, :limit)

    topic.destroy!

    project.meeps(options)

    project.unsubscribe_user(user_1)

    project.destroy!

    # user_1.private_chat_with(user_2)
    # user_1.private_chat_with(user_2).say("")

    # user_1.private_chats
        
  end
end