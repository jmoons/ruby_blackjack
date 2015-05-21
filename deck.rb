require './card.rb'

class Deck
  attr_reader :shuffled_deck

  SUITS   = ["Clubs", "Diamonds", "Hearts", "Spades"]
  NUMBERS = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"]

  def initialize
    @deck           = get_full_deck.flatten
    @shuffled_deck  = @deck.shuffle
  end

  private

  def get_full_deck
    SUITS.map{ |suit| NUMBERS.map{ |number| Card.new(suit: suit, number: number) } }
  end
end