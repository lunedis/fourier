Router.route '/presets',
  name: 'presets'
  action: ->
    @render 'presets',
      data: ->
        if !@ready
          return
        {targetPresets: TargetPresets.find {} 
        attackerPresets: AttackerPresets.find {}}
  waitOn: ->
    [Meteor.subscribe('targetpresets'), Meteor.subscribe('attackerpresets')]
  fastRender: true
