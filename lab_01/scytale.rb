module Scytale
  def self.decrypt(message, key)
    rows = Array.new(key, "")
    current = 0

    message.chars.each do |char|
      rows[current] += char
      
      current = (current + 1) % key
    end

    rows.join
  end
end
