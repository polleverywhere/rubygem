require 'spec_helper'

describe "API" do
  context "polls" do
    it "should get collection from my poll" do
      PollEverywhere::Models::Poll.all.should have_at_least(1).items
    end

    context "multiple choice" do
      before(:all) do
        @mcp = PollEverywhere::MultipleChoicePoll.from_hash(:title => 'Hey dude!', :options => %w[red blue green])
      end

      context "creation" do
        before(:all) do
          @mcp.save
        end

        it "should have id" do
          @mcp.id.should_not be_nil
        end

        it "should have permalink" do
          @mcp.permalink.should_not be_nil
        end

        context "options" do
          it "should have ids" do
            @mcp.options.each do |o|
              o.id.should_not be_nil
            end
          end

          it "should have values" do
            @mcp.options.each do |o|
              o.value.should_not be_nil
            end
          end
        end
      end

      context "get" do
        it "should get poll" do
          @gotten_mcp = PollEverywhere::MultipleChoicePoll.get(@mcp.permalink)
          @gotten_mcp.title.should eql(@mcp.title)
        end
      end
      
      context "updates" do
        before(:all) do
          @mcp.title = "My pita bread is moldy"
          @mcp.options.first.value = "MOLD SUCKS!"
          @mcp.save
        end

        it "should update options" do
          @mcp.options.first.value.should eql("MOLD SUCKS!")
        end
        
        it "should update title" do
          @mcp.title.should eql("My pita bread is moldy")
        end

        it "should start" do
          @mcp.start
          @mcp.state.should eql("opened")
        end

        it "should stop" do
          @mcp.stop
          @mcp.state.should eql("closed")
        end
      end

      it "should clear results" do
        @mcp.save
        @mcp.clear.should be_true
      end

      it "should destroy" do
        @mcp.destroy
        @mcp.id.should be_nil
      end
    end

  end
end