# filter-tweets-for-links
A ruby script that filters the tweets of a specified user for links, and creates a small html file with those links.

##Setup
You'll need to use [dev.twitter.com](https://dev.twitter.com) to create API and access tokens for yourself.

From there, create a file called `keys.yml` Use the `keys_template.yml.example` for a template.

Change the username in line 7 to whoever you wish.
`username = "rjhallsted"`

Once that's done, navigate to the project directory in terminal, run `ruby main.rb` and you'll now have an html file in the links folder with the links filtered from that person's twitter feed.

##Notes
Currently, the tweets are filtered to exclude links to twitter and instagram.
