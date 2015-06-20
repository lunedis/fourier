Router.route '/',
  name: 'home'
  action: ->
    @render 'welcome'
    SEO.set title: Meteor.App.NAME + ' - Welcome'
  fastRender: true

Router.route '/views',
  name: 'views'
  action: ->
    @render 'views',
      @data: ->
        if !@ready
          return
        Views.find {}
  waitOn: ->
    Meteor.subscribe 'views'
  fastRender: true

Router.route '/view/:_id',
  name: 'view'
  action: ->
    @render 'view', 
      data: ->
        if !this.ready
          return
        Views.findOne this.params._id
  waitOn: ->
    [Meteor.subscribe('views'),Meteor.subscribe('panels', this.params._id), Meteor.subscribe('doctrines'),Meteor.subscribe('fittings')]
  fastRender: true

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
  name: 'view'
  action: ->
    @render 'doctrine'
      data: ->
        if !@ready
          return