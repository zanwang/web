# @cjsx React.DOM
React = require 'react'
cx = require 'react/lib/cx'

Dropdown = React.createClass
  getInitialState: ->
    isShown: false

  componentDidMount: ->
    document.body.addEventListener 'click', @handleBodyClick

  componentWillUnmount: ->
    document.body.removeEventListener 'click', @handleBodyClick

  render: ->
    classes = cx
      dropdown: true
      on: @state.isShown

    <ul className={classes}>
      {@props.children}
    </ul>

  show: ->
    @setState
      isShown: true

  hide: ->
    @setState
      isShown: false

  toggle: ->
    if @state.isShown
      @hide()
    else
      @show()

  handleBodyClick: (e) ->
    return unless @state.isShown

    e.preventDefault()
    e.stopPropagation() unless e.target.classList.contains 'dropdown-link'
    @hide()

module.exports = Dropdown