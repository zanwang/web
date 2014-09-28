# @cjsx React.DOM
React = require 'react'

LoginFooter = React.createClass
  render: ->
    <footer id="footer-logo-wrap">
      <a href="/" id="footer-logo">maji.moe</a>
    </footer>

module.exports = LoginFooter