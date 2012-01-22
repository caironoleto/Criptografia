require 'spec_helper'
require 'dictionary'

describe Dictionary do
  subject do
    described_class.new(:a => 'b', :b => 'c')
  end

  it 'should recognize an list with definitions' do
    subject.dictionary.should == {:a => 'b', :b => 'c'}
  end
  
  describe "#[]" do
    it "should return an definition" do
      subject[:a].should eql 'b'
    end

    it "should return nil when not find any definition" do
      subject[:e].should be_nil
    end
  end

  describe "#key" do
    it "should return the key of an definition from value" do
      subject.key('b').should eql :a
    end

    it "should return nil when not find any key from value" do
      subject.key('f').should be_nil
    end
  end

  describe "#include?" do
    it "should return an existent value for a definition" do
      subject.include?('b').should be_true
    end

    it "should return false when not have any value for a definition" do
      subject.include?('f').should_not be_true
    end
  end
end
