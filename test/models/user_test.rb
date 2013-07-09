require "test_helper"

describe User do
  it "must be valid" do
    user = create(:user)
    user.valid?.must_equal true
  end

  it "fails when username is too short" do
    user = build(:user, username: 'foo')
    user.valid?.must_equal false
  end

  it 'fails when username is not unique' do
    user1 = create(:user)
    user2 = build(:user, username: user1.username)
    user1.valid?.must_equal true
    user2.valid?.must_equal false
  end
end
