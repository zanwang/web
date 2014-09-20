request = require 'superagent'
TokenStore = require '../stores/TokenStore'
url = require 'url'

if process.env.NODE_ENV is 'prod'
  BASE_URL = 'https://maji.moe/api/v1/'
else
  BASE_URL = 'http://localhost:9000/api/v1/'

module.exports = (method, path) ->
  req = request method, url.resolve BASE_URL, path
  token = TokenStore.get()

  req.set 'Authorization', "token #{token.key}" if token

  req