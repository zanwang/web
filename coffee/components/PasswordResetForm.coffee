# @cjsx React.DOM
React = require 'react'
Form = require './Form'
Input = require './Input'
PasswordActions = require '../actions/PasswordActions'
PasswordStore = require '../stores/PasswordStore'

errorMsg =
  email:
    111: 'Email is required'
    120: 'Email is invalid'
    218: 'User does not exist'

PasswordResetForm = React.createClass
  mixins: [Form]

  propTypes:
    onSubmit: React.PropTypes.func

  getInitialState: ->
    fields: ['email']
    email: {}
    submitted: false
    submitting: false

  componentDidMount: ->
    PasswordStore.on 'change', @onSubmitSuccess
    PasswordStore.on 'error', @onSubmitFailed

  componentWillUnmount: ->
    PasswordStore.off 'change', @onSubmitSuccess
    PasswordStore.off 'error', @onSubmitFailed

  render: ->
    <form id="login-form" onSubmit={@handleSubmit}>
      <div className="input-group">
        <Input
          type="email"
          className="input login-input"
          placeholder="Email"
          onChange={@handleChange.bind(@, 'email')}
          required/>
        {@errorMessage('email')}
      </div>
      <button id="login-btn" className="btn primary">Reset password</button>
    </form>

  errorMessage: (field) ->
    msg = errorMsg[field][@state[field].error]

    if msg and @state.submitted
      <div className="input-error">{msg}</div>

  handleSubmit: (e) ->
    e.preventDefault()

    @setState submitted: true unless @state.submitted
    return unless @validateFields @state.fields

    return if @state.submitting
    @setState submitting: true

    PasswordActions.reset
      email: @state.email.value

  onSubmitSuccess: ->
    @props.onSubmit() if @props.onSubmit

  onSubmitFailed: (err) ->
    state = {}
    state[err.field] = err
    state.submitting = false

    @setState state

module.exports = PasswordResetForm