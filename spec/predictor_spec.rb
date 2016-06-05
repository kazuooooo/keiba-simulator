require 'rails_helper'
describe Predictor do
  describe '#predict' do
    it 'it return Array' do
      result = Predictor.predict("hoge")
      expect(result).to be_kind_of(Array)
    end
  end
end