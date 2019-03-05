## Installation

Create a new Bot Integration under [services/new/bot](http://slack.com/services/new/bot).

![](screenshots/register-bot.png)

On the next screen, note the API token.

### Environment

#### SLACK_API_TOKEN

Set SLACK_API_TOKEN from the Bot integration settings on Slack.

```
heroku config:add SLACK_API_TOKEN=...
```

#### GIPHY_API_KEY

The bot replies with animated GIFs. While it's currently not necessary, you may need to set GIPHY_API_KEY in the future, see [github.com/Giphy/GiphyAPI](https://github.com/Giphy/GiphyAPI) for details.

#### SLACK_RUBY_BOT_ALIASES

Optional names for this bot.

```
heroku config:add SLACK_RUBY_BOT_ALIASES=":pong: table-tennis ping-pong"
```

### Heroku Idling

Heroku free tier applications will idle. Either pay 7$ a month for the hobby dyno or use [UptimeRobot](http://uptimerobot.com) or similar to prevent your instance from sleeping or pay for a production dyno.

### Passenger Deployment

Deploying on your self-hosted server is fairly easy, it's pretty much following the [tutorial](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby), but there are some configuration details to pay attention to.

+ Change or add the `gem 'puma'` entry in your `Gemfile` to `gem 'passenger'` and `bundle` it
  + OPTIONAL: To use passenger for developing too, change the `Procfile` to `web: bundle exec passenger start`, to configure the local passenger you could provide an optional `Passenger.json` file ([configuration options](https://www.phusionpassenger.com/library/config/standalone/reference/))
+ If you want to keep your logs etc. in the correct folders, you could add empty `public/`, `tmp/` and `log` directories. Passenger e.g. will automatically use them for local log files.
+ Make sure, the right ruby version is [installed](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/install_language_runtime.html) and your passenger is [ready](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/install_passenger_main.html) to go.
+ Clone the repository on your server (You could create a separate user for this) and install the dependencies, by running `bundle install` ([More information](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/xenial/deploy_app.html))
+ Edit the web-server configuration according to the examples below
  + `PassengerMaxPreloaderIdleTime 0` or `passenger_max_preloader_idle_time 0;` makes sure to not automatically shut down the process after 5 minutes
  + `PassengerPreStart http://url:port` or `passenger_pre_start http://url:port` will startup the application instantly, without the first HTTP GET-request needed for passenger 
  + To get the `/path/to/ruby` run `passenger-config about ruby-command` and copy the displayed path
  + Check the config (`nginx -t`) and restart the server with `service nginx restart`
  + Execute `passenger-status --verbose` to check if your app is working correctly 
  + Optional: restart the passenger app via `passenger-config restart-app /var/www/bot`

#### Nginx

```
server {
  listen 80;
  server_name example.com;
  root /var/www/bot/public;
  passenger_enabled on;
  passenger_ruby /path/to/ruby
  passenger_max_preloader_idle_time 0;
  passenger_app_type rack;
}

passenger_pre_start http://example.com:80/;
```

#### Apache

```
<VirtualHost *:80>
  ServerName example.com
  DocumentRoot /var/www/bot/public
  PassengerRuby /path/to/ruby
  PassengerMaxPreloaderIdleTime 0

  <Directory /var/www/bot/public>
    Allow from all
    Options -MultiViews
    Require all granted    
  </Directory>
</VirtualHost>

PassengerPreStart http://example.com:80/
```
