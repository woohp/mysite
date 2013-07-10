require "test_helper"

describe UtilsController do
  it "should get secure_random" do
    get :secure_random
    assert_response :success
  end

end
