class PokerHand
  CARD_PATTERN = /\A[SHDC]([1-9]|1[0-3])\z/.freeze

  attr_reader :cards

  def initialize(cards)
    @cards = cards.split
  end

  def valid?
    correct_card_count? && valid_card_format? && no_duplicate_cards?
  end

  def errors
    error_messages = []
    error_messages << '5枚のカードを入力してください。' unless correct_card_count?

    invalid_cards = cards.reject { |card| card.match?(CARD_PATTERN) }
    invalid_cards.each do |invalid_card|
      error_messages << "#{invalid_card}は正しい形式ではありません。"
    end

    duplicate_cards = cards.select { |card| cards.count(card) > 1 }.uniq
    duplicate_cards.each do |duplicate_card|
      error_messages << "#{duplicate_card}は重複しています。"
    end

    error_messages
  end

  def hand_rank
    evaluator = PokerHandEvaluator.new(@cards)
    evaluator.hand_rank
  end

  private

  def correct_card_count?
    cards.size == 5
  end

  def valid_card_format?
    cards.all? { |card| card.match?(CARD_PATTERN) }
  end

  def no_duplicate_cards?
    cards.uniq.length == cards.length
  end
end
