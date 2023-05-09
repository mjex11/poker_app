class PokerHandEvaluator
  def initialize(cards)
    @cards = cards
  end

  def hand_rank
    if straight? && flush?
      'ストレートフラッシュ'
    elsif n_of_a_kind?(4)
      'フォーカード'
    elsif full_house?
      'フルハウス'
    elsif flush?
      'フラッシュ'
    elsif straight?
      'ストレート'
    elsif n_of_a_kind?(3)
      'スリーカード'
    elsif n_of_a_kind?(2) && card_ranks.group_by(&:itself).values.count { |group| group.size == 2 } == 2
      'ツーペア'
    elsif n_of_a_kind?(2)
      'ワンペア'
    else
      'ノーペア'
    end
  end

  private

  def card_ranks
    @cards.map { |card| card[1..].to_i }
  end

  def card_suits
    @cards.pluck(0)
  end

  def n_of_a_kind?(num)
    card_ranks.group_by(&:itself).values.any? { |group| group.size == num }
  end

  def straight?
    card_ranks.minmax.inject(:-).abs == 4 && card_ranks.uniq.size == 5
  end

  def flush?
    card_suits.uniq.size == 1
  end

  def full_house?
    three_of_a_kind? && two_of_a_kind?
  end

  def three_of_a_kind?
    n_of_a_kind?(3)
  end

  def two_of_a_kind?
    n_of_a_kind?(2)
  end
end
