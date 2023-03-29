require 'rails_helper'

RSpec.describe PokerService do
  let(:service) { PokerService.new(cards) }

  describe '#call' do
    context 'when cards are valid' do
      let(:cards) { 'S1 S2 S3 S4 S5' }

      it 'returns the hand_rank' do
        result = service.call
        expect(result[:hand]).to eq 'ストレートフラッシュ'
        expect(result[:errors]).to be_nil
      end
    end

    context 'when cards are invalid' do
      let(:cards) { 'S1 S2 S3 S4' } # only 4 cards

      it 'returns an error message' do
        result = service.call
        expect(result[:hand]).to be_nil
        expect(result[:errors]).to include '5枚のカードを入力してください。'
      end
    end
  end
end
