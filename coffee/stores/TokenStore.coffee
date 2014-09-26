AppDispatcher = require '../dispatchers/AppDispatcher'
EventEmitter = require '../utils/EventEmitter'
Actions = require '../constants/Actions'
Storage = require '../utils/Storage'

class TokenStore extends EventEmitter
  data: null

  get: ->
    @data

  set: (data) ->
    @data = data
    Storage.set 'token', data if data

  del: ->
    @data = null
    Storage.del 'token'

store = new TokenStore()
store.set Storage.get 'token'

AppDispatcher.register (payload) ->
  switch payload.action
    when Actions.TOKEN_CREATE_SUCCESS, Actions.TOKEN_UPDATE_SUCCESS
      store.set payload.data
      store.emit 'change'

    when Actions.TOKEN_DESTROY_SUCCESS
      store.del()
      store.emit 'change'

    when Actions.TOKEN_CREATE_FAILED, Actions.TOKEN_UPDATE_FAILED, Actions.TOKEN_DESTROY_FAILED
      store.del()
      store.emit 'error', payload.data

  true

module.exports = store