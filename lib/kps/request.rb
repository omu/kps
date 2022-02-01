require 'savon'
require 'kps/response'
require 'kps/error'

module Kps
  class Request
    attr_reader :client, :params

    def initialize(params)
      raise WsdlUrlNotFound, 'wsdl empty' if Kps.configuration.wsdl.nil?

      options = {
        wsdl: Kps.configuration.wsdl,
        open_timeout: Kps.configuration.open_timeout,
        read_timeout: Kps.configuration.read_timeout
      }

      options[:ssl_verify_mode] = Kps.configuration.ssl_verify_mode if Kps.configuration.ssl_verify_mode
      @client = Savon.client(options)
      @params = params
    end

    def identity
      get(:sorgula)
    end

    def address
      get(:adres_sorgula)
    end

    private

    def get(operation)
      response = @client.call(operation, message: message)
      action   = operation == :sorgula ? 'identity' : 'address'
      response = Kps::Response.new(response.body, nationality, action)
      raise Kps::InvalidResponse, 'Gecersiz data' unless response.valid?

      response.standardization
    rescue Savon::SOAPFault,
           Savon::HTTPError,
           Savon::UnknownOperationError,
           Savon::InvalidResponseError => e
      raise SavonError, e.message
    end

    def nationality
      raise(ArgumentError, 'Invalid id number') if (id_number = message[:tc]).blank?

      id_number[0] == '9' ? 'yu' : 'tc'
    end

    def message
      @message ||= case params
                   when String, Integer then { tc: params }
                   when Hash            then params
                   else
                     raise ArgumentError
                   end
    end
  end
end
