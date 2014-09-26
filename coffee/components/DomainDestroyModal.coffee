# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
DomainActions = require '../actions/DomainActions'
DomainStore = require '../stores/DomainStore'

Modal = require './Modal'
Input = require './Input'
Form = require './Form'

errorMsg =
  name:
    11: 'Domain name does not match'
    111: 'Please type in the domain name to confirm'

DomainDestroyModal = React.createClass
  mixins: [Form]

  propTypes:
    onSuccess: React.PropTypes.func

  getInitialState: ->
    fields: ['name']
    name: {}
    submitted: false
    submitting: false

  componentDidMount: ->
    DomainStore.on 'change', @onSubmitSuccess

  componentWillUnmount: ->
    DomainStore.off 'change', @onSubmitSuccess

  render: ->
    <Modal
      title="Delete domain"
      ref="modal"
      onHide={@handleModalHide}>
      <form onSubmit={@handleSubmit}>
        <p>This action <strong>CANNOT</strong> be undone. This will permanently remove all the DNS records of <strong>{@props.domain.name}.maji.moe</strong>.</p>
        <div className="input-group">
          <Input
            type="text"
            className="input modal-input"
            ref="input"
            required
            onChange={@handleChange.bind(@, 'name')}
            equal={@props.domain.name}/>
          {@errorMessage('name')}
        </div>
        <div className="modal-footer">
          <button type="submit" className="btn modal-btn danger" disabled={!@state.name.valid}>Delete</button>
          <a className="btn modal-btn" onClick={@hide}>Cancel</a>
        </div>
      </form>
    </Modal>

  errorMessage: (field) ->
    msg = errorMsg[field][@state[field].error]

    if msg
      <div className="input-error">{msg}</div>

  show: ->
    @refs.modal.show()

  hide: ->
    @refs.modal.hide()

  handleSubmit: (e) ->
    e.preventDefault() if e

    @setState submitted: true unless @state.submitted
    return unless @validateFields @state.fields

    return if @state.submitting
    @setState submitting: true

    DomainActions.destroy @props.domain.id

  onSubmitSuccess: ->
    @setState submitting: false
    @props.onSuccess() if @props.onSuccess

  clearForm: ->
    @setState submitted: false
    @refs.input.clear()

  handleModalHide: ->
    @clearForm()

module.exports = DomainDestroyModal