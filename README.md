[![Build Status](https://github.com/melvinsembrano/lockie/actions/workflows/00_test.yml/badge.svg)](https://github.com/melvinsembrano/lockie/actions/workflows/00_test.yml)
[![Gem Version](https://badge.fury.io/rb/lockie.svg)](https://badge.fury.io/rb/lockie)

# Lockie
A drop-in, none assuming warden based Password and JWT authentication for Rails 5.2++


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'lockie', '~> 0.5.2'
```

And then execute:
```bash
$ bundle
```

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
That's it! All your controllers that inherits `ApplicationController` are now protected with `Authorization token` or with `email and password`.


## Adding a session controller
Creating a session controller is simple as:

Session controller
```ruby
class SessionController < ApplicationController
  skip_before_action :authenticate!, only: [:new]

  def new
    session[:callback_url] = params[:callback_url] if params[:callback_url]
  end
  
  def create    
    redirect_to session[:callback_url] || root_url
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

## Configuration

config/initializers/lockie.rb
```ruby
Lockie.configure do |c|
  c.jwt_secret = ENV.fetch("JWT_SECRET") { "i-am-jwt-secret" }
  c.model_name = "Account" # default to 'User'
  c.unauthenticated_path = "/some/login/path" # default to '/login'
  c.hash_algorithm = "HS512" # default to 'HS256'
  c.session_timeout = 14.days
  
  # add custom warden strategy, default strategies and priority are [:email_password, :jwt]
  c.default_strategies = [:auth0, :jwt]
  
  # set custom session serializer
  c.serializer_to_session = proc {|u| u.id }
  c.serializer_from_session = proc {|id| User.find(id) }
  
  # set custom scopes
  c.scopes = [
    [:api, { store: false, strategies: [:jwt]}],
    [:web, { store: true, strategies: [:email_password]}],
    [:admin, { store: true, strategies: [:email_password], unauthenticated_path: "/login-admin" }]
  ]
end
```

## Testing

Using `Warden::Test::Helpers` https://github.com/wardencommunity/warden/wiki/testing testing is simple and straight forward

```
include Warden::Test::Helpers

setup do
  @user = users(:one)
  login_as @user
  
end
teardown { Warden.test_reset! }
```

### Testing JSON Api with token

```
get articles_url(format: :json), headers: {
  Authorization: "Bearer #{ @user.create_token }"
}
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
