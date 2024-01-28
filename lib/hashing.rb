class Hashing
  class << self
    def hash_code(code)
      Digest::MD5.hexdigest(code)
    end
  end
end