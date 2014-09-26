# @cjsx React.DOM
React = require 'react'
UserActions = require '../actions/UserActions'
UserStore = require '../stores/UserStore'
TokenStore = require '../stores/TokenStore'

SettingsProfile = require './SettingsProfile'

Settings = React.createClass
  getInitialState: ->
    data: []
    loaded: false

  componentDidMount: ->
    document.title = 'Settings - maji.moe'
    token = TokenStore.get()

    UserStore.on 'change', @onLoadSuccess
    UserStore.on 'error', @onLoadFailed
    UserActions.get token.user_id

  componentWillUnmount: ->
    UserStore.off 'change', @onLoadSuccess
    UserStore.off 'error', @onLoadFailed

  render: ->
    <div>
      {@renderHeader()}
      {@renderContent()}
    </div>

  renderHeader: ->
    <header className="section-header">
      <h1 className="section-title">Settings</h1>
    </header>

  renderContent: ->
    return unless @state.loaded

    <SettingsProfile data={@state.data}/>

  onLoadSuccess: ->
    @setState
      loaded: true
      data: UserStore.get()

  onLoadFailed: ->
    #

module.exports = Settings