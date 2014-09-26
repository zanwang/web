# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
Link = Router.Link
Form = require './Form'
Input = require './Input'
UserActions = require '../actions/UserActions'
UserStore = require '../stores/UserStore'

errorMsg =
  name:
    111: 'Name is required'
    134: 'Name should be no longer than 100 characters'
  email:
    111: 'Email is required'
    120: 'Email is invalid'
    212: <span>Already have an account? <Link to="login">Log in</Link></span>
  password:
    111: 'Password is required'
    133: 'Password must be at least 6 characters long'
    134: 'Password should be no longer than 50 characters'

SignupForm = React.createClass
  mixins: [Form]

  propTypes:
    onSubmit: React.PropTypes.func

  getInitialState: ->
    fields: ['name', 'email', 'password']
    name: {}
    email: {}
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
    <form id="login-form">
      <div className="input-group">
        <Input
          type="text"
          className="input login-input"
          placeholder="Name"
          onChange={@handleChange.bind(@, 'name')}
          required
          maxLength={100}/>
        {@errorMessage('name')}
      </div>
      <div className="input-group">
        <Input
          type="email"
          className="input login-input"
          placeholder="Email"
          onChange={@handleChange.bind(@, 'email')}
          required/>
        {@errorMessage('email')}
      </div>
      <div className="input-group">
        <Input
          type="password"
          className="input login-input"
          placeholder="Password"
          onChange={@handleChange.bind(@, 'password')}
          required
          minLength={6}
          maxLength={50}/>
        {@errorMessage('password')}
      </div>
      <button id="login-btn" className="btn primary">Sign up</button>
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

    UserActions.create
      name: @state.name.value
      email: @state.email.value
      password: @state.password.value

  onSubmitSuccess: ->
    @props.onSubmit() if @props.onSubmit

  onSubmitFailed: (err) ->
    state = {}
    state[err.field] = err
    state.submitting = false

    @setState state

module.exports = SignupForm