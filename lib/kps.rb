require 'kps/configuration'
require 'kps/query'
require 'kps/person'
require 'kps/address'
require 'kps/version'

module Kps
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    yield(config)
  end

  def self.query(params, action = :kimlik_bilgisi)
    if action.to_sym == :kimlik_bilgisi
      Kps::Query.identity(params)
    elsif action.to_sym == :adres_bilgisi
      Kps::Query.address(params)
    else
      raise InvalidAction
    end
  end
end
