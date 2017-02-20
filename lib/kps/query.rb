# -*- encoding: utf-8 -*-
require 'kps/request'

module Kps
  # Savon kullanarak istek yapar
  class Query
    def self.identity(id_number)
      request = Kps::Request.new(id_number)
      request.identity
    end

    def self.address(id_number)
      request = Kps::Request.new(id_number)
      request.address
    end
  end
end
