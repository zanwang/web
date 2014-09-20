# @cjsx React.DOM
React = require 'react'

LoginFooter = React.createClass
  render: ->
    <footer id="login-footer">
      <a href="/" id="login-footer-home">maji.moe</a>
    </footer>

module.exports = LoginFooter