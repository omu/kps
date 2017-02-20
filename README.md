# Kps
Bu gem Ondokuz Mayıs Üniversitesi BİDB tarafından sunulan kimlik paylaşım sistemin ruby istemcisidir.

## Installation

Uygulamanızın Gemfile dosyasına aşağıdaki satırı ekleyin;

```ruby
gem 'kps', git: 'git@github.com:uzem/kps.git'
```

ve aşağıdaki kodu çalıştırın:

    $ bundle

Veya kendiniz aşağıdaki gibi yükleyin:

    $ gem install kps

### Configuration

Rails uygulamanızda `config/initializers/kps_configure.rb` dosyası oluştururak
aşağıdaki kodları içisine yapıştırınız.

``` ruby
  Kps.configure do |config|
    config.wsdl = "http://foo.bar.com?wsql"
    config.open_timeout = 30 # Default 30
    config.read_timeout = 30 # Default 30
  end
```

Veya

WSDL adresini ayrıca ortam değişkenleri yoluyla da değiştirebilirsiniz
```
export KPS_WSDL_URL="http://foo.bar.com?wsql"
```
## Kullanım

Bu gem iki tür bilginin kimlik paylaşım sistemi üzerinden çekilmesini sağlar.

#### Kişi Bilgisi

``` Ruby
Kps.query(kimlik_no)

# Response
<Kps::Person:0x007f3657c1f270
 @birthday=#<Date: 1900-01-01 ((2448867j,0s,0n),+0s,2299161j)>,
 @date_of_death=nil,
 @father_name="Father Name",
 @first_name="Bla",
 @gender="Erkek",
 @identity_number="12345678901",
 @last_name="Foo",
 @marital_status="Bekâr",
 @mother_name="Mother Name",
 @nationality="Türkiye Cumhuriyeti Devleti",
 @place_of_birth="ATAKUM">

```

Veya

``` Ruby
Kps::Query.identity(kimlik_no)
```

Kişinin, türk vatandaşı veya yabancı uyruklu olup olmadığını aşağıdaki methodlar üzerinden öğrenebilirsiniz.

``` Ruby
person = Kps.query(kimlik_no)
person.turkish? # true or false
person.foreign? # true or false
```

#### Adres Bilgisi

``` Ruby
Kps.query(kimlik_no, :adres_bilgisi)

# Response
<Kps::Address:0x007f3656b658d0
 @address="Ondokuz Mayıs Üniversitesi Uzaktan Eğitim Merkezi ATAKUM/SAMSUN",
 @apartment_number="55",
 @city="SAMSUN",
 @identity_number="12345678901",
 @inner_door_number="1",
 @neighborhood="Kurupelit",
 @street="1. Sokak",
 @town="ATAKUM">
```
Veya

``` Ruby
Kps::Query.address(kimlik_no)
```

Adres bilgilerini kişi bilgileri klasında bulunan `address` metodu ile öğrenebilirsiniz.

``` Ruby
person = Kps.query(kimlik_no)
person.address
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
