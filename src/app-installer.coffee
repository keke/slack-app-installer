express = require 'express'
bodyParser = require 'body-parser'
winston = require 'winston'
request = require 'request'

class SlackAppInstaller
  constructor: (config) ->
    # winston.info config.port
    @webserver = express()
    @config = config

    @webserver.use(bodyParser.json())
    @webserver.use(bodyParser.urlencoded({ extended: true }))

    if config.public_folder
      @webserver.use(express.static(__dirname + config.public_folder))

    @createOauthEndpoints (cb)->

      call_api = (command, options, cb) ->
        @winston.info('** API CALL: ' + 'https://slack.com/api/' + command);
        request.post('https://slack.com/api/' + command, (error, response, body) ->
          slack_botkit.debug('Got response', error, body);
          if not error and response.statusCode is 200
            json = JSON.parse(body);
            if json.ok
              if cb then cb(null, json)
            else
              if cb then cb(json.error, json)
          else
            if cb then cb(error)
        ).form(options)

      oauth_access = (options, cb) ->
        call_api('oauth.access', options, cb)


      auth_test= (options, cb) ->
        call_api('auth.test', options, cb)

      @webserver.get '/oauth', (res, resp)->
        code = req.query.code
        state = req.query.state

        opts =
          client_id: slack_botkit.config.clientId
          client_secret: slack_botkit.config.clientSecret
          code: code



  boot: ()->
    config = @config

    @server = @webserver.listen config.port, ()->
      winston.info "Start webserver on #{config.port}"

  createOauthEndpoints: (callback) ->




module.exports = SlackAppInstaller