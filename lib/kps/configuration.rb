module Kps
  class Configuration
    attr_accessor :wsdl, :open_timeout, :read_timeout, :ssl_verify_mode

    def initialize
      @wsdl = ENV['KPS_WSDL_URL']
      @open_timeout = 30
      @read_timeout = 30
      @ssl_verify_mode = :none
    end
  end
end
