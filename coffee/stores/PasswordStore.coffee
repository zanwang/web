AppDispatcher = require '../dispatchers/AppDispatcher'
EventEmitter = require '../utils/EventEmitter'
Actions = require '../constants/Actions'

class PasswordStore extends EventEmitter
  #

store = new PasswordStore()

AppDispatcher.register (payload) ->
  switch payload.action
    when Actions.PASSWORD_RESET_SUCCESS
      store.emit 'change'
    when Actions.PASSWORD_RESET_FAILED
      store.emit 'error', payload.data

  true

module.exports = store