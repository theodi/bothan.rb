[![Build Status](http://img.shields.io/travis/theodi/bothan.rb.svg?style=flat-square)](https://travis-ci.org/theodi/bothan.rb)
[![Dependency Status](http://img.shields.io/gemnasium/theodi/bothan.rb.svg?style=flat-square)](https://gemnasium.com/theodi/bothan.rb)
[![Code Climate](http://img.shields.io/codeclimate/github/theodi/bothan.rb.svg?style=flat-square)](https://codeclimate.com/github/theodi/bothan.rb)
[![Gem Version](http://img.shields.io/gem/v/bothan.svg?style=flat-square)](https://rubygems.org/gems/bothan)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://theodi.mit-license.org)

# Bothan

A Ruby client for [Bothan](https://bothan.io/), a simple platform for storing and publishing metrics.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bothan'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bothan

## Usage

First require the Bothan client:

```ruby
require 'bothan'
```

Then initialize a connection with your username, password and the url of your Bothan endpoint:

```ruby
@bothan = Bothan::Connection.new('username', 'password', 'https://demo.bothan.io')
```

You will then be able to interact with your [Bothan API](https://bothan.io/api.html) via the `metrics` method like so:

### Get all metrics

Returns a list of available metrics as an array of hashes

```ruby
@bothan.metrics.all
#=> [{"name"=>"metric-with-geodata", "url"=>"https://demo.bothan.io/metrics/metric-with-geodata.json"}, {"name"=>"metric-with-multiple-values", "url"=>"https://demo.bothan.io/metrics/metric-with-multiple-values.json"}, {"name"=>"metric-with-target", "url"=>"https://demo.bothan.io/metrics/metric-with-target.json"}, {"name"=>"metric-with-ytd-target", "url"=>"https://demo.bothan.io/metrics/metric-with-ytd-target.json"},{"name"=>"simple-metric", "url"=>"https://demo.bothan.io/metrics/simple-metric.json"}]
```

### Find a metric

#### Latest value

Returns the latest value for a specified metric as a hash

```ruby
@bothan.metrics.find('simple-metric')
#=> {"_id"=>{"$oid"=>"58451086db72110004125f6d"}, "name"=>"simple-metric", "time"=>"2016-12-05T07:00:22.459+00:00", "value"=>68}
```

#### For a specific DateTime

Returns the most recent value of a metric at the specified datetime.

```ruby
@bothan.metrics.find('simple-metric', '2016-12-05T07:00:22.459+00:00')
#=> {"_id"=>{"$oid"=>"58451086db72110004125f6d"}, "name"=>"simple-metric", "time"=>"2016-12-05T07:00:22.459+00:00", "value"=>68}
```

#### For a specific DateTime range

Returns all values of the metric between the specified times.

```ruby
@bothan.metrics.find('simple-metric', '2016-12-01T07:00:22.851+00:00', '2016-12-05T07:00:22.459+00:00')
#=> [{"time"=>"2016-12-01T07:00:22.851+00:00", "value"=>92}, {"time"=>"2016-12-02T07:00:22.759+00:00", "value"=>17}, {"time"=>"2016-12-03T07:00:22.664+00:00", "value"=>18}, {"time"=>"2016-12-04T07:00:22.569+00:00", "value"=>12}, {"time"=>"2016-12-05T07:00:22.459+00:00", "value"=>68}]
```

The `from` and `to` values can be either:

* An ISO8601 date/time
* A Ruby DateTime object
* An [ISO8601 duration](https://en.wikipedia.org/wiki/ISO_8601#Durations)
* \*, meaning unspecified

### Create a metric

The Bothan API supports four types of metric, all supported by the gem.

#### Create a [simple metric](https://bothan.io/api#simple-value)

```ruby
# Create a metric called 'my-new-metric' with a value of '12' at the current datetime
@bothan.metrics.create('my-new-metric', 12)
# Create a metric with a specific datetime
@bothan.metrics.create('my-new-metric', 12, '2016-01-01T00:00:00')
```

#### Create a [metric with a target](https://bothan.io/api#value-with-a-target)

```ruby
# Create a metric called 'my-new-metric' with a value of '1091000', an annual target of '2862000' and a ytd target of '1368000' at the current datetime
@bothan.metrics.create_target('my-new-target-metric', 1091000, 2862000, 1368000)
# Create a metric with a target at a specific datetime
@bothan.metrics.create_target('my-new-target-metric', 1091000, 2862000, 1368000, '2016-01-01T00:00:00')
# Create a metric without a ytd target
@bothan.metrics.create_target('my-new-target-metric', 1091000, 2862000)
# Create a metric without a ytd target at a specific datetime
@bothan.metrics.create_target('my-new-target-metric', 1091000, 2862000, nil, '2016-01-01T00:00:00')
```

#### Create a [metric with multiple values](https://bothan.io/api#multiple-values)

```ruby
# Create a metric called 'my-new-metric' with multiple values with the current datetime
@bothan.metrics.create_multiple('my-awesome-mulitple-metric', {
  "value1" => 123,
  "value2" => 23213,
  "value4" => 1235
})
# Create a metric called 'my-new-metric' with multiple values with a specific datetime
@bothan.metrics.create_multiple('my-awesome-mulitple-metric', {
  "value1" => 123,
  "value2" => 23213,
  "value4" => 1235
}, "2016-11-28T09:00:00")
```

#### Create a [metric with geodata](https://bothan.io/api#geographical-data)

```ruby
# Create a geodata metric called 'my-new-metric' with the current datetime
@bothan.metrics.create_geo('my-new-metric', [
  {
    "type" => "Feature",
    "geometry" => {
      "type" => "Point",
      "coordinates" => [-2.6156582783015017, 54.3497405310758]
    }
  },
  {
    "type" => "Feature",
    "geometry" => {
      "type" => "Point",
       "coordinates" => [-6.731370299641439, 55.856756177781186]
    }
  }
])
# Create a geodata metric called 'my-new-metric' with a specific datetime
@bothan.metrics.create_geo('my-awesome-geo-metric', [
  {
    "type" => "Feature",
    "geometry" => {
      "type" => "Point",
      "coordinates" => [-2.6156582783015017, 54.3497405310758]
    }
  },
  {
    "type" => "Feature",
    "geometry" => {
      "type" => "Point",
       "coordinates" => [-6.731370299641439, 55.856756177781186]
    }
  }
], "2016-11-28T09:00:00")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bothan. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
