# @cjsx React.DOM
React = require 'react'
UserActions = require '../actions/UserActions'
UserStore = require '../stores/UserStore'
Form = require './Form'
Input = require './Input'
PasswordResetModal = require './PasswordResetModal'

errorMsg =
  name:
    111: 'Name is required'
    134: 'Name should be no longer than 100 characters'
  email:
    111: 'Email is required'
    120: 'Email is invalid'
  oldPassword:
    111: 'Current password is required'
    133: 'Password must be at least 6 characters long'
    134: 'Password should be no longer than 50 characters'
    214: 'Password is wrong'
  password:
    111: 'Password is required'
    133: 'Password must be at least 6 characters long'
    134: 'Password should be no longer than 50 characters'

SettingsProfile = React.createClass
  mixins: [Form]

  getInitialState: ->
    fields: ['name', 'email', 'oldPassword', 'password']
    name: {}
    email: {}
    oldPassword: {}
    password: {}
    submitted: false
    submitting: false

  componentDidMount: ->
    UserStore.on 'change', @onSubmitSuccess
    UserStore.on 'error', @onSubmitFailed

  componentWillUnmount: ->
    UserStore.off 'change', @onSubmitSuccess
    UserStore.off 'error', @onSubmitFailed

  render: ->
    <form className="settings-form" onSubmit={@handleSubmit}>
      <div className="input-group settings-input-group">
        <label className="settings-input-label">Name</label>
        <div className="settings-input-content">
          <Input
            type="text"
            ref="name"
            className="input settings-input"
            onChange={@handleChange.bind(@, 'name')}
            maxLength={100}
            defaultValue={@props.data.name}
            required/>
          {@errorMessage('name')}
        </div>
      </div>
      <div className="input-group settings-input-group">
        <label className="settings-input-label">Email</label>
        <div className="settings-input-content">
          <Input
            type="email"
            ref="email"
            className="input settings-input"
            onChange={@handleChange.bind(@, 'email')}
            defaultValue={@props.data.email}
            required/>
          {@errorMessage('email')}
        </div>
      </div>
      <div className="input-group settings-input-group">
        <label className="settings-input-label">
          <div>Password</div>
          <a className="settings-label-link" onClick={@resetPassword}>Forgot password?</a>
        </label>
        <div className="settings-input-content">
          <div className="settings-input-password">
            <Input
              type="password"
              ref="oldPassword"
              className="input settings-input"
              onChange={@handleChange.bind(@, 'oldPassword')}
              minLength={6}
              maxLength={50}
              placeholder="Current password"/>
            {@errorMessage('oldPassword')}
          </div>
          <div className="settings-input-password">
            <Input
              type="password"
              ref="password"
              className="input settings-input"
              onChange={@handleChange.bind(@, 'password')}
              minLength={6}
              maxLength={50}
              placeholder="New password"/>
            {@errorMessage('password')}
          </div>
        </div>
      </div>
      <div className="input-group settings-input-group">
        <div className="settings-input-content">
          <button type="submit" className="btn primary">Save</button>
        </div>
      </div>
      <PasswordResetModal data={@props.data} ref="modal"/>
    </form>

  errorMessage: (field) ->
    msg = errorMsg[field][@state[field].error]

    if msg and @state.submitted
      <div className="settings-input-error">{msg}</div>

  handleSubmit: (e) ->
    e.preventDefault()

    @setState submitted: true unless @state.submitted
    return unless @validateFields @state.fields

    return if @state.submitting
    @setState submitting: true

    UserActions.update @props.data.id,
      name: @state.name.value
      email: @state.email.value
      old_password: @state.oldPassword.value
      password: @state.password.value

  onSubmitSuccess: ->
    user = UserStore.get()

    @setState
      submitting: false
      submitted: false

    @refs.name.setValue user.name
    @refs.email.setValue user.email
    @refs.oldPassword.clear()
    @refs.password.clear()

  onSubmitFailed: (err) ->
    field = if err.field is 'old_password' then 'oldPassword' else err.field

    state = {}
    state[field] = err
    state.submitting = false

    @setState state

  resetPassword: ->
    @refs.modal.show()

module.exports = SettingsProfile