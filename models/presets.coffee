@TargetPresets = new Mongo.Collection 'targetpresets'

TargetPresets.attachSchema new SimpleSchema
  name:
    type: String
    label: "Name"
  speed:
    type: Number
    label: "Speed"
  sig:
    type: Number
    label: "Signature Radius"
  mwd:
    type: Boolean
    label: "MWD activated yes/no"

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
    decimal: true
  'turret.tracking':
    type: Number
    label: 'Turret Tracking'
    decimal: true
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
    decimal: true
  'missile.range':
    type: Number
    label: 'Missile Range'
    decimal: true
  'missile.explosionVelocity':
    type: Number
    label: 'Missile Explosion Velocity'
    decimal: true
  'missile.explosionRadius':
    type: Number
    label: 'Missile Explosion Radius'
    decimal: true
  'missile.drf':
    type: Number
    label: 'Missile DRF'
    decimal: true

AttackerPresets.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true