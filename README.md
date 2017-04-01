# Finance App
# Setup

To setup this app the following commands need to be run in the project directory.

``bundle``

``whenever --update-cron``

# Daemons

The following daemons are required to run 

``bundle exec sidekiq -q default``

``redis-server``

``bin/rails server``

Then go to ``http://localhost:3000``
