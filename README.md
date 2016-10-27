# Keep Ruby Queued

## What

This is an app that let's people queue up for an activity (such as getting a caricture drawing made) and be texted when they are next in line.

## Install

```
$ bundle install
```

You'll need a Twilio account and a phone number from them. Locally you'll need a `.env` file with a ton of environment variables:

```
#.env file
TWILIO_SID=<the SID of your twilio account>
TWILIO_TOKEN=<the token of your twilio account>
TWILIO_PHONE_NUMBER=<your twilio phone number>
APP_HOST=localhost:3000
ADMIN_PASSWORD=password
```

The `APP_HOST` is the host of the website you are using, for development it should be `localhost:3000` in production it should be the url of your website.

The admin password is used for basic auth.

Once you have all those things set you can boot the app

```
$ rails s
```

## Queue up

As a user enter your name and phone number. You'll recieve a confirmation message. Click on the message to confirm your phone number and you'll be entered into the queue.

Go about your buisness, when ready you'll get a text message letting you know that you're next and you need to go get in a physical line.


## Pop the Queue

If you're running the app you'll need to notify new users when they need to line up in real life. For that you can visit `/admin` path. Enter the username of `admin` all lowercase and the password that you set in the environment variable ADMIN_PASSWORD.

Once in, hit the "Notify Next" button, this will send the next person in line a text message letting them know to come to you.

When you're done with that person you can hit the "finished" button next to their name, which will clear them from the queue. Don't forget to hit "Notify Next" to let the next person get in line.

## License

MIT

Copyright Richard Schneeman 2016