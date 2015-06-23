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

if Meteor.isServer
  TargetPresets.allow
    insert: ->
      true
    update: ->
      true
    remove: ->
      true

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

AttackerPresetsStoreSchema = new SimpleSchema
  name:
    type: String
    label: 'Name'
  total:
    type: Number
    label: 'Total DPS'
    decimal: true

  turret:
    type: Object
    label: 'Turret'
    optional: true
    blackbox: true
  missile:
    type: Object
    label: "Missile"
    optional: true
    blackbox: true
  drone:
    type: Object
    label: 'Drone'
    optional: true
    blackbox: true
  sentry:
    type: Object
    label: 'sentry'
    optional: true
    blackbox: true


@AttackerPresetsEFTSchema = new SimpleSchema
  name:
    type: String
    label: 'Name'
  eft:
    type: String
    label: 'EFT Fitting'
    autoform:
      rows: 5

AttackerPresets.attachSchema AttackerPresetsStoreSchema

if Meteor.isServer
  AttackerPresets.allow
    insert: ->
      true
    update: ->
      true
    remove: ->
      true

  Meteor.methods
    'addAttackerPresetEFT': (document) ->
      Desc.init()
      check document, AttackerPresetsEFTSchema
      fit = Desc.FromEFT document.eft
      
      damage = fit.getDamage()
      delete document.eft

      _.extend document, damage
      check document, AttackerPresetsStoreSchema
      AttackerPresets.insert document