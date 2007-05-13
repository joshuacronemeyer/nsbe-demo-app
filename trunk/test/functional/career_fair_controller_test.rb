require File.dirname(__FILE__) + '/../test_helper'
require 'career_fair_controller'

# Re-raise errors caught by the controller.
class CareerFairController; def rescue_action(e) raise e end; end

class CareerFairControllerTest < Test::Unit::TestCase
  def setup
    @controller = CareerFairController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
