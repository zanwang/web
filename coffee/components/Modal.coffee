# @cjsx React.DOM
React = require 'react'
cx = require 'react/lib/cx'

_id = 1
stack = []
activeModal = 0

Modal = React.createClass
  propTypes:
    title: React.PropTypes.string
    canDismiss: React.PropTypes.bool
    onHide: React.PropTypes.func

  getDefaultProps: ->
    canDismiss: true

  getInitialState: ->
    id: _id++
    isShown: false

  componentDidMount: ->
    activeModal = @state.id
    stack.push @state.id
    window.addEventListener 'keydown', @handleKeydown

  componentWillUnmount: ->
    window.removeEventListener 'keydown', @handleKeydown
    stack.pop()
    activeModal = if stack.length then stack[stack.length - 1] else 0

  render: ->
    classes = cx
      modal: true
      on: @state.isShown

    <div className={classes}>
      <div className="modal-back" onClick={@_dismiss}/>
      <div className="modal-dialog">
        {@renderHeader()}
        <div className="modal-body">
          {@props.children}
        </div>
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
      <a className="modal-close-btn" onClick={@_dismiss}>&times;</a>

  show: ->
    @setState isShown: true

  hide: ->
    @setState isShown: false
    @props.onHide() if @props.onHide

  toggle: ->
    if @state.isShown then @hide() else @show()

  _dismiss: ->
    @hide() if @props.canDismiss and activeModal is @state.id

  handleKeydown: (e) ->
    code = e.keyCode or e.which
    @_dismiss() if code is 27

module.exports = Modal