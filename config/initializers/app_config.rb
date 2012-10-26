require 'yaml'

yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'application.yml'))).result)
APP_CONFIG = ENV["RAILS_ENV"] == "development" ? HashWithIndifferentAccess.new(yaml_data)[:development] : HashWithIndifferentAccess.new(yaml_data)[:production]
APP_CONFIG[:facebook][:loginUrl] = "https://www.facebook.com/dialog/oauth"+
                                      "?client_id="+APP_CONFIG[:facebook][:key]+
                                      "&redirect_uri="+APP_CONFIG[:baseUrl]+APP_CONFIG[:facebook][:redirect]+
                                      "&scope="+APP_CONFIG[:facebook][:permissions]+
                                      "&state="+APP_CONFIG[:facebook][:state]
APP_CONFIG[:foursquare][:loginUrl] = "https://foursquare.com/oauth2/authenticate"+
                                      "?client_id="+APP_CONFIG[:foursquare][:key]+
                                      "&response_type=code"+
                                      "&redirect_uri="+APP_CONFIG[:baseUrl]+APP_CONFIG[:foursquare][:redirect]