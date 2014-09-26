# @cjsx React.DOM
React = require 'react'
cx = require 'react/lib/cx'
_ = require 'lodash'
validator = require 'validator'
Error = require '../constants/Error'

Input = React.createClass
  propTypes:
    id: React.PropTypes.string
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
    domainName: React.PropTypes.bool
    options: React.PropTypes.object
    disabled: React.PropTypes.bool

  getDefaultProps: ->
    type: 'text'

  getInitialState: ->
    state =
      value: @props.defaultValue

    @validate state

    state

  componentWillMount: ->
    @props.onChange @state if @props.onChange

  render: ->
    if @props.type is 'select'
      options = []

      for name, value of @props.options
        options.push <option key={value} value={value}>{name}</option>

      classes = {}

      for i in @props.className.split(' ')
        classes[i] = true

      _.extend classes,
        focus: @state.focus

      <label id={@props.id} className={cx(classes)} data-value={@getSelectedKey()}>
        <select
          onChange={@handleChange}
          onFocus={@handleFocus}
          onBlur={@handleBlur}
          value={@state.value}
          disabled={@props.disabled}>{options}</select>
      </label>
    else
      <input
        id={@props.id}
        type={@props.type}
        className={@props.className}
        placeholder={@props.placeholder}
        min={@props.min}
        max={@props.max}
        value={@state.value}
        disabled={@props.disabled}
        onChange={@handleChange}/>

  getSelectedKey: ->
    value = @state.value

    for key, val of @props.options
      return key if `val == value`

  validate: (state) ->
    value = state.value

    if value
      if @props.type is 'email' and !validator.isEmail value
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
      else if @props.domainName and !/^[a-zA-Z\d\-]+$/.test value
        state.error = Error.DomainName
      else
        state.error = 0
    else if @props.required
      state.error = Error.Required
    else
      state.error = 0

    state.valid = state.error is 0

  handleChange: (e) ->
    elem = e.target

    switch @props.type
      when 'checkbox' then value = elem.checked
      else value = elem.value

    @setValue value

  handleFocus: ->
    @setState focus: true

  handleBlur: ->
    @setState focus: false

  setValue: (value) ->
    state =
      value: value

    @validate state
    @setState state
    @props.onChange state

  clear: ->
    @setState
      value: ''

module.exports = Input