# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
Link = Router.Link
DomainActions = require '../actions/DomainActions'
DomainStore = require '../stores/DomainStore'

RecordList = require './RecordList'
DomainDestroyModal = require './DomainDestroyModal'

Domain = React.createClass
  mixins: [Router.ActiveState]

  getInitialState: ->
    domain: null

  componentDidMount: ->
    document.title = 'Edit domain - maji.moe'

    DomainStore.on 'change', @onLoadSuccess
    DomainActions.get @props.params.id

  componentWillUnmount: ->
    DomainStore.off 'change', @onLoadSuccess

  render: ->
    <div>
      {@renderHeader()}
      {@renderRecordList()}
      {@renderDestroyModal()}
    </div>

  renderHeader: ->
    return unless @state.domain

    <header className="section-header">
      <a className="section-back-btn" onClick={@goBack}></a>
      <h1 className="section-title">{@state.domain.name}.maji.moe</h1>
      <button className="btn primary expand-domain-btn">Expand</button>
      <button className="btn danger delete-domain-btn" onClick={@handleDestroyClick}>Delete</button>
    </header>

  renderRecordList: ->
    return unless @state.domain

    <RecordList domain={@state.domain}/>

  renderDestroyModal: ->
    return unless @state.domain

    <DomainDestroyModal domain={@state.domain} ref="destroyModal" onSuccess={@goBack}/>

  onLoadSuccess: ->
    domain = DomainStore.get @props.params.id

    @setState
      domain: domain

  goBack: ->
    if window.history.state
      Router.goBack()
    else
      Router.transitionTo 'app'

  handleDestroyClick: ->
    @refs.destroyModal.show()

module.exports = Domain