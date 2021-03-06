require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::Google" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::Google.new :parent=>@parent, :key=>'abc'
      a.tracking_command_location.should == :head_append
    end
    it 'should set the options' do
      a = Analytical::Modules::Google.new :parent=>@parent, :key=>'abc'
      a.options.should == {:key=>'abc', :parent=>@parent}
    end
  end
  describe '#track' do
    it 'should return the tracking javascript' do
      @api = Analytical::Modules::Google.new :parent=>@parent, :key=>'abcdef'
      @api.track.should == "_gaq.push(['_trackPageview']);"
      @api.track('pagename', {:some=>'data'}).should ==  "_gaq.push(['_trackPageview', \"pagename\"]);"
    end
  end
  describe '#event' do
    it 'should return the event javascript' do
      @api = Analytical::Modules::Google.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename').should ==  "_gaq.push(['_trackEvent', \"Event\", \"pagename\"]);"
    end
    
    it 'should include data value' do
      @api = Analytical::Modules::Google.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', {:value=>555, :more=>'info'}).should ==  "_gaq.push(['_trackEvent', \"Event\", \"pagename\", 555]);"
    end
    it 'should not include data if there is no value' do
      @api = Analytical::Modules::Google.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', {:more=>'info'}).should ==  "_gaq.push(['_trackEvent', \"Event\", \"pagename\"]);"
    end
    it 'should not include data if it is not a hash' do
      @api = Analytical::Modules::Google.new :parent=>@parent, :key=>'abcdef'
      @api.event('pagename', 555).should ==  "_gaq.push(['_trackEvent', \"Event\", \"pagename\", 555]);"
    end

  end
  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::Google.new :parent=>@parent, :key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should =~ /abcdef/
      @api.init_javascript(:head_append).should =~ /google-analytics.com\/ga.js/
      @api.init_javascript(:body_prepend).should == ''
      @api.init_javascript(:body_append).should == ''
    end
  end
end