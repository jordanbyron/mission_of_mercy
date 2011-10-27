class UserType

  def self.add_enum(key,value)
    @hash ||= {}
    @hash[key]=value
  end

  def self.const_missing(key)
    @hash[key]
  end

  def self.each
    @hash.each {|key,value| yield(key,value)}
  end

  self.add_enum :ADMIN, 1
  self.add_enum :CHECKIN, 2
  self.add_enum :CHECKOUT, 3
  self.add_enum :XRAY, 4
  self.add_enum :PHARMACY, 5
  self.add_enum :ASSIGNMENT, 6

end
