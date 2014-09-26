# @cjsx React.DOM
React = require 'react'
container = document.getElementById 'container'
AppLoader = require './components/AppLoader'

React.renderComponent <AppLoader/>, container