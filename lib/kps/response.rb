module Kps
  class Response
    attr_reader :data, :nationality, :action
    def initialize(data, nationality, action = 'identity')
      @data = data
      @nationality = nationality
      @action = action
    end

    def valid?
      action == 'identity' ? identity_valid? : address_valid?
    end

    def standardization
      kutuk_key = if nationality == 'yu'
                    :yabanci_kisi_kutukleri
                  else
                    :tc_vatandasi_kisi_kutukleri
                  end
      if action == 'identity'
        raw =  data[:sorgula_response][:return][:sorgula_result][:sorgu_sonucu][:bilesik_kutuk_bilgileri]
        build_identity(
          raw[kutuk_key][:kisi_bilgisi], nationality, raw: raw
        )
      else
        build_address(
          data[:adres_sorgula_response][:return][:sorgula_result]\
          [:sorgu_sonucu][:kimlik_noile_kisi_adres_bilgileri]
        )
      end
    end

    private

    def identity_valid?
      result = data[:sorgula_response][:return][:sorgula_result]
      information = result[:sorgu_sonucu][:bilesik_kutuk_bilgileri]
      return false unless result[:hata_bilgisi].nil?
      if information[:kimlik_no].start_with?('9')
        information[:yabanci_kisi_kutukleri][:kisi_bilgisi]\
        [:hata_bilgisi].nil?
      else
        information[:hata_bilgisi].nil?
      end
    rescue NoMethodError
      false
    end

    def address_valid?
      result = data[:adres_sorgula_response][:return][:sorgula_result]
      (result[:hata_bilgisi].nil? &&
       result[:sorgu_sonucu][:kimlik_noile_kisi_adres_bilgileri]\
       [:hata_bilgisi].nil?)
    rescue NoMethodError
      false
    end

    def build_identity(data, uyruk = 'tc', raw: data)
      base = data[:temel_bilgisi]
      status = data[:durum_bilgisi]
      registered_informatin = { il: {}, ilce: {} }.merge(
        data[:kayit_yeri_bilgisi] || {}
      )
      blue_card = raw[:dolu_bilesenler][:cst_bilesik_kutuk_servis_dolu_bilesen][:item]&.include?('MaviKartliKisiBilgisi')

      if blue_card
        birthday = base[:dogum_tarih]
        id_number = data[:tc_kimlik_no]
        data[:uyruk] = raw[:mavi_kartli_kisi_kutukleri][:mavi_kart_bilgisi][:uyruk]
      elsif uyruk == 'tc'
        birthday = base[:dogum_tarih]
        id_number = data[:tc_kimlik_no]
        data[:uyruk] = { aciklama: 'TÜRKİYE CUMHURİYETİ' }
      else
        birthday = data[:dogum_tarih]
        id_number = data[:kimlik_no]
        status[:olum_tarih] = {}
      end
      date_of_death = unless status[:olum_tarih][:yil].nil?
                        Date.new(status[:olum_tarih][:yil].to_i,
                                 status[:olum_tarih][:ay].to_i,
                                 status[:olum_tarih][:gun].to_i)
                      end || nil
      Person.new(
        identity_number: id_number,
        first_name: base[:ad],
        last_name: base[:soyad],
        mother_name: base[:anne_ad],
        father_name: base[:baba_ad],
        gender: base[:cinsiyet][:aciklama],
        birthday: Date.new(birthday[:yil].to_i,
                           birthday[:ay].to_i,
                           birthday[:gun].to_i),
        place_of_birth: base[:dogum_yer],
        marital_status: status[:medeni_hal][:aciklama],
        registered_city: registered_informatin[:il][:aciklama],
        registered_town: registered_informatin[:ilce][:aciklama],
        date_of_death: date_of_death,
        nationality: data[:uyruk][:aciklama],
        blue_card: raw[:dolu_bilesenler][:cst_bilesik_kutuk_servis_dolu_bilesen][:item]&.include?('MaviKartliKisiBilgisi')
      )
    end

    def build_address(data)
      address = data[:yerlesim_yeri_adresi]
      detail_address = address[:il_ilce_merkez_adresi] || {}
      Address.new(
        identity_number: data[:kimlik_no], city: detail_address[:il],
        town: detail_address[:ilce], street: detail_address[:csbm],
        neighborhood: detail_address[:mahalle],
        apartment_number: detail_address[:dis_kapi_no],
        inner_door_number: detail_address[:ic_kapi_no],
        address: address[:acik_adres]
      )
    end
  end
end
