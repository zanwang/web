Dispatcher = (require 'flux').Dispatcher

class AppDispatcher extends Dispatcher
  emit: (action, data) ->
    @dispatch
      action: action
      data: data

  handleServerAction: (successAction, failedAction) ->
    (res) =>
      if res.error
        @emit failedAction, res.body
      else
        @emit successAction, res.body

module.exports = new AppDispatcher()