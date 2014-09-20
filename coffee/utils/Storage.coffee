module.exports =
  _key: (key) ->
    'mm_' + key

  get: (key) ->
    throw new Error 'Key is required' unless key?

    data = localStorage.getItem @_key(key)
    JSON.parse data if data

  set: (key, value) ->
    throw new Error 'Key is required' unless key?

    localStorage.setItem @_key(key), JSON.stringify value

  del: (key) ->
    throw new Error 'Key is required' unless key?

    localStorage.removeItem @_key(key)

  clear: ->
    localStorage.clear()