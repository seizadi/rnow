# RNow

Interact with the Oracle RightNow REST interface with Ruby.  Use this gem to list, create, and delete RightNow organizations, contacts and incdents. The Orcale RightNow REST Interface was available with version 15.05 (May 2015).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rnow'
```

And then execute:

```
    $ bundle
```

Or install it yourself as:

```
    $ gem install rnow
```

## Usage

### Connecting
An instance of the `Rnow::Connection` class is necessary:

    connection = Rnow::Connection.new(username: '', password: '', host: '')

## References

Oracle RightNow REST interface documented here:
http://documentation.custhelp.com/euf/assets/devdocs/august2015/Connect_REST_API/wwhelp/wwhimpl/js/html/wwhelp.htm#href=Connect_REST_API.1.01.html

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rnow/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
