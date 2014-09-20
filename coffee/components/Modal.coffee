# @cjsx React.DOM
React = require 'react'
cx = require 'react/lib/cx'

_id = 0

Modal = React.createClass
  propTypes:
    title: React.PropTypes.string
    canDismiss: React.PropTypes.bool

  getDefaultProps: ->
    canDismiss: true

  getInitialState: ->
    id: _id++
    isShown: false

  componentDidMount: ->
    #

  componentWillUnmount: ->
    #

  render: ->
    classes = cx
      modal: true
      on: @state.isShown

    <div className={classes}>
      <div className="modal-back" onClick={@_dismiss}/>
      <div className="modal-dialog">
        {@renderHeader()}
        <div className="modal-body">{@props.children}</div>
        {@renderCloseBtn()}
      </div>
    </div>

  renderHeader: ->
    if @props.title
      <header className="modal-header">
        <strong className="modal-title">{@props.title}</strong>
      </header>

  renderCloseBtn: ->
    if @props.canDismiss
      <a className="modal-close-btn" onClick={@_dismiss}/>

  open: ->
    @setState isShown: true

  close: ->
    @setState isShown: false

  toggle: ->
    if @state.isShown then @close() else @open()

  _dismiss: ->
    return unless @props.canDismiss

    @close()

module.exports = Modal