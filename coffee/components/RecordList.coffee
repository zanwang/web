# @cjsx React.DOM
React = require 'react'
RecordActions = require '../actions/RecordActions'
RecordStore = require '../stores/RecordStore'

RecordForm = require './RecordForm'
RecordItem = require './RecordItem'

RecordList = React.createClass
  propTypes:
    domain: React.PropTypes.object

  getInitialState: ->
    records: []
    loaded: false

  componentDidMount: ->
    RecordStore.on 'change', @onLoadSuccess
    RecordActions.list @props.domain.id

  componentWillUnmount: ->
    RecordStore.off 'change', @onLoadSuccess

  render: ->
    records = []

    for item in @state.records
      records.push <RecordItem key={item.id} domain={@props.domain} record={item}/>

    <div id="record-list-wrap">
      <header id="record-list-header">
        <div id="record-list-header-type">Type</div>
        <div id="record-list-header-name">Name</div>
        <div id="record-list-header-value">Value</div>
        <div id="record-list-header-ttl">TTL</div>
      </header>
      <div id="record-list">
        {records}
        {@renderRecordList()}
      </div>
    </div>

  renderRecordList: ->
    return unless @state.loaded

    <div className="record-form-wrap">
      <RecordForm domain={@props.domain}/>
    </div>

  onLoadSuccess: ->
    list = RecordStore.list @props.domain.id

    @setState
      records: list
      loaded: true

module.exports = RecordList