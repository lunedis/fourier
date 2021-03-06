Router.route '/views',
  name: 'views'
  action: ->
    @render 'views',
      data: ->
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
        if !@ready
          return
        Views.findOne this.params._id
  waitOn: ->
    [Meteor.subscribe('views'),Meteor.subscribe('panels', this.params._id), Meteor.subscribe('doctrines'),Meteor.subscribe('fittings'), Meteor.subscribe('targetpresets'), Meteor.subscribe('attackerpresets')]
  fastRender: true