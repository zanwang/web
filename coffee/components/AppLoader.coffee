# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
Routes = Router.Routes
Route = Router.Route
DefaultRoute = Router.DefaultRoute
Loading = require './Loading'
TokenActions = require '../actions/TokenActions'
TokenStore = require '../stores/TokenStore'

Container = require './Container'
Login = require './Login'
Signup = require './signup'
PasswordReset = require './PasswordReset'
App = require './App'
DomainList = require './DomainList'
Settings = require './Settings'
Domain = require './Domain'

AppLoader = React.createClass
  getInitialState: ->
    path = window.location.pathname

    loaded: false
    path: path
    isRestrictedPage: /^\/app/.test path

  componentDidMount: ->
    token = TokenStore.get()

    unless token
      @setLoaded()
      Router.replaceWith 'login' if @state.isRestrictedPage
      return

    @bindTokenListener()
    TokenActions.update()

  render: ->
    if @state.loaded
      @renderRoutes()
    else
      @renderLoading()

  renderLoading: ->
    <Loading color="#999" lines={10} width={3} length={8}/>

  renderRoutes: ->
    <Routes location="history">
      <Route path="/" handler={Container}>
        <Route name="login" path="/login" handler={Login}/>
        <Route name="signup" path="/signup" handler={Signup}/>
        <Route name="password-reset" path="/password-reset" handler={PasswordReset}/>
        <Route name="app" path="/app" handler={App}>
          <DefaultRoute handler={DomainList}/>
          <Route name="settings" handler={Settings}/>
          <Route name="domain" path="domains/:id" handler={Domain}/>
        </Route>
      </Route>
    </Routes>

  setLoaded: ->
    @setState loaded: true

  bindTokenListener: ->
    TokenStore.on 'change', @onTokenUpdateSuccess
    TokenStore.on 'error', @onTokenUpdateFailed

  unbindTokenListener: ->
    TokenStore.off 'change', @onTokenUpdateSuccess
    TokenStore.off 'error', @onTokenUpdateFailed

  onTokenUpdateSuccess: ->
    @unbindTokenListener()
    @setLoaded()

    unless @state.isRestrictedPage
      Router.replaceWith 'app'

  onTokenUpdateFailed: ->
    @unbindTokenListener()
    @setLoaded()

    if @state.isRestrictedPage
      Router.replaceWith 'login'

module.exports = AppLoader