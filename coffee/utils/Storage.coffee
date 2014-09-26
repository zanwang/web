class Storage
  prefix: 'mm_'

  _key: (key) ->
    @prefix + key

  get: (key) ->
    throw new Error 'Key is required' unless key?

    data = localStorage.getItem @_key(key)
    JSON.parse data if data

  set: (key, value) ->
    throw new Error 'Key is required' unless key?
    throw new Error 'Value is required' unless value?

    localStorage.setItem @_key(key), JSON.stringify value

  del: (key) ->
    throw new Error 'Key is required' unless key?

    localStorage.removeItem @_key(key)

  clear: ->
    localStorage.clear()

module.exports = new Storage()