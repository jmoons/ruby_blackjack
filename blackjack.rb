require './deck.rb'

class Blackjack
  ACE_VALUE_LOW   = 1
  ACE_VALUE_HIGH  = 11
  FACE_CARD_VALUE = 10
  BLACKJACK_VALUE = 21

  def initialize(number_of_decks: 1)
    @game_deck    = generate_game_deck(number_of_decks)
    @mutable_deck = @game_deck.dup
    @keep_playing = true
    @current_hand = {:player => [], :house => []}
    play_hand
  end
  
  private

  def play_hand
    deal_initial_cards
    # Show cards
    # Prompt user for action
    # Hit - deal a card
    # Stand - play dealers hand
    display_status_hidden_dealer_card

    if play_players_hand
      #player busted
      print_busted_message("player")
      return
    end

    display_status_full

    if play_dealers_hand
      print_busted_message("dealer")
      return
    end

    determine_winner

  end

  def determine_winner
    if ( card_hand_sum(@current_hand[:player]) > card_hand_sum(@current_hand[:house]) )
      puts "Player Wins!"
    else
      puts "House Wins - DOH"
    end
  end

  def print_busted_message(who_busted)
    puts "#{who_busted} BUSTED."
  end

  def play_dealers_hand
    if card_hand_sum(@current_hand[:house]) < 17
      deal_card(:house)
      display_status_full
      return busted?(:house) if busted?(:house)
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
      return busted?(:player) if busted?(:player)
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
    puts "YOU: #{@current_hand[:player]}"
    puts "YOU: #{card_hand_sum(@current_hand[:player])}"
    puts "House: #{@current_hand[:house].inspect}"
    puts "House: #{card_hand_sum(@current_hand[:house])}"

  end

  def display_status_hidden_dealer_card
    puts "YOU: #{@current_hand[:player]}"
    puts "YOU: #{card_hand_sum(@current_hand[:player])}"
    puts "House: #{[@current_hand[:house][1]].inspect}"
    puts "House: #{card_hand_sum([@current_hand[:house][1]])}"

  end

  def busted?(target)
    if card_hand_sum(@current_hand[target]) > 21
      return true
    end

    return false
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

