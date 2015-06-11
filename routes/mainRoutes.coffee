Router.route '/',
  name: 'home'
  action: ->
    @render 'doctrines'
    SEO.set title: 'Home - ' + Meteor.App.NAME
  waitOn: ->
    Meteor.subscribe 'doctrines'
  fastRender: true

Router.route '/doctrines/:_id',
  action: ->
    @render 'fittings',
      data: ->
        Doctrines.findOne this.params._id
  waitOn: ->
    [Meteor.subscribe('fittings'), Meteor.subscribe('doctrines')]
  fastRender: true