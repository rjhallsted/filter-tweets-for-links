require 'oauth'
require 'yaml'
require 'json'
require 'pp'

keys = YAML::load_file("keys.yml")
username = "vanschneider"

# Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
def prepare_access_token(keys)
    consumer = OAuth::Consumer.new(keys["API_KEY"], keys["API_KEY_SECRET"], { :site => "https://api.twitter.com", :scheme => :header })

    # now create the access token object from passed values
    token_hash = { :oauth_token => keys["ACCESS_TOKEN"], :oauth_token_secret => keys["ACCESS_TOKEN_SECRET"] }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )

    return access_token
end

# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
access_token = prepare_access_token(keys)

resource_location = "https://api.twitter.com/1.1/statuses/user_timeline.json"
full_resource_url = resource_location + "?screen_name=" + username + "&trim_user=true&include_rts=false&count=3200"

# use the access token as an agent to get the home timeline
response = access_token.request(:get, full_resource_url)

tweets = JSON.parse(response.body)

links = Array.new
tweets.each do |tweet|
  urls_wrapper = tweet["entities"]["urls"]
  unless urls_wrapper.empty?
    urls_wrapper.each do |url_array|
      url = url_array["expanded_url"]
      links.push(url)
    end
  end
end

links_string = ""
links.each do |link|
  #filter out links to other tweets, or to instagram
  regex_string = ":\/\/twitter.com\/"
  regex_string += "|" + ":\/\/www.instagram.com\/"
  regex = Regexp.new(regex_string)

  if regex.match(link).to_s.empty?
    links_string += '<a href="' + link + '" target="_blank">' + link + '</a><br>' + "\n"
  end
end

filename = "links/" + username + "_recent_links.html"

links_page = File.open(filename, "w+")
links_page.write(links_string)
links_page.close

puts "All done!"
