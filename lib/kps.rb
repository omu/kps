require 'kps/configuration'
require 'kps/query'
require 'kps/person'
require 'kps/address'
require 'kps/version'
require 'byebug'
require 'awesome_print'
# Omu Kimlik Paylasim Sistemi
module Kps

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    yield(config)
  end

  def self.query(id_number, action = :kimlik_bilgisi)
    if action.to_sym == :kimlik_bilgisi
      Kps::Query.identity(id_number)
    elsif action.to_sym == :adres_bilgisi
      Kps::Query.address(id_number)
    else
      raise InvalidAction, 'action parametresi yalnızca `kimlik_bilgisi` veya '\
            '`adres_bilgisi` değerlerinden birini alabilir'
    end
  end
end
