Template.doctrine.helpers
  AddFittingsSchema: ->
    AddFittingsSchema

  fittings: ->
    fitIDs = @fittings
    Fittings.find _id: $in: fitIDs

  fromDoctrine: ->
    return links: @links, doctrine: @_id

Template.doctrine.events
  'click .delete': ->
    if confirm 'Are you sure?'
      fitID = @_id
      Fittings.remove fitID
      doctrineID = Router.current().params._id
      Doctrines.update doctrineID,
        $pull:
          fittings: fitID

Template.editFitting.helpers
  UpdateFittingsSchema: ->
    UpdateFittingsSchema
  document: ->
    fitting = @
    doctrine = Doctrines.findOne {fittings: @_id}
    fitting.links = doctrine.links
    return fitting