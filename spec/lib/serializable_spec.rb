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
      expect(@bear.fuzzy).to be_truthy
    end

    it "should have superclass property" do
      expect(@bear.color).to eql('black')
    end
  end

  context "property changes" do
    it "should be changed" do
      @bear.color = 'brown'
      expect(@bear).to be_changed
    end
  end

  context "commit" do
    before(:all) do
      @bear.color = "red"
      @bear.value_set.commit
    end

    it "should not be changed after commit" do
      expect(@bear).not_to be_changed
    end

    it "should have set current value as old value" do
      expect(@bear.prop(:color).was).to eql('red')
    end

    it "should have current value" do
      expect(@bear.prop(:color).is).to eql('red')
    end

    it "should not modify the old value" do
      @bear.color = "green"
      expect(@bear.prop('color').was).to eql('red')
      expect(@bear.prop('color').is).to eql('green')
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
      expect(@value).to be_changed
    end

    it "should maintain original value" do
      @value.current = "flimtastical"
      expect(@value.original).to be_nil
    end

    context "after commit" do
      before(:each) do
        @value.current = "dog treats"
        @value.commit
      end

      it "should not be changed" do
        expect(@value).not_to be_changed
      end

      it "should have original value" do
        expect(@value.current).to eql("dog treats")
      end

      it "should have current value" do
        expect(@value.current).to eql("dog treats")
      end
    end
  end
end

describe PollEverywhere::Serializable::Property::Set do
  before(:all) do
    @propset = PollEverywhere::Serializable::Property::Set.new
  end

  it "should return properties for attributes" do
    expect(@propset[:first_name]).to be_instance_of(PollEverywhere::Serializable::Property)
  end

  it "should return a Value::Set" do
    expect(@propset.value_set).to be_instance_of(PollEverywhere::Serializable::Property::Value::Set)
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
        expect(@value_set[:email]).to eql('brad@bradgessler.com')
      end

      it "should have the original value" do
        expect(@value_set.prop(:email).was).to be_nil
      end

      it "should have changes for property value" do
        was, is = @value_set.prop(:email).changes
        expect(was).to be_nil
        expect(is).to eql('brad@bradgessler.com')
      end

      it "should have changed" do
        expect(@value_set.prop(:email)).to be_changed
      end
    end

    context "hash" do
      it "should return hash of changed value" do
        @value_set[:email] = 'brad@bradgessler.com'
        expect(@value_set.changes[:email]).to eql([nil, 'brad@bradgessler.com'])
      end
    end
  end
end