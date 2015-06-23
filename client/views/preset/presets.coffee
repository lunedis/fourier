Template.presets.events
  'click .targetPresetDelete': (event) ->
    if confirm 'Are you sure?'
      TargetPresets.remove @_id
  'click .attackerPresetDelete': (event) ->
    if confirm 'Are you sure?'
      AttackerPresets.remove @_id

Template.addTargetPreset.helpers
  TargetPresetsEFTSchema: ->
    return TargetPresetsEFTSchema

AutoForm.hooks
  AddTargetPresetForm:
    onSuccess: (operation, fit) ->
      Router.go 'presets'
  AddTargetPresetEFTForm:
    onSuccess: (operation, fit) ->
      Router.go 'presets'
  AddAttackerPresetForm:
    onSuccess: (operation, fit) ->
      Router.go 'presets'
  EditTargetPresetForm:
    onSuccess: (operation, fit) ->
      Router.go 'presets'
  EditAttackerPresetForm:
    onSuccess: (operation, fit) ->
      Router.go 'presets'