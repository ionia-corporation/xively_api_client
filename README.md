# XivelyApiClient

Gem for handling xively devices's credentials.

## Installation

    gem 'xively_api_client'

## Usage

### Set up environment variables (optional)

    XIVELY_USER
    XIVELY_PASS
    XIVELY_INSTANCE
    XIVELY_DOMAIN

### Instantiate the client

```ruby
  client = Xively::ApiClient.new   # will use env variables

  other_client = Xively::ApiClient.new user: "app_username", pass: "app_password", domain: "abc", instance: "123"
```

### List devices

```ruby
  client.devices
```

### Get a device

```ruby
  client.device "serial_id_here"
```

### Create a device

```ruby
  client.create_device "serial_id", batch_id: "1234", queues: [ "readings", "input", "last_will" ]
```

### Destroy a device

```ruby
  client.destroy "serial_id"
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/xively_api_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
