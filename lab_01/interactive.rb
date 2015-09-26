require_relative 'caesar'
require_relative 'vigenere'
require_relative 'scytale'
require 'irb'
require 'irb/completion'

MESSAGE = read ARGV[0]

ARGV.clear
IRB.start
