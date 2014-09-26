# @cjsx React.DOM
React = require 'react'
Spinner = require 'spin.js'

Loading = React.createClass
  propTypes:
    lines: React.PropTypes.number
    length: React.PropTypes.number
    width: React.PropTypes.number
    radius: React.PropTypes.number
    rotate: React.PropTypes.number
    corners: React.PropTypes.number
    direction: React.PropTypes.number
    speed: React.PropTypes.number
    trail: React.PropTypes.number
    opacity: React.PropTypes.number
    zIndex: React.PropTypes.number
    className: React.PropTypes.string
    color: React.PropTypes.string
    shadow: React.PropTypes.bool
    hwaccel: React.PropTypes.bool
    top: React.PropTypes.string
    left: React.PropTypes.string
    position: React.PropTypes.string

  getDefaultProps: ->
    lines: 12
    length: 7
    width: 5
    radius: 10
    rotate: 0
    corners: 1
    direction: 1
    speed: 1
    trail: 100
    opacity: 0.25
    zIndex: 2e9
    className: 'spinner'
    color: '#000'
    shadow: false
    hwaccel: false
    top: '50%'
    left: '50%'
    position: 'absolute'

  componentDidMount: ->
    spinner = new Spinner @props
    spinner.spin @refs.spinner.getDOMNode()

  render: ->
    <div ref="spinner"/>

module.exports = Loading