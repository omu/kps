# -*- encoding: utf-8 -*-
require 'savon'
require 'kps/response'
require 'kps/error'

module Kps
  # Savon kullanarak istek yapar
  class Request
    def initialize(id_number)
      raise WsdlUrlNotFound, 'wsdl empty' if Kps.configuration.wsdl.nil?
      @client = Savon.client(
        wsdl: Kps.configuration.wsdl,
        open_timeout: Kps.configuration.open_timeout,
        read_timeout: Kps.configuration.read_timeout
      )
      @params = { tc: id_number.to_s }
    end

    def identity
      get(:sorgula)
    end

    def address
      get(:adres_sorgula)
    end

    private

    def get(operation)
      response = @client.call(operation, message: @params)
      uyruk    = @params[:tc][0] == '9' ? 'yu' : 'tc'
      domain   = operation == :sorgula ? 'identity' : 'address'
      response = Kps::Response.new(response.body, uyruk, domain)
      raise Kps::InvalidResponse, 'Gecersiz data' unless response.valid?
      response.standardization
    rescue Savon::SOAPFault,
           Savon::HTTPError,
           Savon::UnknownOperationError,
           Savon::InvalidResponseError => error
      raise SavonError, error.message
    end
  end
end
