require 'rails_helper'

RSpec.describe PokerHand, type: :model do
  describe '#hand_rank' do
    it 'returns ストレートフラッシュ for a straight flush' do
      hand = PokerHand.new('S1 S2 S3 S4 S5')
      expect(hand.hand_rank).to eq 'ストレートフラッシュ'
    end

    it 'returns フォーカード for a four of a kind' do
      hand = PokerHand.new('S1 H1 D1 C1 S5')
      expect(hand.hand_rank).to eq 'フォーカード'
    end

    it 'returns フルハウス for a full house' do
      hand = PokerHand.new('S1 H1 D1 S2 H2')
      expect(hand.hand_rank).to eq 'フルハウス'
    end

    it 'returns フラッシュ for a flush' do
      hand = PokerHand.new('S1 S7 S10 S11 S13')
      expect(hand.hand_rank).to eq 'フラッシュ'
    end

    it 'returns ストレート for a straight' do
      hand = PokerHand.new('S1 H2 D3 C4 S5')
      expect(hand.hand_rank).to eq 'ストレート'
    end

    it 'returns スリーカード for a three of a kind' do
      hand = PokerHand.new('S1 H1 D1 C2 S3')
      expect(hand.hand_rank).to eq 'スリーカード'
    end

    it 'returns ツーペア for a two pair' do
      hand = PokerHand.new('S1 H1 D2 C2 S3')
      expect(hand.hand_rank).to eq 'ツーペア'
    end

    it 'returns ワンペア for a one pair' do
      hand = PokerHand.new('S1 H1 D2 C3 S4')
      expect(hand.hand_rank).to eq 'ワンペア'
    end

    it 'returns ノーペア for a no pair' do
      hand = PokerHand.new('S11 H2 D3 C4 S5')
      expect(hand.hand_rank).to eq 'ノーペア'
    end
  end
end
