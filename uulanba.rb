require 'httparty'
require 'date'
require 'sinatra'

API_KEY = "3f02d0ee5b7adb95a078cc699c8a6663"

def status_check(status)
	if status.include?('rain')
		"Oo."
	elsif status.include?('overcast') || status.include?('drizzle') 
		"Munting ambon lang."
	elsif status.include?('storm')
		"May bagyo."
	else
		"Hindi."
	end
end

def get_json(api, city)
	url = "https://api.openweathermap.org/data/2.5/forecast"
	endpoint = "?q="
	key_param = ",PH&appid="
	response = HTTParty.get(url + endpoint + city + key_param + api, format: :plain)
	JSON.parse(response, symbolize_names: true)
end

def uulanba(api, hours, city = Manila)
	hrs = (hours.to_f / 3).ceil
	json = get_json(api, city)
	# convert the 2 hr timestamp into a string
	timestamp = json[:list][hrs][:dt].to_s
	# convert the timestamp string into a DateTime object
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
	# get the status within 2 hours
	status = json[:list][hrs][:weather][0][:description]
end

def name_check(api, city = "Manila")
	json = get_json(api, city)
	# convert the 2 hr timestamp into a string
	name = json[:city][:name]
end

def time_check(api, hours, city = "Manila")
	hrs = (hours.to_f / 3).ceil
	json = get_json(api, city)
	timestamp = json[:list][hrs][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
end

get '/:city' do
	@city = "#{params[:city]}" ? "#{params[:city]}" : "Manila"
	@name = name_check(API_KEY, @city)
	@time2hrs = time_check(API_KEY,2, @city)
	@time5hrs = time_check(API_KEY,5, @city)
	@time8hrs = time_check(API_KEY,8, @city)
	@time22hrs = time_check(API_KEY,22, @city)
	@time48hrs = time_check(API_KEY,48, @city)
	@time72hrs = time_check(API_KEY,72, @city)
	@status2hrs = status_check(uulanba(API_KEY, 2, @city))
	@status5hrs = status_check(uulanba(API_KEY,5,  @city))
	@status8hrs = status_check(uulanba(API_KEY,8, @city))
	@status22hrs = status_check(uulanba(API_KEY,22, @city))
	@status48hrs = status_check(uulanba(API_KEY,48, @city))
	@status72hrs = status_check(uulanba(API_KEY,72, @city))
	erb :index
end

get '/' do
	@city = "Manila"
	@name = name_check(API_KEY, @city)
	@time2hrs = time_check(API_KEY,2, @city)
	@time5hrs = time_check(API_KEY,5, @city)
	@time8hrs = time_check(API_KEY,8, @city)
	@time22hrs = time_check(API_KEY,22, @city)
	@time48hrs = time_check(API_KEY,48, @city)
	@time72hrs = time_check(API_KEY,72, @city)
	@status2hrs = status_check(uulanba(API_KEY,2, @city))
	@status5hrs = status_check(uulanba(API_KEY,5, @city))
	@status8hrs = status_check(uulanba(API_KEY,8, @city))
	@status22hrs = status_check(uulanba(API_KEY,22, @city))
	@status48hrs = status_check(uulanba(API_KEY,48, @city))
	@status72hrs = status_check(uulanba(API_KEY,72, @city))
	erb :index
end

post '/*' do
	@city = params[:city]
	redirect "/#{@city}".to_sym
end