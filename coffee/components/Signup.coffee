# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
Link = Router.Link
SignupForm = require './SignupForm'
LoginFooter = require './LoginFooter'
Modal = require './Modal'

Signup = React.createClass
  componentDidMount: ->
    document.title = 'Sign up - maji.moe'

  render: ->
    <div id="login-wrap">
      <div id="login-body">
        <SignupForm showModal={@showModal}/>
        <div id="login-links">
          Already have an account? <strong><Link to="login" className="login-link">Log in</Link></strong>
        </div>
      </div>
      <LoginFooter/>
      <Modal title="You're almost done!" dismiss={false} ref="modal">
        <p>Please check the activation email in your mailbox to go on.</p>
      </Modal>
    </div>

  showModal: ->
    @refs.modal.open()

module.exports = Signup