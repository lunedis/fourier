Router.route '/',
  name: 'home'
  action: ->
    @render 'welcome'
    SEO.set title: Meteor.App.NAME + ' - Welcome'
  fastRender: true