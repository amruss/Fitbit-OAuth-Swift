# Fitbit-OAuth-Swift
Hey guys! Here's a project I was working on for iOS that connects with the Fitbit API. Becuase of some limitations set by Apple, I can't program a native app with the functionality I wanted. 
There's a button that will open up a browser and allow you to sign into Fitbit and then a table will be populated with your alarms.

The Fitbit API can be a bit tricky. I used the OAuth Swift library to set up API calls : https://github.com/OAuthSwift/OAuthSwift.

Feel free to use this code to build your own iOS app that connects with Fitbit. You will need to register your app with Fitbit and add your own Consumer Secret and Key in the Services.plist, and change to callback URL in API calls.
