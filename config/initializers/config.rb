# config/initializers/load_config.rb
Settings = YAML.load_file("#{Rails.root}/config/settings.yml")[Rails.env]