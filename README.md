[![Build Status](https://travis-ci.org/melvinsembrano/lockie.svg?branch=master)](https://travis-ci.org/melvinsembrano/lockie)
[![Gem Version](https://badge.fury.io/rb/lockie.svg)](https://badge.fury.io/rb/lockie)

# Lockie
A drop-in, none assuming warden based Password and JWT authentication for Rails 5.2++

## Usage
Add the following lines to your authenticaiton model e.g. `User`:

```ruby
has_secure_password
include Lockie::ModelHelper
```

Add the following lines to your base controller e.g. `ApplicationController`:
```ruby
include Lockie::ControllerHelper
before_action :authenticate!
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'lockie'
```

And then execute:
```bash
$ bundle
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
