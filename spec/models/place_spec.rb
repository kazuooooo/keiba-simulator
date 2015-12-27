require 'rails_helper'

RSpec.describe Place, type: :model do
  before do
    @place = Place.create(name: "東京")
    @race1 = @place.races.build(date: '2001-12-01', race_num: 1)
    @race1.save
    # binding.pry
  end

  describe "create" do
    it "1つできている" do
      expect(@place.races[0].race_num).to eq 1
    end
  end

  describe "relation" do
    it "配列がかえる" do
      expect(@place.races.exists?).to(be_truthy)
    end
    it "型検証してみる" do
      expect(@place.races[0]).to be_kind_of(Race)
    end
  end

  describe "search" do
    it "検索で見つけられる" do
      expect(Place.find_by(name: "東京").name).to eq "東京"
    end
  end

  describe "destroy" do
    it "削除できる" do
      expect(@place.races.count).to eq 1
      @race1.destroy
      expect(@place.races.count).to eq 0
    end
  end
end
