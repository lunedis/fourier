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
        Doctrines.findOne _id: @params._id
  waitOn: ->
    [Meteor.subscribe('doctrines'), Meteor.subscribe('fittings')]

Router.route 'doctrine/editFitting/:_id',
  name: 'editFitting'
  action: ->
    @render 'editFitting',
      data: ->
        if !@ready
          return
        Fittings.findOne _id: @params._id
  waitOn: ->
    [Meteor.subscribe('doctrines'), Meteor.subscribe('fittings')]