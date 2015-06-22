Router.route '/doctrines',
  name: 'doctrines'
  action: ->
    @render 'doctrines',
      data: ->
        if !@ready
          return
        Doctrines.find {}
  waitOn: ->
    Meteor.subscribe 'doctrines'

Router.route '/doctrine/:_id',
  name: 'doctrine'
  action: ->
    @render 'doctrine',
      data: ->
        if !@ready
          return