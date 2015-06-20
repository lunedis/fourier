Template['view'].helpers
  rowTemplate: ->
    if @full?
      'fullRow'
    else if @left?
      'splitRow'

Template.fullRow.helpers
  panel: ->
    Panels.findOne _id: @full
  

Template.splitRow.helpers
  leftPanel: ->
    Panels.findOne _id: @left
  rightPanel: ->
    Panels.findOne _id: @right
  log: ->
    console.log @

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