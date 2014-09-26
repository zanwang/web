Dispatcher = (require 'flux').Dispatcher

class AppDispatcher extends Dispatcher
  emit: (action, data) ->
    @dispatch
      action: action
      data: data

  handleServerAction: (successAction, failedAction, data = {}) ->
    (res) =>
      action = if res.error then failedAction else successAction

      @emit action, res.body or data

module.exports = new AppDispatcher()