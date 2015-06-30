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

doctrineID = 0

Template.editFitting.onCreated ->
  @autorun ->
    fit = Template.currentData()
    doctrine = Doctrines.findOne {fittings: fit._id}
    fit.links = doctrine.links
    fit.doctrine = doctrine._id
    doctrineID = doctrine._id

Template.editFitting.helpers
  UpdateFittingsSchema: ->
    UpdateFittingsSchema

#AutoForm.hooks
#  EditFittingForm:
#    onSuccess: (operation, fit) ->
#      Router.go 'doctrine', {_id: doctrineID}