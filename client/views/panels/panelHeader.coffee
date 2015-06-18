Template.panelHeader.helpers
  doctrineName: ->
    Doctrines.findOne(_id: @doctrine).name