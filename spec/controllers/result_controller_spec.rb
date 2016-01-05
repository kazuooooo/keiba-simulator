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
      @horceresults = @controller.get_target_horce_results(@date_from, @date_to, @place, @popularity)
    end

    it "件数が正しい" do
      expect(@horceresults.size).to eq(24)
    end

    describe "正しいデータを取得している" do
      it "場所が正しい" do
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

  describe "#simulate_races" do
    before do
      @date_from = Date.new(2015, 8, 1)
      @date_to = Date.new(2015, 8, 1)
      @place = "札幌"
      @popularity = 1
      @horceresults = @controller.get_target_horce_results(@date_from, @date_to, @place, @popularity)
    end

    describe "複数のborder値で正しい結果を返す" do

      example "0の場合" do
        result = @controller.simulate_races(@horceresults, 0)
        expect(result).to eq(80)
      end

      example "2.1の場合" do
        result = @controller.simulate_races(@horceresults, 2.1)
        expect(result).to eq(150)
      end

      example "3.2の場合" do
        result = @controller.simulate_races(@horceresults, 3.2)
        expect(result).to eq(380)
      end

    end
  end
end
