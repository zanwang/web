# @cjsx React.DOM
React = require 'react'

AppFooter = React.createClass
  render: ->
    <footer id="footer">
      <div id="footer-links">&copy; 2014 maji.moe</div>
      <div id="footer-logo">maji.moe</div>
    </footer>

module.exports = AppFooter