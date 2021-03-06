require "spec_helper"

describe EventMachine::Campfire do
  
  before :each do
    stub_rooms_data_request
  end
    
  describe "#initialize" do
    it "should work with valid params" do
      EM.run_block { a(EM::Campfire).should be_a(EM::Campfire) }
    end
    
    it "should warn if given an option it doesn't know" do
      mock_logger
      EM.run_block { a(EM::Campfire, :fred => "estaire").should be_a(EM::Campfire) }
      logger_output.should =~ /WARN.*em-campfire initialized with :fred => "estaire" but NO UNDERSTAND!/
    end
    
    it "should require essential parameters" do
      lambda { EM::Campfire.new }.should raise_error(ArgumentError, "You must pass an API key")
      lambda { EM::Campfire.new(:api_key => "foo") }.should raise_error(ArgumentError, "You must pass a subdomain")
    end
  end
  
  describe "#verbose" do
    it "should default to false" do
      EM.run_block { a(EM::Campfire).verbose.should be_false }
    end
    
    it "should be overridable at initialization" do
      EM.run_block { a(EM::Campfire, :verbose => true).verbose.should be_true }
    end
  end
  
  describe "#logger" do
    context "default logger" do
      before { EM.run_block { @adaptor = a EM::Campfire } }
      
      it { @adaptor.logger.should be_a(Logger) }
      it { @adaptor.logger.level.should be == Logger::INFO }
    end
    
    context "default logger in verbose mode" do
      before { EM.run_block { @adaptor = a EM::Campfire, :verbose => true } }
      
      it { @adaptor.logger.level.should be == Logger::DEBUG }
    end
    
    context "overriding default" do
      before do
        @custom_logger = Logger.new("/dev/null")
        EM.run_block { @adaptor = a EM::Campfire, :logger => @custom_logger }
      end
      
      it { @adaptor.logger.should be == @custom_logger }
    end
  end
end

