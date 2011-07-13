require 'spec_helper'


describe PollEverywhere::Serializable::Property do
  before(:all) do
    @prop = PollEverywhere::Serializable::Property.new(:field)
  end

  context "value" do
    before(:each) do
      @value = @prop.value
    end
    
    it "should detect changes" do
      @value.current = "super fun times"
      @value.should have_changed
    end

    it "should maintain original value" do
      @value.current = "flimtastical"
      @value.original.should be_nil
    end

    context "after commit" do
      before(:each) do
        @value.current = "dog treats"
        @value.commit
      end

      it "should not be changed" do
        @value.should_not have_changed
      end

      it "should have original value" do
        @value.current.should eql("dog treats")
      end

      it "should have current value" do
        @value.current.should eql("dog treats")
      end
    end
  end
end

describe PollEverywhere::Serializable::Property::Set do
  it "should initialize a Value::Set from a list properties" do
    # Property::Set.new.values ...
    pending
  end
end

describe PollEverywhere::Serializable::Property::Value::Set do
  context "changes" do
    it "should return true/false if a specific attribute is dirty"
    it "should retrieve the original value"
    it "should retrieve the current value"
    it "should not allow direct chagnes to the original value"
  end
end