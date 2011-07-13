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