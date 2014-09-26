# @cjsx React.DOM
React = require 'react'
DomainActions = require '../actions/DomainActions'
DomainStore = require '../stores/DomainStore'

Form = require './Form'
Input = require './Input'
Modal = require './Modal'

errorMsg =
  name:
    111: 'Name is required'
    134: 'Name should be no longer than 63 characters'
    152: 'Only characters and numbers are allowed'
    213: 'Domain name has been taken'
    224: 'Domain name has been reserved'
  error:
    210: 'User hasn\'t been activated yet'

DomainCreateModal = React.createClass
  mixins: [Form]

  getInitialState: ->
    fields: ['name']
    name: {}
    error: {}
    submitted: false
    submitting: false

  componentDidMount: ->
    DomainStore.on 'change', @onSubmitSuccess
    DomainStore.on 'error', @onSubmitFailed

  componentWillUnmount: ->
    DomainStore.off 'change', @onSubmitSuccess
    DomainStore.off 'error', @onSubmitFailed

  render: ->
    <Modal
      title="New domain"
      ref="modal"
      onHide={@handleModalHide}>
      <form onSubmit={@handleSubmit}>
        <p>The domain will be expired in <strong>one year</strong>. Don&apos;t forget to extend the expiration date before it&apos;s expired, or your ownership of the domain will be cancelled.</p>
        <div className="input-group">
          <Input
            type="text"
            className="input modal-input"
            placeholder="e.g. loli (Only characters and numbers are allowed)"
            onChange={@handleChange.bind(@, 'name')}
            required
            maxLength={63}
            domainName
            ref="input"/>
          {@errorMessage('name')}
        </div>
        <div className="modal-footer">
          <button type="submit" className="btn modal-btn primary">Create</button>
          <a className="btn modal-btn" onClick={@hide}>Cancel</a>
        </div>
      </form>
      {@otherErrorMessage()}
    </Modal>

  errorMessage: (field) ->
    msg = errorMsg[field][@state[field].error]

    if msg and @state.submitted
      <div className="input-error">{msg}</div>

  otherErrorMessage: ->
    msg = errorMsg.error[@state.error.error]

    if msg
      <div className="modal-error">{msg}</div>

  handleSubmit: (e) ->
    e.preventDefault() if e

    @setState submitted: true unless @state.submitted
    return unless @validateFields @state.fields
    return if @state.error.error

    return if @state.submitting
    @setState submitting: true

    DomainActions.create
      name: @state.name.value

  handleModalHide: ->
    @setState submitted: false
    @refs.input.clear()

  onSubmitSuccess: ->
    @setState submitting: false

  onSubmitFailed: (err) ->
    state = {}
    state[err.field or 'error'] = err
    state.submitting = false

    @setState state

  show: ->
    @refs.modal.show()

  hide: ->
    @refs.modal.hide()

module.exports = DomainCreateModal