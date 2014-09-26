AppDispatcher = require '../dispatchers/AppDispatcher'
EventEmitter = require '../utils/EventEmitter'
Actions = require '../constants/Actions'

class RecordStore extends EventEmitter
  data: {}

  get: (id) ->
    @data[id]

  set: (id, data) ->
    @data[id] = data

  del: (id) ->
    @data[id] = null

  list: (domainId) ->
    arr = []

    for i, item of @data
      arr.push item if item and item.domain_id is domainId

    arr

store = new RecordStore()

AppDispatcher.register (payload) ->
  switch payload.action
    when Actions.RECORD_LIST_SUCCESS
      for item in payload.data
        store.set item.id, item

      store.emit 'change'

    when Actions.RECORD_CREATE_SUCCESS, Actions.RECORD_UPDATE_SUCCESS
      data = payload.data
      store.set data.id, data
      store.emit 'change'

    when Actions.RECORD_DESTROY_SUCCESS
      store.del payload.data.id
      store.emit 'change'

    when Actions.RECORD_LIST_FAILED, Actions.RECORD_CREATE_FAILED, Actions.RECORD_UPDATE_FAILED, Actions.RECORD_DESTROY_FAILED
      store.emit 'error', payload.data

  true

module.exports = store