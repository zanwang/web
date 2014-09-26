AppDispatcher = require '../dispatchers/AppDispatcher'
APIRequest = require '../utils/APIRequest'
Actions = require '../constants/Actions'

module.exports =
  list: (id) ->
    APIRequest 'GET', "domains/#{id}/records"
      .end AppDispatcher.handleServerAction Actions.RECORD_LIST_SUCCESS, Actions.RECORD_LIST_FAILED

  create: (id, data) ->
    APIRequest 'POST', "domains/#{id}/records"
      .send data
      .end AppDispatcher.handleServerAction Actions.RECORD_CREATE_SUCCESS, Actions.RECORD_CREATE_FAILED

  update: (id, data) ->
    APIRequest 'PUT', 'records/' + id
      .send data
      .end AppDispatcher.handleServerAction Actions.RECORD_UPDATE_SUCCESS, Actions.RECORD_UPDATE_FAILED

  destroy: (id) ->
    APIRequest 'DELETE', 'records/' + id
      .end AppDispatcher.handleServerAction Actions.RECORD_DESTROY_SUCCESS, Actions.RECORD_DESTROY_FAILED, id: id