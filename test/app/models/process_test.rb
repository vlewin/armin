require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class ProcessTest < Test::Unit::TestCase
  context "Process Model" do
    should 'construct new instance' do
      @process = Process.new
      assert_not_nil @process
    end
  end
end
