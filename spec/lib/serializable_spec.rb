require 'spec_helper'

describe PollEverywhere::Serializable do
  class Animal
    include PollEverywhere::Serializable

    prop :color
    prop :smell
    prop :name
  end

  class Furry < Animal
    prop :fuzzy
  end

  before(:all) do
    @bear = Furry.new.from_hash({
      :fuzzy => true,
      :name => 'Bear',
      :small => 'awful',
      :color => 'black'
    })
  end

  context "property inheritence" do
    it "should have subclass property" do
      @bear.fuzzy.should be_true
    end

    it "should have superclass property" do
      @bear.color.should eql('black')
    end
  end

  context "property changes" do
    it "should be changed" do
      @bear.color = 'brown'
      @bear.should be_changed
    end
  end

  context "commit" do
    before(:all) do
      @bear.color = "red"
      @bear.value_set.commit
    end

    it "should not be changed after commit" do
      @bear.should_not be_changed
    end

    it "should have set current value as old value" do
      @bear.prop(:color).was.should eql('red')
    end

    it "should have current value" do
      @bear.prop(:color).is.should eql('red')
    end

    it "should not modify the old value" do
      @bear.color = "green"
      @bear.prop('color').was.should eql('red')
      @bear.prop('color').is.should eql('green')
    end
  end
end

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
      @value.should be_changed
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
        @value.should_not be_changed
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
  before(:all) do
    @propset = PollEverywhere::Serializable::Property::Set.new
  end

  it "should return properties for attributes" do
    @propset[:first_name].should be_instance_of(PollEverywhere::Serializable::Property)
  end

  it "should return a Value::Set" do
    @propset.value_set.should be_instance_of(PollEverywhere::Serializable::Property::Value::Set)
  end
end

describe PollEverywhere::Serializable::Property::Value::Set do
  context "changes" do
    before(:each) do
      @prop = PollEverywhere::Serializable::Property.new(:email)
      @value_set = PollEverywhere::Serializable::Property::Value::Set.new(@prop.value)
    end

    context "property value" do
      before(:each) do
        @value_set[:email] = 'brad@bradgessler.com'
      end

      it "should have the current value" do
        @value_set[:email].should eql('brad@bradgessler.com')
      end

      it "should have the original value" do
        @value_set.prop(:email).was.should be_nil
      end

      it "should have changes for property value" do
        was, is = @value_set.prop(:email).changes
        was.should be_nil
        is.should eql('brad@bradgessler.com')
      end

      it "should have changed" do
        @value_set.prop(:email).should be_changed
      end
    end

    context "hash" do
      it "should return hash of changed value" do
        @value_set[:email] = 'brad@bradgessler.com'
        @value_set.changes[:email].should eql([nil, 'brad@bradgessler.com'])
      end
    end
  end
end