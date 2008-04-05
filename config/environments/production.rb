# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Library for sending via GMail
require 'smtp_tls'

# Load the mail.yml config file
mail_yml = YAML.load_file(RAILS_ROOT+'/config/mail.yml')
mail_env = mail_yml[ENV['RAILS_ENV']]

# Send mail via GMail with credentials from mail.yml
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address        => 'smtp.gmail.com',
  :port           => 587,
  :domain         => mail_env['domain'],
  :authentication => :plain,
  :user_name      => mail_env['user_name'],
  :password       => mail_env['password']
}
