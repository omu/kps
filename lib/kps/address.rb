# -*- encoding: utf-8 -*-

module Kps
  # Adres bilgilerin tutuldugu klass
  class Address
    ATTRIBUTES =
      [
        :identity_number,
        :city,
        :town,
        :street,
        :neighborhood,
        :apartment_number,
        :inner_door_number,
        :address
      ].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(args = {})
      ATTRIBUTES.each do |attr|
        instance_variable_set("@#{attr}", args[attr])
      end
    end
  end
end
