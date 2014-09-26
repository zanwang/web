# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
Link = Router.Link

HeaderDropdown = require './HeaderDropdown'

AppHeader = React.createClass
  render: ->
    <header id="header-wrap">
      <div id="header" className="inner">
        <h1 id="logo">
          <Link to="app">maji.moe</Link>
        </h1>
        <HeaderDropdown/>
      </div>
    </header>

module.exports = AppHeader