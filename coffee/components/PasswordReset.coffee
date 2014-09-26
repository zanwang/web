# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
Link = Router.Link
LoginFooter = require './LoginFooter'
PasswordResetForm = require './PasswordResetForm'
Modal = require './Modal'

PasswordReset = React.createClass
  componentDidMount: ->
    document.title = 'Reset password - maji.moe'

  render: ->
    <div id="login-wrap">
      <div id="login-body">
        <PasswordResetForm onSubmit={@showModal}/>
        <div id="login-links">
          <Link to="login" className="login-link">Log in</Link>
        </div>
      </div>
      <LoginFooter/>
      <Modal title="Check your email" canDismiss={false} ref="modal">
        <p>We sent you an email with instructions for resetting your password.</p>
      </Modal>
    </div>

  showModal: ->
    @refs.modal.show()

module.exports = PasswordReset