require './deck.rb'

class BustedException < RuntimeError
  def initialize
  end
end

class Blackjack
  ACE_VALUE_LOW     = 1
  ACE_VALUE_HIGH    = 11
  FACE_CARD_VALUE   = 10
  BLACKJACK_VALUE   = 21
  HOUSE_HOLD_AMOUNT = 17
  RESHUFFLE_TRIGGER  = 0.3

  def initialize(number_of_decks: 1)
    @number_of_decks  = number_of_decks
    @keep_playing     = true

    begin_session
  end
  
  private

  def begin_session
    reshuffle
    while @keep_playing do
      puts "Deck Stats - TotalCards: #{@game_deck.length}, RemainingCards: #{@mutable_deck.length}, Div: #{(@mutable_deck.length / @game_deck.length.to_f)}"
      reshuffle if check_for_reshuffle
      play_hand
      check_to_continue
    end
  end

  def check_to_continue
    puts "Play Again (y or n)?"
    response = gets.chomp.downcase

    if response == "n"
      @keep_playing = false
    elsif response == "y"
      return
    else
      check_to_continue
    end
  end

  def check_for_reshuffle
    (@mutable_deck.length / @game_deck.length.to_f) <= RESHUFFLE_TRIGGER
  end

  def reshuffle
    puts "RESHUFFLING!"
    @game_deck    = generate_game_deck(@number_of_decks)
    @mutable_deck = @game_deck.dup
  end

  def play_hand
    @current_hand = {:player => [], :house => []}
    deal_initial_cards

    display_status_hidden_dealer_card

    begin
      play_players_hand
    rescue BustedException
      print_busted_message("player")
      return
    end

    display_status_full

    begin
      play_dealers_hand
    rescue BustedException
      print_busted_message("dealer")
      return
    end

    determine_winner

  end

  def determine_winner
    if ( card_hand_sum(@current_hand[:player]) > card_hand_sum(@current_hand[:house]) )
      puts "Player Wins!"
    elsif ( card_hand_sum(@current_hand[:player]) == card_hand_sum(@current_hand[:house]) )
      puts "Push - No winner, no loser. How Zen."
    else
      puts "House Wins - DOH"
    end
  end

  def print_busted_message(who_busted)
    puts "#{who_busted} BUSTED."
  end

  def play_dealers_hand
    if card_hand_sum(@current_hand[:house]) < HOUSE_HOLD_AMOUNT
      deal_card(:house)
      display_status_full
      raise BustedException.new if busted?(:house)
      play_dealers_hand
    else
      return false
    end
  end

  def play_players_hand
    puts "Hit or Stand?"
    response = gets.chomp.downcase

    if response == "h"
      deal_card(:player)
      display_status_hidden_dealer_card
      raise BustedException.new if busted?(:player)
      play_players_hand
    elsif response == "s"
      return false
    else
      play_players_hand
    end
  end

  def deal_initial_cards
    (1 .. 2).each do |card|
      deal_card(:player)
      deal_card(:house)
    end

  end

  def prompt_player
    puts "Hit or Stand?"
    gets.chomp.downcase
  end

  def display_status_full
    puts "You: #{@current_hand[:player].map{|card| "#{card.number}-#{card.suit}"}}"
    puts "YOU: #{card_hand_sum(@current_hand[:player])}"
    puts "House: #{@current_hand[:house].map{|card| "#{card.number}-#{card.suit}"}}"
    puts "House: #{card_hand_sum(@current_hand[:house])}"

  end

  def display_status_hidden_dealer_card
    puts "You: #{@current_hand[:player].map{|card| "#{card.number}-#{card.suit}"}}"
    puts "YOU: #{card_hand_sum(@current_hand[:player])}"
    puts "House: #{[@current_hand[:house][1]].map{|card| "#{card.number}-#{card.suit}"}}"
    puts "House: #{card_hand_sum([@current_hand[:house][1]])}"

  end

  def busted?(target)
    if card_hand_sum(@current_hand[target]) > BLACKJACK_VALUE
      return true
    end

    return false
  end

  def card_hand_sum(card_hand)
    sum     = 0
    has_high_ace = false

    card_hand.each do |card|
      if (card.number.is_a? Numeric)
        sum += card.number
      elsif (card.number.downcase == "ace")
        if (sum + ACE_VALUE_HIGH) <= BLACKJACK_VALUE
          sum += ACE_VALUE_HIGH
          has_high_ace = true
        else
          sum += ACE_VALUE_LOW
        end
      else
        sum += FACE_CARD_VALUE
      end
    end

    if (sum > BLACKJACK_VALUE && has_high_ace)
      sum -= ACE_VALUE_HIGH
      sum += ACE_VALUE_LOW
      has_high_ace = false
    end

    sum
  end

  def play_series_of_hands
    while( @keep_playing ) do
      prompt_to_continue
    end
  end

  def deal_card(target)
    @current_hand[target] << @mutable_deck.shift
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

