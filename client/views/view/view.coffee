Template['view'].helpers
  panels: ->
    Panels.find view: @_id

Template['addFitting'].helpers
  AddFittingsSchema: ->
    return AddFittingsSchema

AutoForm.addHooks 'addFittingForm', 
  after:
    method: (error, result) ->
      if(!error?)
        check result, String
        Doctrines.update doctrineID, {$push: {fittings: result}}
      else
        console.log error