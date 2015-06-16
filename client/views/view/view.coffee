doctrineID = 0
Template['view'].helpers
	doctrineName: ->
    doctrineID = @doctrine
    Doctrines.findOne(_id: @doctrine).name
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