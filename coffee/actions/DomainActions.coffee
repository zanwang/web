AppDispatcher = require '../dispatchers/AppDispatcher'
APIRequest = require '../utils/APIRequest'
Actions = require '../constants/Actions'
TokenStore = require '../stores/TokenStore'

module.exports =
  list: ->
    token = TokenStore.get()

    APIRequest 'GET', "users/#{token.user_id}/domains"
      .end AppDispatcher.handleServerAction Actions.DOMAIN_LIST_SUCCESS, Actions.DOMAIN_LIST_FAILED

  create: (data) ->
    token = TokenStore.get()

    APIRequest 'POST', "users/#{token.user_id}/domains"
      .send data
      .end AppDispatcher.handleServerAction Actions.DOMAIN_CREATE_SUCCESS, Actions.DOMAIN_CREATE_FAILED

  get: (id) ->
    APIRequest 'GET', 'domains/' + id
      .end AppDispatcher.handleServerAction Actions.DOMAIN_GET_SUCCESS, Actions.DOMAIN_GET_FAILED

  destroy: (id) ->
    APIRequest 'DELETE', 'domains/' + id
      .end AppDispatcher.handleServerAction Actions.DOMAIN_DESTROY_SUCCESS, Actions.DOMAIN_DESTROY_FAILED, id: id