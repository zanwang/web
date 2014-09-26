# @cjsx React.DOM
React = require 'react'
moment = require 'moment'
Router = require 'react-router'
Link = Router.Link

DomainItem = React.createClass
  render: ->
    expiredDate = moment @props.data.expired_at

    <Link to="domain" params={@props.data} className="domain-wrap">
      <span className="domain">
        <strong className="domain-name">{@props.data.name}</strong>
        <span className="domain-expired-date">Expired date: {expiredDate.format('MMM D, YYYY')}</span>
      </span>
    </Link>

module.exports = DomainItem