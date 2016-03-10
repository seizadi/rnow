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

### Connections
An instance of the `Rnow::Connection` class is necessary:
```ruby
    connection = Rnow::Connection.new(username: '', password: '', host: '')
    connection.get(uri, params)
```
For example:
```ruby
	uri = Rnow::base_path + 'organizations'
    JSON.parse(connection.get(uri).body)
```

To debug connections:
```ruby
	logger = Logger.new(STDOUT)
	connection = Rnow::Connection.new(username: '', password: '', host: '', logger: logger)
	uri = Rnow::base_path + 'organizations'
	JSON.parse(connection.get(uri).body).map do |item|
		puts item
	end
```

### Resources
The resource object Rnow::Resource can be used raw similar to connection above or can be encapsulated by a higher level Resource object. To use the objects bundled with Gem:

    orgs = Rnow::Organizations.all(connection)

You can create an incident like this:
 	incident =Rnow::Incident.new(assignedTo: {account: {id: 356}}, category: {id: 2314}, primaryContact: {id: 58599}, organization: {id: 38277}, product: {id: 2740}, severity: {id: 2}, subject: "Test Message 1 Soheil Eizadi", connection: connection).create

## Development / testing

Clone:
```
$ git clone https://github.com/seizadi/rnow.git
```

Bundle: 
```
$ bundle install
```

Make changes and add additional test suite as needed.

Run the tests: 
```
$ rspec
```

## References

This is a very early feature for Oracle RightNow and with every release it gets more complete, it took from May to
Novemember release to get paging into the mix:
http://documentation.custhelp.com/euf/assets/devdocs/november2015/Connect_REST_API/wwhelp/wwhimpl/js/html/wwhelp.htm#href=Connect_REST_API.1.32.html#

At this time I am running on the August release:
Oracle RightNow REST interface documented here:
http://documentation.custhelp.com/euf/assets/devdocs/august2015/Connect_REST_API/wwhelp/wwhimpl/js/html/wwhelp.htm#href=Connect_REST_API.1.01.html

Hoping to test on the Feb 2016 release next, you can monitor the RightNow release train here:
http://cxdeveloper.com/page/cx-features-version

The August release introduced the primitive ROQL interface from REST, it is the only way to properly do searching and paganition support until the REST interface is complete. 
http://documentation.custhelp.com/euf/assets/devdocs/november2015/Connect_REST_API/wwhelp/wwhimpl/js/html/wwhelp.htm#href=Connect_REST_API.1.29.html

The design pattern for this Gem is based on previous work by Billy Reisinger, https://github.com/govdelivery/infoblox.git

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rnow/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
