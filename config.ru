require './uulanba'

require 'rack/cache'
use Rack::Cache

run Sinatra::Application