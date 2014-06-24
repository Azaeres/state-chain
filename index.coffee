'use strict'

Promise = require('es6-promise').Promise

_createPromise = (method, errorHandler, options) ->
  promise = new Promise (resolve, reject) ->
    if options
      method resolve, reject, options
    else
      method resolve, reject
  promise.catch errorHandler if errorHandler
  promise

_promiseForState = (state, priorPromise) ->
  if priorPromise is undefined
    return _createPromise state.method, state.catch, state.options
  else
    return priorPromise.then (result) ->
      _createPromise state.method, state.catch, state.options

_chainPromises = ->
  promise = undefined
  for i, state of arguments
    promise = _promiseForState state, promise
  promise


StateChain = ->
  states = Array.prototype.slice.call(arguments)
  states.shift()
  _chainPromises.apply @, states

StateChain.State = (attr) ->
  method: attr?.method
  catch: attr?.catch
  options: attr?.options

module.exports = StateChain
