# @cjsx React.DOM
React = require 'react'
PasswordActions = require '../actions/PasswordActions'
PasswordStore = require '../stores/PasswordStore'

Input = require './Input'
Modal = require './Modal'

PasswordResetModal = React.createClass
  getInitialState: ->
    error: {}

  componentDidMount: ->
    PasswordStore.on 'change', @onSubmitSuccess
    PasswordStore.on 'error', @onSubmitFailed

  componentWillUnmount: ->
    PasswordStore.off 'change', @onSubmitSuccess
    PasswordStore.off 'error', @onSubmitFailed

  render: ->
    <Modal
      title="Reset password"
      ref="modal">
      <p>Did you forget your password? We will send an email with instructions to help you reset your password.</p>
      <div className="modal-footer">
        <a className="btn modal-btn primary" onClick={@handleSubmit}>Send</a>
        <a className="btn modal-btn">Cancel</a>
      </div>
      {@errorMessage()}
    </Modal>

  errorMessage: ->
    if @state.error.error
      <div className="modal-error">{@state.error.message}</div>

  show: ->
    @refs.modal.show()

  handleSubmit: ->
    PasswordActions.reset
      email: @props.data.email

  onSubmitSuccess: ->
    @refs.modal.hide()

  onSubmitFailed: (err) ->
    @setState
      error: err

module.exports = PasswordResetModal