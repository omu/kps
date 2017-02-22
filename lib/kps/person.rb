# -*- encoding: utf-8 -*-
module Kps
  # Kisisel bilgilerin tutuldugu klass
  class Person
    ATTRIBUTES = [
      :first_name, :identity_number, :first_name, :last_name, :mother_name,
      :father_name, :gender, :birthday, :place_of_birth, :marital_status,
      :registered_city, :registered_town, :date_of_death, :nationality
    ].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(args = {})
      ATTRIBUTES.each do |attr|
        instance_variable_set("@#{attr}", args[attr])
      end
    end

    def address
      Kps::Query.address(identity_number)
    end

    def turkish?
      !(identity_number.to_s =~ /\A[1-8]/).nil?
    end

    def foreign?
      identity_number.to_s.start_with?('9')
    end
  end
end
