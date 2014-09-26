# @cjsx React.DOM
React = require 'react'
cx = require 'react/lib/cx'
keyMirror = require 'react/lib/keyMirror'
Form = require './Form'
Input = require './Input'
RecordActions = require '../actions/RecordActions'
RecordStore = require '../stores/RecordStore'

recordTypes = keyMirror
  A: null
  CNAME: null
  MX: null
  TXT: null
  SPF: null
  AAAA: null
  NS: null
  LOC: null

recordTypeHint =
  A: 'e.g. 127.0.0.1'
  CNAME: 'e.g. mydomain.com'
  MX: 'e.g. mydomain.com'
  TXT: 'Text record value'
  SPF: 'SPF record value'
  AAAA: 'e.g. ::1'
  NS: 'e.g. a.nameserver.com'
  LOC: 'Loc record value'

recordTTL =
  'Automatic': 0
  '5 mins': 300
  '10 mins': 600
  '15 mins': 900
  '30 mins': 1800
  '1 hour': 3600
  '2 hours': 7200
  '5 hours': 18000
  '12 hours': 43200
  '1 day': 86400

errorMsg =
  type:
    111: 'Type is required'
    216: 'Type doesn\'t support'
  name:
    134: 'Name should be no longer than 63 characters'
    152: 'Only characters and numbers are allowed'
  value:
    111: 'Value is required'
    146: 'IP is invalid'
    147: 'IP is invalid'
    153: 'Domain is invalid'
  ttl:
    149: 'TTL should be 0 (automatic) or at least 300 seconds'
    150: 'Maximum TTL is 86400 seconds'
  priority:
    149: 'Minimum priority is 0'
    150: 'Maximum priority is 65535'

RecordForm = React.createClass
  mixins: [Form]

  propTypes:
    domain: React.PropTypes.object
    record: React.PropTypes.object
    onDiscard: React.PropTypes.func
    onSuccess: React.PropTypes.func

  getDefaultProps: ->
    record:
      type: 'A'
      name: ''
      value: ''
      ttl: 0
      priority: 0

  getInitialState: ->
    fields: ['type', 'name', 'value', 'ttl', 'priority']
    type: {}
    name: {}
    value: {}
    ttl: {}
    priority: {}
    submitted: false
    submitting: false
    editMode: !@props.domain

  componentDidMount: ->
    RecordStore.on 'change', @onSubmitSuccess
    RecordStore.on 'error', @onSubmitFailed

  componentWillUnmount: ->
    RecordStore.off 'change', @onSubmitSuccess
    RecordStore.off 'error', @onSubmitFailed

  render: ->
    classes = cx
      'record-form': true
      mx: @state.type.value is 'MX'

    <form className={classes} onSubmit={@handleSubmit}>
      <div className="input-group record-input-type">
        <Input
          type="select"
          className="select"
          options={recordTypes}
          defaultValue={@props.record.type}
          onChange={@handleTypeChange}
          ref="type"
          required/>
        {@errorMessage('type')}
      </div>
      <div className="input-group record-input-name">
        <Input
          type="text"
          className="input"
          defaultValue={@props.record.name}
          onChange={@handleChange.bind(@, 'name')}
          ref="name"
          maxLength={63}
          placeholder="e.g. www"
          domainName/>
        {@errorMessage('name')}
      </div>
      <div className="record-input-value">
        <div className="input-group">
          <Input
            type="text"
            className="input"
            defaultValue={@props.record.value}
            onChange={@handleChange.bind(@, 'value')}
            placeholder={recordTypeHint[@props.record.type]}
            ref="value"
            required/>
          {@errorMessage('value')}
        </div>
        <div className="record-input-priority-wrap">
          <label>with priority</label>
          <div className="input-group record-input-priority">
            <Input
              type="number"
              className="input"
              defaultValue={@props.record.priority}
              onChange={@handleChange.bind(@, 'priority')}
              ref="priority"
              min={0}
              max={65535}
              disabled={@props.record.type isnt 'MX'}/>
            {@errorMessage('priority')}
          </div>
        </div>
      </div>
      {@renderSubmitButtons()}
      <div className="input-group record-input-ttl">
        <Input
          type="select"
          className="select"
          options={recordTTL}
          defaultValue={@props.record.ttl}
          onChange={@handleChange.bind(@, 'ttl')}
          ref="ttl"/>
        {@errorMessage('ttl')}
      </div>
    </form>

  renderSubmitButtons: ->
    if @state.editMode
      <div className="record-input-fn">
        <button type="submit" className="btn success record-update-btn">Save</button>
        <a className="btn record-discard-btn" onClick={@discard}></a>
      </div>
    else
      <button type="submit" className="btn primary record-create-btn">Create</button>

  errorMessage: (field) ->
    msg = errorMsg[field][@state[field].error]

    if msg and @state.submitted
      <div className="input-error record-input-error">{msg}</div>

  handleTypeChange: (e) ->
    type = e.value

    @handleChange 'type', e

    if @refs.value
      @refs.value.getDOMNode().placeholder = recordTypeHint[type]

    if @refs.priority
      @refs.priority.getDOMNode().disabled = type isnt 'MX'

  handleSubmit: (e) ->
    e.preventDefault()

    @setState submitted: true unless @state.submitted
    return unless @validateFields @state.fields

    return if @state.submitting
    @setState submitting: true

    data =
      type: @state.type.value
      name: @state.name.value
      value: @state.value.value
      ttl: @state.ttl.value
      priority: @state.priority.value

    if @state.editMode
      RecordActions.update @props.record.id, data
    else
      RecordActions.create @props.domain.id, data

  onSubmitSuccess: ->
    return unless @isMounted()

    @setState
      submitting: false
      submitted: false

    for i in @state.fields
      @refs[i].setValue @props.record[i]

    @props.onSuccess() if @props.onSuccess

  onSubmitFailed: (err) ->
    state = {}
    state[err.field or 'error'] = err
    state.submitting = false

    @setState state

  discard: ->
    @props.onDiscard() if @props.onDiscard

module.exports = RecordForm