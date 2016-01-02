require 'rails_helper'

RSpec.describe ResultController, type: :controller do
  before do
    @controller = ResultController.new
  end

  describe "#get_target_horce_result" do
    before do
      @date_from = Date.new(2015, 4, 11)
      @date_to = Date.new(2015, 4, 12)
      @place = "福島"
      @popularity = 1
      @horceresults = @controller.get_target_horce_result(@date_from, @date_to, @place, @popularity)
    end

    it "件数が正しい" do
      expect(@horceresults.size).to eq(24)
    end

    describe "正しいデータを取得している" do
      it "場所が正しい" do
        # binding.pry
        expect(@horceresults.sample.race.place.name).to eq(@place)
      end

      it "人気順が正しい" do
        expect(@horceresults.sample.popularity).to eq(@popularity)
      end

      it '開催日が指定範囲内にある' do
        expect(@horceresults.sample.race.date).to be_between(@date_from, @date_to)
      end
    end
  end
end
