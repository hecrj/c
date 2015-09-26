#!/usr/bin/env ruby

ALPHABET    = ('a'..'z').to_a
ALPHABET_STR = ALPHABET.join

puts "Input your message:"
input = ""

while line = gets
  input << line.chomp.downcase.gsub(/[^0-9a-z ]/i, '')
end

ALPHABET.each_with_index do |_, i|
  puts ALPHABET[-i]
  puts input.tr(ALPHABET_STR, ALPHABET_STR[i..-1] + ALPHABET_STR[0..i])
  puts
end
