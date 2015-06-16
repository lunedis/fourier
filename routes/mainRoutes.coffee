Router.route '/',
  name: 'home'
  action: ->
    @render 'doctrines'
    SEO.set title: 'Home - ' + Meteor.App.NAME
  waitOn: ->
    Meteor.subscribe 'doctrines'
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