AppDispatcher = require '../dispatchers/AppDispatcher'
APIRequest = require '../utils/APIRequest'
Actions = require '../constants/Actions'

module.exports =
  create: (data) ->
    APIRequest 'POST', 'tokens'
      .send data
      .end AppDispatcher.handleServerAction Actions.TOKEN_CREATE_SUCCESS, Actions.TOKEN_CREATE_FAILED

  update: ->
    APIRequest 'PUT', 'tokens'
      .end AppDispatcher.handleServerAction Actions.TOKEN_UPDATE_SUCCESS, Actions.TOKEN_UPDATE_FAILED

  destroy: ->
    APIRequest 'DELETE', 'tokens'
      .end AppDispatcher.handleServerAction Actions.TOKEN_DESTROY_SUCCESS, Actions.TOKEN_DESTROY_FAILED