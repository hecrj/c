require 'set'

encripted = File.read(ARGV[0]).

lengths = Set.new(encripted.most_frequent.map { |word, _| encripted.distances(word).gcd }) - [1]

puts "Candidate lengths:"
puts lengths.inspect


