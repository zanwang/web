React = require 'react'

module.exports =
  handleChange: (field, data) ->
    state = {}
    state[field] = data
    @setState state

  validateFields: (fields) ->
    for i in fields
      return false unless @state[i].valid

    true