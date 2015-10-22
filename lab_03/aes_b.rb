require_relative 'aes'

# We redefine shift_rows as the identity
module AES
  def self.shift_rows(bytes)
    bytes
  end
end

# When we do this, then every column of the original message will only
# affect the same column in the encrypted message
# We can test this easily

# We use a random message and a random key
M = (0...16).map { Random.rand(2**8) }
K = (0...16).map { Random.rand(2**8) }

# We encrypt the original messsage
C = AES.encrypt(M, K)

# For every bit of the message
(0...128).each do |i|
  # We change the ith bit of the original message
  mi = M.dup
  mi[15 - i / 8] ^= (1 << (i % 8))

  # We encrypt the modified message with the same key
  ci = AES.encrypt(mi, K)

  # And now, we check that all the columns are the same than in the
  # original encrypted message except the one where we changed the bit
  (0...4).each do |c|
    if (127 - i) / (8 * 4) == c
      # Changed column, should be different
      raise "Column #{c} is equal" if ci[4*c, 4] == C[4*c, 4]
    else
      # Unchanged column, should be equal
      raise "Column #{c} is not equal" unless ci[4*c, 4] == C[4*c, 4]
    end
  end
end

puts "All OK"
