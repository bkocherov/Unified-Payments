UnifiedPayment
================

Provides the necessary library through UnifiedPayment::Client to interact with UnifiedPayment Gateway to

1. Initiate a payment
2. Get payment status
3. Reverse a completed payment

Also provides with MVC structure which can be extended according to the application.

Set Up
================

Add To Gemfile:
```ruby
gem 'unified_payment'
```

And run below command
```ruby
bundle exec rails g unified_payment:install
```
Also add your configurations in a yml file like this:

```ruby
config/unified_payment.yml

merchant_name: 'Your Merchant name at gateway'
base_uri: "http://127.0.0.1:5555" #or something else that you want to use.
```

Credits
================

[![vinsol.com: Ruby on Rails, iOS and Android developers](http://vinsol.com/vin_logo.png "Ruby on Rails, iOS and Android developers")](http://vinsol.com)

Copyright (c) 2014 [vinsol.com](http://vinsol.com "Ruby on Rails, iOS and Android developers")