# @cjsx React.DOM
React = require 'react'

Container = React.createClass
  render: ->
    <@props.activeRouteHandler/>

module.exports = Container