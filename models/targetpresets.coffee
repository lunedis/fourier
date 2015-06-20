@TargetPresets = new Mongo.Collection 'targetpresets'

TargetPresets.attachSchema new SimpleSchema
  speed:
    type: Number
    label: "Speed"
  sig:
    type: Number
    label: "Signature Radius"
  mwd:
    type: Boolean
    label: "MWD activated yes/no"
  name:
    type: String
    label: "Name"


TargetPresets.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true