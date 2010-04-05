# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rjanse_sample_app_session',
  :secret      => '91015d351391d9d6f900577e96e83163501e3d3a70f79f17e53920f6f3a82dd9e8ebf89b77f9a36fb64c5c718b23a02e55a988337e1ffbcda6bda985827fb3d4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
