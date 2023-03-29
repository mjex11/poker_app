class PokerService
  def initialize(cards)
    @poker_hand = PokerHand.new(cards)
  end

  def call
    if @poker_hand.valid?
      { hand: @poker_hand.hand_rank }
    else
      { errors: @poker_hand.errors }
    end
  end
end
