# @cjsx React.DOM
React = require 'react'
validator = require 'validator'
Error = require '../constants/Error'

Input = React.createClass
  propTypes:
    type: React.PropTypes.string
    className: React.PropTypes.string
    placeholder: React.PropTypes.string
    required: React.PropTypes.bool
    minLength: React.PropTypes.number
    maxLength: React.PropTypes.number
    onChange: React.PropTypes.func
    pattern: React.PropTypes.instanceOf RegExp
    min: React.PropTypes.number
    max: React.PropTypes.number

  getDefaultProps: ->
    type: 'text'

  getInitialState: ->
    state =
      value: @props.defaultValue

    @validate state

    state

  componentWillMount: ->
    @props.onChange @state

  render: ->
    <input
      type={@props.type}
      className={@props.className}
      placeholder={@props.placeholder}
      value={@state.value}
      onChange={@handleChange}/>

  validate: (state) ->
    value = state.value

    if @props.required and !value
      state.error = Error.Required
    else if @props.type is 'email' and !validator.isEmail value
      state.error = Error.Email
    else if @props.pattern? and !@props.pattern.test value
      state.error = Error.Pattern
    else if @props.min? and value < @props.min
      state.error = Error.Min
    else if @props.max? and value > @props.max
      state.error = Error.Max
    else if @props.minLength? and value.length < @props.minLength
      state.error = Error.MinLength
    else if @props.maxLength? and value.length > @props.maxLength
      state.error = Error.MaxLength
    else if @props.equal? and value isnt @props.equal
      state.error = Error.Equal
    else
      state.error = 0

    state.valid = state.error is 0

  handleChange: (e) ->
    elem = e.target

    switch elem.type
      when 'checkbox' then value = elem.checked
      else value = elem.value

    state =
      value: value

    @validate state
    @setState state
    @props.onChange state

module.exports = Input