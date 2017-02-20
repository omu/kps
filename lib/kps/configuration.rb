module Kps
  class Configuration
    attr_accessor :wsdl, :open_timeout, :read_timeout

    def initialize
      @wsdl = ENV['KPS_WSDL_URL']
      @open_timeout = 30
      @read_timeout = 30
    end
  end
end
