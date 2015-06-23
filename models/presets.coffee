@TargetPresets = new Mongo.Collection 'targetpresets'

@TargetPresetsStoreSchema = new SimpleSchema
  name:
    type: String
    label: "Name"
  speed:
    type: Number
    label: "Speed"
    decimal: true
  sig:
    type: Number
    label: "Signature Radius"
    decimal: true
  mwd:
    type: Boolean
    label: "MWD activated yes/no"

@TargetPresetsEFTSchema = new SimpleSchema
  name:
    type: String
    label: "Name"
  eft:
    type: String
    label: "EFT Fitting"
    autoform:
      rows: 5
  links:
    type: Boolean
    label: "Links yes/no"

TargetPresets.attachSchema TargetPresetsStoreSchema

TargetPresets.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true

if Meteor.isServer
  Meteor.methods
    'addTargetPresetEFT': (document) ->
      Desc.init()
      check document, TargetPresetsEFTSchema
      fit = Desc.FromEFT document.eft
      if document.links
        fleet = new DescFleet
        fleet.setSquadCommander Desc.getSkirmishLoki()
        fleet.addFit fit

      navigations = fit.getNavigation()
      delete document.eft
      delete document.links
      
      document.speed = navigations[1].speed
      document.sig = navigations[1].sig
      document.mwd = navigations[1].typeName.indexOf('Microwarpdrive') > -1
      check document, TargetPresetsStoreSchema
      TargetPresets.insert document

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