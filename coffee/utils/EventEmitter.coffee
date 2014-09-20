EventEmitter = (require 'events').EventEmitter

class _EventEmitter extends EventEmitter
  off: @prototype.removeListener

module.exports = _EventEmitter