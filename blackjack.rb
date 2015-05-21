require './deck.rb'

class Blackjack
  def initialize(number_of_decks: 1)
    @game_deck    = generate_game_deck(number_of_decks)
    @keep_playing = true
    play_hand
  end
  
  private

  def play_hand
    while( @keep_playing ) do
      
      prompt_to_continue
    end
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