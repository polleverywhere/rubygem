require 'spec_helper'

describe PollEverywhere::Models::Participant do
  before(:all) do
    @p = PollEverywhere::Models::Participant.from_hash(:email => 'brad@brad.com')
  end

  context "email path" do
    it "should have current email if not commited" do
      @p.path.should eql('/participants/brad@brad.com')
    end

    it "should have old email if committed" do
      @p.save
      @p.email = 'super.duper@something.com'
      @p.path.should eql('/participants/brad@brad.com')
    end

    it "should change email with old email in path" do
      @p.save
      @p.email = 'i.like.emails@something.com'
      @p.path.should eql('/participants/super.duper@something.com')
    end
  end
end