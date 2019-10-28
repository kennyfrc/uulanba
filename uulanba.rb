require 'httparty'
require 'date'
require 'sinatra'

API_KEY = "3f02d0ee5b7adb95a078cc699c8a6663"

def status_check(status)
	status == 'Rain' ? "Oo." : status.capitalize
end

def get_json(api, city)
	url = "https://api.openweathermap.org/data/2.5/forecast"
	endpoint = "?q="
	key_param = ",PH&appid="
	response = HTTParty.get(url + endpoint + city + key_param + api, format: :plain)
	JSON.parse(response, symbolize_names: true)
end

def uulanbain2hours(api, city = "Manila")
	json = get_json(api, city)
	# convert the 2 hr timestamp into a string
	timestamp = json[:list][0][:dt].to_s
	# convert the timestamp string into a DateTime object
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
	# get the status within 2 hours
	status = json[:list][0][:weather][0][:description]
	status_check(status)
end

def name_check(api, city = "Manila")
	json = get_json(api, city)
	# convert the 2 hr timestamp into a string
	name = json[:city]
end

def uulanbain5hours(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][1][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
	status = json[:list][1][:weather][0][:description]
	status_check(status)
end

def uulanbain8hours(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][2][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
	status = json[:list][2][:weather][0][:description]
	status_check(status)
end

def uulanbain22hours(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][8][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
	status = json[:list][8][:weather][0][:description]
	status_check(status)
end

def uulanbain48hours(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][15][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
	status = json[:list][15][:weather][0][:description]
	status_check(status)
end

def uulanbain72hours(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][23][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
	status = json[:list][23][:weather][0][:description]
	status_check(status)
end

def time2hrs(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][0][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
end

def time5hrs(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][1][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
end

def time8hrs(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][2][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
end

def time22hrs(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][8][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
end

def time48hrs(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][15][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
end

def time72hrs(api, city = "Manila")
	json = get_json(api, city)
	timestamp = json[:list][23][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
end


get '/:city' do
	@city = "#{params[:city]}" ? "#{params[:city]}" : "Manila"
	@name = name_check(API_KEY, @city)
	@time2hrs = time2hrs(API_KEY, @city)
	@time5hrs = time5hrs(API_KEY, @city)
	@time8hrs = time8hrs(API_KEY, @city)
	@time22hrs = time22hrs(API_KEY, @city)
	@time48hrs = time48hrs(API_KEY, @city)
	@time72hrs = time72hrs(API_KEY, @city)
	@status2hrs = status_check(uulanbain2hours(API_KEY, @city))
	@status5hrs = status_check(uulanbain5hours(API_KEY, @city))
	@status8hrs = status_check(uulanbain8hours(API_KEY, @city))
	@status22hrs = status_check(uulanbain22hours(API_KEY, @city))
	@status48hrs = status_check(uulanbain48hours(API_KEY, @city))
	@status72hrs = status_check(uulanbain72hours(API_KEY, @city))
	erb :index
end

get '/' do
	@city = "Manila"
	@name = name_check(API_KEY, @city)
	@time2hrs = time2hrs(API_KEY, @city)
	@time5hrs = time5hrs(API_KEY, @city)
	@time8hrs = time8hrs(API_KEY, @city)
	@time22hrs = time22hrs(API_KEY, @city)
	@time48hrs = time48hrs(API_KEY, @city)
	@time72hrs = time72hrs(API_KEY, @city)
	@status2hrs = status_check(uulanbain2hours(API_KEY, @city))
	@status5hrs = status_check(uulanbain5hours(API_KEY, @city))
	@status8hrs = status_check(uulanbain8hours(API_KEY, @city))
	@status22hrs = status_check(uulanbain22hours(API_KEY, @city))
	@status48hrs = status_check(uulanbain48hours(API_KEY, @city))
	@status72hrs = status_check(uulanbain72hours(API_KEY, @city))
	erb :index
end

post '/*' do
	@city = params[:city]
	redirect "/#{@city}".to_sym
end