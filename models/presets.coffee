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


@AttackerPresets = new Mongo.Collection 'attackerpresets'

AttackerPresets.attachSchema new SimpleSchema
  name:
    type: String
    label: "Name"
  total:
    type: Number
    label: 'Total DPS'

  turret:
    type: Object
    label: "Turret"
    optional: true
  'turret.dps':
    type: Number
    label: 'Turret DPS'
  'turret.tracking':
    type: Number
    label: 'Turret Tracking'
  'turret.optimal':
    type: Number
    label: 'Turret Optimal'
  'turret.falloff':
    type: Number
    label: 'Turret Falloff'
  'turret.signatureResolution':
    type: Number
    label: 'Turret SigRes'

  missile:
    type: Object
    label: "Missile"
    optional: true
  'missile.dps':
    type: Number
    label: 'Missile DPS'
  'missile.range':
    type: Number
    label: 'Missile Range'
  'missile.explosionVelocity':
    type: Number
    label: 'Missile Explosion Velocity'
  'missile.explosionRadius':
    type: Number
    label: 'Missile Explosion Radius'
  'missile.drf':
    type: Number
    label: 'Missile DRF'

AttackerPresets.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true