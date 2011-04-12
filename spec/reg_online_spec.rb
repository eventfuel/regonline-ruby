require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RegonlineRuby" do

  VCR.config do |c|
    c.cassette_library_dir = 'spec/vcr_cassettes'
    c.stub_with :webmock
  end

  it "fails without regonline username/password" do
    lambda { RegOnline.new({})}.should raise_error(ArgumentError,"username and password required")
  end

  it "fails on an unregistered user" do
    VCR.use_cassette('regonline_request') do
      reg = RegOnline.new(:username => 'foo',
                        :password => 'bar')
      result = reg.get_custom_user_info("reg id here"){|custom_info| fail "Invalid user should not call block"}
      result.should be_false
      end
  end
  
  it "confirms user registration and provides registrant information" do
    VCR.use_cassette('regonline_request') do
      reg = RegOnline.new(:username => 'foo',
                          :password => 'bar')
      
      result = reg.get_custom_user_info("79964") do |custom_info|
        custom_info["Twitter_x0020_Username"].should == "@thedude"
      end
      result.should be_true
    end
  end
  
end
