require_relative 'support'
require_relative 'caesar'
require 'set'

module Vigenere
  def self.candidates(message, n=5)
    lengths = Set.new(message.words_only.most_frequent_words.map { |word, _| message.words_only.distances(word).gcd }).sort

    candidates = []

    lengths.each do |length|
      keys = Array.new(n, '')

      multiples = message.letters_only.group_multiples(length)
      
      multiples.each do |multiple|
        Caesar.candidates(multiple, n).each_with_index do |key, index|
          keys[index] += key
        end
      end

      candidates.push(*keys)
    end

    candidates
  end

  def self.encrypt(message, key)
    key = key.chars

    message.chars.map do |char|
      if char.letter?
        key << key.shift
        Caesar.encrypt(char, key.last)
      else
        char
      end
    end.join
  end

  def self.decrypt(message, key)
    key = key.chars

    message.chars.map do |char|
      if char.letter?
        key << key.shift
        Caesar.decrypt(char, key.last)
      else
        char
      end
    end.join
  end
end
