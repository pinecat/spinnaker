# Spinnaker

Spinnaker is a drop-in tool for collecting and serving website page metrics. It's designed for use with [Jekyll](https://github.com/jekyll/jekyll) (and [Lanyon](https://github.com/stomar/lanyon)) in mind, but since it's just middleware for [Rack](https://github.com/rack/rack), it will work for any compatible frameworks. Spinnaker is quite private out of the box, as it only tracks what pages are being requested, and at what times those requests occur.

## Installation

To add spinnaker to your project, run:
```sh
bundle add spinnaker
```

You could also install it manuall with `gem install spinnaker`.

Then `use` it in your config.ru file.
```ruby
# config.ru

require "lanyon"
require "spinnaker"

use Spinnaker
run Lanyon.application
```

If needed you can configure some settings before `use`ing it.
```ruby
# config.ru

require "lanyon"
require "spinnaker"

Spinnaker.new.tap do |s|
    # Set the endpoint where spinnaker will serve metrics.
    # The default value is '/spinnaker'.
    s.endoint = "stats"

    # Set the address (or address range) to listen on the metrics endpoint.
    # Accepts CIDR range syntax (i.e. 192.168.1.0/24).
    # Accepts an array of addresses, or simply a single string.
    # The default value is ['127.0.0.1'].
    s.listen = ["127.0.0.1", "192.168.1.0/24"]
end

use Spinnaker
run Lanyon.application
```

## Usage

Right now, you can query data over a specified time period on the API. Asumming the endpoint is '/spinnaker':
| Request Type | Path | Data |
| - | - | - |
| GET | /spinnaker{/latest} | Get page data for the last 24 hours |
| GET | /spinnaker/today | Get page data for the current day |
| GET | /spinnaker/week | Get page data for the current week |
| GET | /spinnaker/month | Get page data for the current month |


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pinecat/spinnaker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
