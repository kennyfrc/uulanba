require 'httparty'
require 'date'
require 'sinatra'

API_KEY = "3f02d0ee5b7adb95a078cc699c8a6663"

def status_check(status)
	status == 'Rain' ? "Oo." : "Hindi."
end

def get_json(api, city)
	url = "https://api.openweathermap.org/data/2.5/forecast"
	endpoint = "?q="
	key_param = "&appid="
	response = HTTParty.get(url + endpoint + city + key_param + api, format: :plain)
	JSON.parse(response, symbolize_names: true)
end

def uulanbain2hours(api, city = "Manila")
	json = get_json(api, city)
	# convert the 2 hr timestamp into a string
	timestamp2hrs = json[:list][0][:dt].to_s
	# convert the timestamp string into a DateTime object
	dt2hrs = DateTime.strptime(timestamp2hrs, "%s").to_time.getlocal("+08:00")
	# get the status within 2 hours
	status2hrs = json[:list][0][:weather][0][:main]
	status_check(status2hrs)
end

def uulanbain5hours(api, city = "Manila")
	json = get_json(api, city)
	timestamp5hrs = json[:list][1][:dt].to_s
	dt5hrs = DateTime.strptime(timestamp5hrs, "%s").to_time.getlocal("+08:00")
	status5hrs = json[:list][1][:weather][0][:main]
	status_check(status5hrs)
end

def time2hrs(api, city = "Manila")
	json = get_json(api, city)
	timestamp2hrs = json[:list][0][:dt].to_s
	dt2hrs = DateTime.strptime(timestamp2hrs, "%s").to_time.getlocal("+08:00")
end

def time5hrs(api, city = "Manila")
	json = get_json(api, city)
	timestamp5hrs = json[:list][1][:dt].to_s
	dt5hrs = DateTime.strptime(timestamp5hrs, "%s").to_time.getlocal("+08:00")
end

get '/' do
	@city = "Manila"
	@time2hrs = time2hrs(API_KEY)
	@time5hrs = time5hrs(API_KEY)
	@status2hrs = status_check(uulanbain2hours(API_KEY))
	@status5hrs = status_check(uulanbain5hours(API_KEY))
	erb :index
end

get '/:city' do
	@city = "#{params[:city]}" ? "#{params[:city]}" : "Manila"
	@time2hrs = time2hrs(API_KEY)
	@time5hrs = time5hrs(API_KEY)
	@status2hrs = status_check(uulanbain2hours(API_KEY))
	@status5hrs = status_check(uulanbain5hours(API_KEY))
	erb :index
end