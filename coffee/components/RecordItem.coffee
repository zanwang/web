# @cjsx React.DOM
React = require 'react'
RecordActions = require '../actions/RecordActions'
RecordStore = require '../stores/RecordStore'

RecordForm = require './RecordForm'
Dropdown = require './Dropdown'

recordTTL =
  0: 'Automatic'
  300: '5 mins'
  600: '10 mins'
  900: '15 mins'
  1800: '30 mins'
  3600: '1 hour'
  7200: '2 hours'
  18000: '5 hours'
  43200: '12 hours'
  86400: '1 day'

RecordItem = React.createClass
  getInitialState: ->
    record: @props.record
    isEditing: false

  componentDidMount: ->
    RecordStore.on 'change', @onEditSuccess

  componentWillUnmount: ->
    RecordStore.off 'change', @onEditSuccess

  render: ->
    <div className={'record ' + @state.record.type.toLowerCase()}>
      {@renderContent()}
      {@renderForm()}
    </div>

  renderContent: ->
    return if @state.isEditing

    if @state.record.type is 'MX'
      priority = <span className="record-priority">
        <span className="record-field-note"> with priority </span>
        <span>{@state.record.priority}</span>
      </span>

    <div>
      <div className="record-type">{@state.record.type}</div>
      <div className="record-name">{@state.record.name or @props.domain.name + '.maji.moe'}</div>
      <div className="record-value">
        <span>{@state.record.value}</span>
        {priority}
      </div>
      <div className="record-fn">
        <button className="btn record-options-btn" onClick={@toggleDropdown}></button>
        <Dropdown ref="dropdown">
          <li><a className="dropdown-link record-edit-btn" onClick={@editRecord}>Edit</a></li>
          <li><a className="dropdown-link record-destroy-btn" onClick={@destroyRecord}>Delete</a></li>
        </Dropdown>
      </div>
      <div className="record-ttl">{recordTTL[@state.record.ttl]}</div>
    </div>

  renderForm: ->
    return unless @state.isEditing

    <RecordForm record={@state.record} onDiscard={@onEditDiscard}/>

  toggleDropdown: ->
    @refs.dropdown.toggle()

  editRecord: ->
    @setState
      isEditing: true

  onEditDiscard: ->
    @setState
      isEditing: false

  onEditSuccess: ->
    return unless @isMounted()

    @setState
      isEditing: false
      record: RecordStore.get @state.record.id

  destroyRecord: ->
    if confirm 'Do you want to delete this record?'
      RecordActions.destroy @props.record.id

module.exports = RecordItem