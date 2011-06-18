require 'spec_helper'

describe "Service" do
  it "should have http://api.polleverywhere.com/ as url" do
    PollEverywhere.service.url.to_s.should eql("http://api.polleverywhere.com/")
  end
end

describe "Multiple Choice Poll" do
  context "serialize" do
    before(:all) do
      @hash = {:title => 'Hey dude!', :options => %w[red blue green]}
      @poll = PollEverywhere::MultipleChoicePoll.from_hash(@hash)
    end

    context "serialization" do
      it "should serialize options" do
        @hash[:options].each do |value|
          @poll.to_hash[:multiple_choice_poll][:options].find{|o| o[:value] == value }.should_not be_nil
        end
      end
    end

    context "deserialization" do
      it "should have options" do
        @hash[:options].each do |value|
          @poll.options.find{|o| o.value == value }
        end
      end

      it "should set title" do
        @poll.title.should eql(@hash[:title])
      end
    end
  end
end

describe "http" do
  context "request builder" do
    # it "should post" do
    #   PollEverywhere::HTTP::RequestBuilder.new.post('some data').to('/this/url').response do |response|
    #     response.body.should eql('hello my pretty')
    #     response.status.should eql(200)
    #   end
    # end

    # it "should put" do
    #   PollEverywhere::HTTP::RequestBuilder.new.put('some data').to('/this/url').response do |response|
    #     response.body.should eql('hello my pretty')
    #     response.status.should eql(200)
    #   end
    # end

    # it "should delete" do
    #   PollEverywhere::HTTP::RequestBuilder.new.delete.from('/this/url').response do |response|
    #     response.body.should eql('hello my pretty')
    #     response.status.should eql(200)
    #   end
    # end

    # it "should get" do
    #   PollEverywhere::HTTP::RequestBuilder.new.get(:page => 1).from('/this/url').response do |response|
    #     response.body.should eql('hello my pretty')
    #     response.status.should eql(200)
    #   end
    # end
  end
end