# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
Routes = Router.Routes
Route = Router.Route
DefaultRoute = Router.DefaultRoute
container = document.getElementById 'container'

Container = require './components/Container'
Login = require './components/Login'
Signup = require './components/Signup'
PasswordReset = require './components/PasswordReset'

routes = ->
  <Routes location="history">
    <Route path="/" handler={Container}>
      <Route name="login" path="/login" handler={Login}/>
      <Route name="signup" path="/signup" handler={Signup}/>
      <Route name="password-reset" path="/password-reset" handler={PasswordReset}/>
    </Route>
  </Routes>

React.renderComponent routes(), container