Videojuicer Core SDK
====================

The Videojuicer Core SDK is a library for conveniently working with the [Videojuicer](http://videojuicer.com) Core API service.

Drop-in Rails/Merb compatibility
--------------------------------

The models in this SDK present a familiar ORM-style interface onto all the objects in the remote API. Users of ActiveRecord or DataMapper should feel right at home:

	presentation = Videojuicer::Presentation.new(:title=>"Hello World")
	presentation.valid? #=> true
	presentation.save #=> true
	
Validations, creation, updates and deleting records all behave as you'd expect from these libraries.

Getting started
===============

Getting started is easy. First off, you'll need to be a Videojuicer customer with access to a Videojuicer Seed. You'll also need to  [register for a consumer key](http://api.videojuicer.com/oauth/consumers).

The Core API uses [OAuth](http://oauth.net) as a security and authorisation mechanism, and the SDK acts as an OAuth client.

To get started you will need:

* Your seed name
* Your username and password
* Your consumer key
* Your consumer secret

Authorizing the SDK to work with your account
---------------------------------------------

	require 'rubygems'
	require 'videojuicer'

	#
	@seed_name = your_seed_name
	@consumer_key = your_consumer_key
	@consumer_secret = your_consumer_secret
	#
	# ----------------------
	# OAuth Stage 1
	# ----------------------
	#
	# Create a VJ Session
	@api_session = Videojuicer::Session.new(	
									:seed_name=>@seed_name,
									:consumer_key=>@consumer_key,
									:consumer_secret=>@consumer_secret
								)
	# Get the OAuth Request token
	@request_token = @api_session.get_request_token
	# Get the authorization URL for your token
	@auth_url = @api_session.authorize_url(
              	"oauth_token"					=>	@request_token["oauth_token"], 
              	"oauth_token_secret"	=>	@request_token["oauth_token_secret"],
								"oauth_callback"			=>	a_url_where_to_which_you_want_the_user_directed_after_authorization
            	)
	#
	# ----------------------
	# OAuth Stage 2
	# Direct the user to the @auth_url - they will be asked for their username and password.
	# ----------------------
	#
	# ----------------------
	# OAuth Stage 3
	# Exchange the Request token for an Access token
	# ----------------------
	#
	@access_token = @api_session.exchange_request_token(
                    "oauth_token"					=>	@request_token["oauth_token"], 
                    "oauth_token_secret"	=>	@request_token["oauth_token_secret"]
                  )
	#
	# ----------------------
	# Authorization complete
	# Store the access token for later use
	# ----------------------
	
Working with the authorized access token
----------------------------------------

	@api_session = 	Videojuicer::Session.new(
										:seed_name=>@seed_name,
										:consumer_key=>@consumer_key,
										:consumer_secret=>@consumer_secret,
										:token=>@access_token["oauth_token"],
										:token_secret=>@access_token["oauth_token_secret"]
									)
	# The session is now properly configured and authorized. You can just work within it like so:
	@api_session.scope do
		Videojuicer::User.all #=> [<Videojuicer::User ................. >]
	end
	
You may also do one-off setup of the SDK as follows:

	Videojuicer.configure!(
								:seed_name=>@seed_name,
								:consumer_key=>@consumer_key,
								:consumer_secret=>@consumer_secret,
								:token=>@access_token["oauth_token"],
								:token_secret=>@access_token["oauth_token_secret"]
							)
	Videojuicer::User.all #=> [<Videojuicer::User ................. >]