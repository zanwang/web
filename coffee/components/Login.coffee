# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
Link = Router.Link
LoginForm = require './LoginForm'
LoginFooter = require './LoginFooter'

Login = React.createClass
  componentDidMount: ->
    document.title = 'Log in - maji.moe'

  render: ->
    <div id="login-wrap">
      <div id="login-body">
        <LoginForm/>
        <div id="login-links">
          <Link to="password-reset" className="login-link right">Forgot password?</Link>
          <Link to="signup" className="login-link right">Sign up</Link>
        </div>
      </div>
      <LoginFooter/>
    </div>

module.exports = Login