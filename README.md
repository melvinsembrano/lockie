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
That's it! All your controllers that inherits `ApplicationController` are now protected.


## Adding a session controller
Creating a session controller is simple as:

Session controller
```ruby
class SessionController < ApplicationController
  skip_before_action :authenticate!, only: [:new]

  def create
    # on successful login redirect to your user's page
    redirect_to root_url
  end

  def destroy
    logout
    redirect_to login_url
  end
end

```

routes.rb
```ruby
get 'login' => 'session#new'
post 'login' => 'session#create'
get 'logout' => 'session#destroy'
```

session/new.html.erb view:
```ruby
<%= form_tag(login_url) do -%>
<%= email_field_tag 'email' %>
<%= password_field_tag 'password' %>
<%= submit_tag "Login" %>
<% end -%>
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
