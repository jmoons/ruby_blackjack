require './deck.rb'

class Blackjack
  ACE_VALUE_LOW   = 1
  ACE_VALUE_HIGH  = 11
  FACE_CARD_VALUE = 10
  BLACKJACK_VALUE = 21

  def initialize(number_of_decks: 1)
    @game_deck    = generate_game_deck(number_of_decks)
    @keep_playing = true
    play_hand
  end
  
  private

  def play_hand
    mutable_deck = @game_deck.dup
    current_hand = {:player => [], :house => []}
    current_hand = deal_cards(mutable_deck, 2, current_hand)
    display_status(current_hand)
  end

  def display_status(current_hand)
    puts "YOU: #{current_hand[:player]}"
    puts "YOU: #{card_hand_sum(current_hand[:player])}"
    puts "House: #{current_hand[:house].inspect}"
    puts "House: #{card_hand_sum(current_hand[:house])}"

  end

  def card_hand_sum(card_hand)
    sum     = 0
    has_ace = false

    card_hand.each do |card|
      if (card.number.is_a? Numeric)
        sum += card.number
      elsif (card.number.downcase == "ace")
        ( (sum + ACE_VALUE_HIGH) <= BLACKJACK_VALUE ) ? sum += ACE_VALUE_HIGH : sum += ACE_VALUE_LOW
        has_ace = true
      else
        sum += 10
      end
    end

    if (sum > BLACKJACK_VALUE && has_ace)
      sum -= ACE_VALUE_HIGH
      sum += ACE_VALUE_LOW
    end

    sum
  end

  def play_series_of_hands
    while( @keep_playing ) do
      prompt_to_continue
    end
  end

  def deal_cards(mutable_deck, number_of_cards_to_deal, current_hand)
    (1 .. number_of_cards_to_deal).each do |card_deal|
      current_hand[:player] << mutable_deck.shift
      current_hand[:house] << mutable_deck.shift
    end
    current_hand
  end

  def prompt_to_continue
    puts "Do you wish to play again?"
    user_response = gets.chomp.downcase
    @keep_playing = false if user_response == "n"
  end

  def generate_game_deck(number_of_decks)
    (1 .. number_of_decks).map{ |deck_number| Deck.new.shuffled_deck }.flatten
  end
end

Blackjack.new

