AppDispatcher = require '../dispatchers/AppDispatcher'
APIRequest = require '../utils/APIRequest'
Actions = require '../constants/Actions'

module.exports =
  reset: (data) ->
    APIRequest 'POST', 'passwords/reset'
      .send data
      .end AppDispatcher.handleServerAction Actions.PASSWORD_RESET_SUCCESS, Actions.PASSWORD_RESET_FAILED