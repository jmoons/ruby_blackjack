class Card
  attr_reader :suit, :number
  def initialize(card_options)
    @suit   = card_options[:suit]
    @number = card_options[:number]
  end
end