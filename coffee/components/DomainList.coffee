# @cjsx React.DOM
React = require 'react'
DomainActions = require '../actions/DomainActions'
DomainStore = require '../stores/DomainStore'

Modal = require './Modal'
DomainCreateModal = require './DomainCreateModal'
DomainItem = require './DomainItem'

DomainList = React.createClass
  getInitialState: ->
    domains: []
    loaded: false

  componentDidMount: ->
    document.title = 'Domains - maji.moe'

    DomainStore.on 'change', @onLoadSuccess
    DomainStore.on 'error', @onLoadFailed
    DomainActions.list()

  componentWillUnmount: ->
    DomainStore.off 'change', @onLoadSuccess
    DomainStore.off 'error', @onLoadFailed

  render: ->
    <div>
      {@renderHeader()}
      {@renderDomainList()}
      {@renderModal()}
    </div>

  renderHeader: ->
    if @state.loaded
      button = @renderCreateButton()

    <header className="section-header">
      <h1 className="section-title">Domains</h1>
      {button}
    </header>

  renderCreateButton: ->
    <button className="btn primary new-domain-btn" onClick={@createDomain}>New domain</button>

  renderDomainList: ->
    return unless @state.loaded

    if @state.domains.length
      domains = []

      for item in @state.domains
        domains.push <DomainItem key={item.id} data={item}/>

      <div id="domain-list">{domains}</div>
    else
      <div id="empty-domain-list">
        <p>Click the button to create a new domain!</p>
        {@renderCreateButton()}
      </div>

  renderModal: ->
    if @state.loaded
      <DomainCreateModal ref="modal"/>

  createDomain: ->
    @refs.modal.show()

  onLoadSuccess: ->
    @setState
      loaded: true
      domains: DomainStore.list()

  onLoadFailed: ->
    #

module.exports = DomainList