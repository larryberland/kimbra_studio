class UUID

  def self.random_string(n=10)
    max = 32**n
    @chars = ('a'..'z').to_a + ('0'..'9').to_a - ['i', 'l', 'o', 'u']
    ans = ''
    r = rand(max)
    n.times do
      i = r % 32
      r /= 32
      ans << @chars[i]
    end
    ans
  end

  def self.random_tracking_number
    random_string(10)
  end

end