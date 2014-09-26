# @cjsx React.DOM
React = require 'react'
cx = require 'react/lib/cx'
Router = require 'react-router'
TokenActions = require '../actions/TokenActions'
UserActions = require '../actions/UserActions'
UserStore = require '../stores/UserStore'
TokenStore = require '../stores/TokenStore'

Dropdown = require './Dropdown'

HeaderDropdown = React.createClass
  getInitialState: ->
    user:
      id: 0

  componentDidMount: ->
    token = TokenStore.get()

    UserStore.on 'change', @onUserChange
    TokenStore.on 'change', @onLogoutSuccess

    UserActions.get token.user_id

  componentWillUnmount: ->
    UserStore.off 'change', @onUserChange
    TokenStore.off 'change', @onLogoutSuccess

  render: ->
    classes = cx
      loaded: @state.user.id
      activated: @state.user.activated

    <nav id="user-nav" className={classes}>
      <a id="user-nav-link" onClick={@toggleDropdown}>
        <img src={@state.user.avatar} alt={@state.user.name} id="user-nav-avatar"/>
      </a>
      <Dropdown ref="dropdown">
        <li><strong id="user-nav-dropdown-name" className="dropdown-item">{@state.user.name}</strong></li>
        <li className="dropdown-sep"/>
        <li><a id="user-nav-dropdown-settings" className="dropdown-link" onClick={@handleSettingsClick}>Settings</a></li>
        <li><a id="user-nav-dropdown-logout" className="dropdown-link" onClick={@handleLogoutClick}>Logout</a></li>
      </Dropdown>
    </nav>

  onUserChange: ->
    @setState
      user: UserStore.get()

  toggleDropdown: (e) ->
    @refs.dropdown.toggle()

  handleSettingsClick: ->
    Router.transitionTo 'settings'

  handleLogoutClick: ->
    TokenActions.destroy()

  onLogoutSuccess: ->
    location.href = '/login'

module.exports = HeaderDropdown