AppDispatcher = require '../dispatchers/AppDispatcher'
APIRequest = require '../utils/APIRequest'
Actions = require '../constants/Actions'

module.exports =
  create: (data) ->
    APIRequest 'POST', 'users'
      .send data
      .end AppDispatcher.handleServerAction Actions.USER_CREATE_SUCCESS, Actions.USER_CREATE_FAILED

  get: (id) ->
    APIRequest 'GET', 'users/' + id
      .end AppDispatcher.handleServerAction Actions.USER_GET_SUCCESS, Actions.USER_GET_FAILED

  update: (id, data) ->
    APIRequest 'PUT', 'users/' + id
      .send data
      .end AppDispatcher.handleServerAction Actions.USER_UPDATE_SUCCESS, Actions.USER_UPDATE_FAILED