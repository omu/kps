require 'kps/request'

module Kps
  # Savon kullanarak istek yapar
  class Query
    def self.identity(params)
      request = Kps::Request.new(params)
      request.identity
    end

    def self.address(params)
      request = Kps::Request.new(params)
      request.address
    end
  end
end
