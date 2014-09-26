AppDispatcher = require '../dispatchers/AppDispatcher'
EventEmitter = require '../utils/EventEmitter'
Actions = require '../constants/Actions'

class DomainStore extends EventEmitter
  data: {}

  get: (id) ->
    @data[id]

  set: (id, data) ->
    @data[id] = data

  del: (id) ->
    @data[id] = null

  list: ->
    arr = []

    for i, item of @data
      arr.push item if item

    arr

store = new DomainStore()

AppDispatcher.register (payload) ->
  switch payload.action
    when Actions.DOMAIN_LIST_SUCCESS
      for item in payload.data
        store.set item.id, item

      store.emit 'change'

    when Actions.DOMAIN_CREATE_SUCCESS, Actions.DOMAIN_UPDATE_SUCCESS, Actions.DOMAIN_GET_SUCCESS
      data = payload.data
      store.set data.id, data
      store.emit 'change'

    when Actions.DOMAIN_DESTROY_SUCCESS
      store.del payload.data.id
      store.emit 'change'

    when Actions.DOMAIN_CREATE_FAILED, Actions.DOMAIN_UPDATE_FAILED, Actions.DOMAIN_GET_FAILED, Actions.DOMAIN_LIST_FAILED, Actions.DOMAIN_DESTROY_FAILED
      store.emit 'error', payload.data

  true

module.exports = store