require 'spec_helper'

describe "API", :type => :request do
  context "polls" do
    it "should get collection from my poll" do
      expect(PollEverywhere::Models::Poll.all.size).to be >= 1
    end

    context "multiple choice" do
      before do
        @mcp = PollEverywhere::MultipleChoicePoll.from_hash(:title => 'Hey dude!', :options => %w[red blue green])
      end
      after do
        @mcp.destroy if @mcp.id
      end

      context "creation" do
        before do
          @mcp.save
        end

        it "should have id" do
          expect(@mcp.id).not_to be_nil
        end

        it "should have permalink" do
          expect(@mcp.permalink).not_to be_nil
        end

        context "options" do
          it "should have ids" do
            @mcp.options.each do |o|
              expect(o.id).not_to be_nil
            end
          end

          it "should have values" do
            @mcp.options.each do |o|
              expect(o.value).not_to be_nil
            end
          end
        end
      end

      context "get" do
        it "should get poll" do
          @mcp.save
          @gotten_mcp = PollEverywhere::MultipleChoicePoll.get(@mcp.permalink)
          expect(@gotten_mcp.title).to eql(@mcp.title)
        end
      end

      context "updates" do
        before do
          @mcp.title = "My pita bread is moldy"
          @mcp.options.first.value = "MOLD SUCKS!"
          @mcp.save
        end

        it "should update options" do
          expect(@mcp.options.first.value).to eql("MOLD SUCKS!")
        end

        it "should update title" do
          expect(@mcp.title).to eql("My pita bread is moldy")
        end

        it "should start" do
          @mcp.start
          expect(@mcp.state).to eql("opened")
        end

        it "should stop" do
          @mcp.stop
          expect(@mcp.state).to eql("closed")
        end
      end

      it "should retrieve results" do
        @mcp.save

        expect {
          JSON.parse @mcp.results
        }.to_not raise_error
      end

      it "should clear results" do
        @mcp.save
        expect(@mcp.clear).to be_truthy
      end

      it "should archive results" do
        @mcp.save
        expect(@mcp.archive).to be_truthy
      end

      it "should destroy" do
        @mcp.destroy
        expect(@mcp.id).to be_nil
      end
    end

    context "free text" do
      before do
        @ftp = PollEverywhere::FreeTextPoll.from_hash(:title => 'Got feedback?')
      end
      after do
        @ftp.destroy if @ftp.id
      end

      context "creation" do
        before do
          @ftp.save
        end

        it "should have id" do
          expect(@ftp.id).not_to be_nil
        end

        it "should have permalink" do
          expect(@ftp.permalink).not_to be_nil
        end
      end

      context "get" do
        it "should get poll" do
          @ftp.save
          @gotten_ftp = PollEverywhere::FreeTextPoll.get(@ftp.permalink)
          expect(@gotten_ftp.title).to eql(@ftp.title)
        end
      end

      context "updates" do
        before do
          @ftp.title = "My pita bread is moldy"
          @ftp.save
        end

        it "should update title" do
          expect(@ftp.title).to eql("My pita bread is moldy")
        end

        it "should start" do
          @ftp.start
          expect(@ftp.state).to eql("opened")
        end

        it "should stop" do
          @ftp.stop
          expect(@ftp.state).to eql("closed")
        end
      end

      it "should retrieve results" do
        @ftp.save

        expect {
          JSON.parse @ftp.results
        }.to_not raise_error
      end

      it "should clear results" do
        @ftp.save
        expect(@ftp.clear).to be_truthy
      end

      it "should archive results" do
        @ftp.save
        expect(@ftp.archive).to be_truthy
      end

      it "should destroy" do
        @ftp.destroy
        expect(@ftp.id).to be_nil
      end
    end

  end
end
