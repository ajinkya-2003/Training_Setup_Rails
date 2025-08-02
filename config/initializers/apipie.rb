Apipie.configure do |config|
  config.app_name                = "RailsApp"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"

  # Disable param validation in test environment (to allow full controller testing)
  config.validate = !Rails.env.test?
end
