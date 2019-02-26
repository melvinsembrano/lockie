module AuthTestHelper
  def app
    Rack::Builder.new do
      use Warden::Manager do |config|
        config.failure_app = Lockie::FailureApp

        config.default_strategies [:email_password, :jwt, :failed]

      end

      map "/json" do
        run lambda { |env|
          env['warden'].authenticate
          if env['warden'].user
            [200, {'Content-Type' => 'text/json'}, ['OK']]
          end
        }
      end

      map "/xml" do
        run lambda { |env|
          env['warden'].authenticate
          if env['warden'].user
            [200, {'Content-Type' => 'text/xml'}, ['OK']]
          end
        }
      end

      map "/web" do
        run lambda { |env|
          env['warden'].authenticate
          if env['warden'].user
            [200, {'Content-Type' => 'text/html'}, ['OK']]
          end
        }
      end
    end
  end
end
