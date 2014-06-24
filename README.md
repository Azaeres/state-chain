## StateChain 
A Promise-based state machine that is compatible with JSX.

## Usage example

```
`/** @jsx React.DOM */`
'use strict'

Store = require 'main/app/stores/store'
Actions = require 'main/app/actions/actions'

StateChain = require('state-chain')
State = StateChain.State

require './style'

Root = React.createClass
  getInitialState: ->
    current: Store.getCurrentState()

  componentWillMount: ->
    Store.addChangeListener @onChange

  componentDidMount: ->
    `<StateChain><State method={this.state0} catch={this.handleError0} /></StateChain>`

  state0: (resolve, reject) ->
    console.log("state0:\n")
    options = foo: 'bar'
    resolve `<StateChain>
      <State method={this.stateA} options={options} catch={this.handleErrorA} />
      <State method={this.stateB} />
      <State method={this.stateC} />
    </StateChain>`

  stateA: (resolve, reject, options) ->
    console.log("stateA: options:\n", options);
    if options?.foo is 'baz'
      console.log("rejecting promise:\n")
      reject new Error 'foo'
    else
      self = @
      end = ->
        resolve `<StateChain>
          <State method={self.stateB} />
          <State method={self.stateC} />
        </StateChain>`
      setTimeout end, 2000

  stateB: (resolve, reject) =>
    console.log("stateB:\n");
    end = ->
      resolve()
    setTimeout end, 1000

  stateC: (resolve, reject) ->
    console.log("stateC:\n");
    end = ->
      resolve()
    setTimeout end, 800

  stateD: (resolve, reject, options) ->
    console.log("stateD:\n");
    Actions.toggleState()
    resolve()

  handleError0: (err) ->
    console.log("handleError0:\n");

  handleErrorA: (err) ->
    console.log("handleErrorA:\n");
    `<StateChain>
      <State method={this.stateB} />
    </StateChain>`


  componentWillUnmount: ->
    Store.removeChangeListener @onChange

  render: ->
    `<div className="root">
      <h1 onClick={this.toggleState}>{this.state.current}</h1>
    </div>`

  toggleState: ->
    `<StateChain>
      <State method={this.stateC} />
      <State method={this.stateD} />
    </StateChain>`

  onChange: ->
    @setState
      current: Store.getCurrentState()

module.exports = Root
```

## The above example prints the following to the console:

```
state0:
stateA: options:
 Object {foo: "bar"}
stateB:
stateC:
stateB:
stateC:
```

