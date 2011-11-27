class ApplicationController < ActionController::Base
  protect_from_forgery

  Dir["app/decorators/*.rb"].each do |path| 
    require_dependency path 
  end 

  Dir["app/decorators/**/*.rb"].each do |path| 
    require_dependency path 
  end 

end
