# @cjsx React.DOM
React = require 'react'

AppHeader = require './AppHeader'
AppFooter = require './AppFooter'

App = React.createClass
  render: ->
    <div>
      <AppHeader/>
      <div id="app-inner" className="inner">
        <@props.activeRouteHandler/>
        <AppFooter/>
      </div>
    </div>

module.exports = App