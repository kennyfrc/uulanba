require 'httparty'
require 'date'
require 'sinatra'
require 'active_support/core_ext'
require 'dotenv'
Dotenv.load('.env')

API_KEY = ENV["API_KEY"]

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

def day_check(timestamp)
	start_of_today = Time.now.getlocal('+08:00').beginning_of_day
	end_of_today = Time.now.getlocal('+08:00').end_of_day
	start_of_tom = Time.now.getlocal('+08:00').tomorrow.beginning_of_day
	end_of_tom = Time.now.getlocal('+08:00').tomorrow.end_of_day
	if start_of_today < timestamp && timestamp < end_of_today
		"Ngayong araw"
	elsif start_of_tom < timestamp && timestamp < end_of_tom
		"Kinabukasan"
	else
		"Sa dalawang araw"
	end	
end

def uulanba(api, hours, city = "Manila")
	hrs = (hours.to_f / 3).ceil
	json = get_json(api, city)
	# convert the 2 hr timestamp into a string
	timestamp = json[:list][hrs][:dt].to_s
	# convert the timestamp string into a DateTime object
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
	# get the status within 2 hours
	status = json[:list][hrs][:weather][0][:description]
end

def time_check(api, hours, city = "Manila")
	hrs = hours / 3
	json = get_json(api, city)
	timestamp = json[:list][hrs][:dt].to_s
	dt = DateTime.strptime(timestamp, "%s").to_time.getlocal("+08:00")
end

get '/:city' do
	@city = "#{params[:city]}" ? "#{params[:city]}" : "Manila"
	@time2hrs = time_check(API_KEY,2, @city)
	@time5hrs = time_check(API_KEY,5, @city)
	@time8hrs = time_check(API_KEY,8, @city)
	@time11hrs = time_check(API_KEY,11, @city)
	@time22hrs = time_check(API_KEY,22, @city)
	@time25hrs = time_check(API_KEY,25, @city)
	@time28hrs = time_check(API_KEY,28, @city)
	@time31hrs = time_check(API_KEY,31, @city)
	@status2hrs = status_check(uulanba(API_KEY, 2, @city))
	@status5hrs = status_check(uulanba(API_KEY,5,  @city))
	@status8hrs = status_check(uulanba(API_KEY,8, @city))
	@status11hrs = status_check(uulanba(API_KEY,11, @city))
	@status22hrs = status_check(uulanba(API_KEY,22, @city))
	@status25hrs = status_check(uulanba(API_KEY,25, @city))
	@status28hrs = status_check(uulanba(API_KEY,28, @city))
	@status31hrs = status_check(uulanba(API_KEY,31, @city))
	erb :index
end

get '/' do
	@city = "Manila"
	@time2hrs = time_check(API_KEY,2)
	@time5hrs = time_check(API_KEY,5)
	@time8hrs = time_check(API_KEY,8)
	@time11hrs = time_check(API_KEY,11)
	@time22hrs = time_check(API_KEY,22)
	@time25hrs = time_check(API_KEY,25)
	@time28hrs = time_check(API_KEY,28)
	@time31hrs = time_check(API_KEY,31)
	@status2hrs = status_check(uulanba(API_KEY, 2))
	@status5hrs = status_check(uulanba(API_KEY,5))
	@status8hrs = status_check(uulanba(API_KEY,8))
	@status11hrs = status_check(uulanba(API_KEY,11))
	@status22hrs = status_check(uulanba(API_KEY,22))
	@status25hrs = status_check(uulanba(API_KEY,25))
	@status28hrs = status_check(uulanba(API_KEY,28))
	@status31hrs = status_check(uulanba(API_KEY,31))
	erb :index
end

post '/*' do
	@city = params[:city]
	redirect "/#{@city}".to_sym
end