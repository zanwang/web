AppDispatcher = require '../dispatchers/AppDispatcher'
APIRequest = require '../utils/APIRequest'
Actions = require '../constants/Actions'

module.exports =
  create: (data) ->
    APIRequest 'POST', 'users'
      .send data
      .end AppDispatcher.handleServerAction Actions.USER_CREATE_SUCCESS, Actions.USER_CREATE_FAILED