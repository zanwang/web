# @cjsx React.DOM
React = require 'react'
cx = require 'react/lib/cx'
Router = require 'react-router'
Link = Router.Link
Input = require './Input'
Form = require './Form'
TokenActions = require '../actions/TokenActions'
TokenStore = require '../stores/TokenStore'

errorMsg =
  email:
    111: 'Email is required'
    120: 'Email is invalid'
    218: <span>Don&apos;t have an account? <Link to="signup">Sign up</Link></span>
  password:
    111: 'Password is required'
    133: 'Password must be at least 6 characters long'
    134: 'Password should be no longer than 50 characters'
    214: <span>Password is wrong. Did you <Link to="password-reset">forgot your password</Link>?</span>
    215: <span>Password hasn&apos;t set before. <Link to="password-reset">Set password</Link></span>

LoginForm = React.createClass
  mixins: [Form]

  getInitialState: ->
    fields: ['email', 'password']
    email: {}
    password: {}
    submitted: false
    submitting: false

  componentDidMount: ->
    TokenStore.on 'change', @onSubmitSuccess
    TokenStore.on 'error', @onSubmitFailed

  componentWillUnmount: ->
    TokenStore.off 'change', @onSubmitSuccess
    TokenStore.off 'error', @onSubmitFailed

  render: ->
    classes = cx
      submitted: @state.submitted

    <form id="login-form" onSubmit={@handleSubmit} className={classes}>
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
      <button id="login-btn" className="btn primary">Log in</button>
    </form>

  errorMessage: (field) ->
    msg = errorMsg[field][@state[field].error]

    if msg
      <div className="input-error">{msg}</div>

  handleSubmit: (e) ->
    e.preventDefault()

    @setState submitted: true unless @state.submitted
    return unless @validateFields @state.fields

    return if @state.submitting
    @setState submitting: true

    TokenActions.create
      email: @state.email.value
      password: @state.password.value

  onSubmitSuccess: ->
    console.log 'success'

  onSubmitFailed: (err) ->
    state = {}
    state[err.field] = err
    state.submitting = false

    @setState state

module.exports = LoginForm