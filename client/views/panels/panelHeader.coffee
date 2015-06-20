Template.panelHeader.helpers
  doctrineName: ->
    Doctrines.findOne(_id: @doctrine).name

Template.panelHeader.events
  'click .settings': (event) ->
    div = $('div.popover', event.target)
    div.toggleClass 'hidden'