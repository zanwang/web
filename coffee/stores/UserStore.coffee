AppDispatcher = require '../dispatchers/AppDispatcher'
EventEmitter = require '../utils/EventEmitter'
Actions = require '../constants/Actions'

class UserStore extends EventEmitter
  data: null

  get: ->
    @data

  set: (data) ->
    @data = data

  del: ->
    @data = null

store = new UserStore()

AppDispatcher.register (payload) ->
  switch payload.action
    when Actions.USER_CREATE_SUCCESS
      store.set payload.data
      store.emit 'change'
    when Actions.USER_CREATE_FAILED
      store.emit 'error', payload.data

  true

module.exports = store