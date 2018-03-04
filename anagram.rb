require 'test/unit'

class AnagramTest < Test::Unit::TestCase
  
  def anagrams(word, posible_anagrams = [])
    sum_code_chars_word = word.downcase.chars.map(&:ord).reduce(0, :+)
    posible_anagrams.select do |posible_anagram|
      sum_code_chars_anagram = posible_anagram.downcase.chars.map(&:ord).reduce(0, :+)
      sum_code_chars_anagram == sum_code_chars_word
    end
  end

  def test_anagram 
    assert anagrams('adn', ['dan', 'and', 'asdfasdf']).count == 2
    assert anagrams('AAMR', ['amar', 'arma', 'mara', 'rama']).count == 4
    assert anagrams('ACER', ['acre', 'arce', 'caer', 'lelelele', 'shipnow', 'emanuel']).count == 3
  end

end


