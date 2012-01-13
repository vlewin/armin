require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class ServiceTest < Test::Unit::TestCase
  context "Service Model" do
    should 'construct new instance' do
      @service = Service.new
      assert_not_nil @service
    end
  end
end
