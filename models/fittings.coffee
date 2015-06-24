@Fittings = new Mongo.Collection 'fittings'

mandatoryDescriptionSchema = new SimpleSchema
  name:
    type: String
    max: 100
    label: "Name"

loadoutSchema = new SimpleSchema
  shipTypeID:
    type: Number
    label: "shipTypeID"
    autoform:
      omit: true
  shipTypeName: 
    type: String
    label: "ShipTypeName"
    autoform:
      omit: true
  loadout:
    type: Object
    label: "Loadout"
    blackbox: true
    autoform:
      omit: true
  stats: 
    type: Object
    label: "Stats"
    blackbox: true
    autoform:
      omit: true

eftSchema = new SimpleSchema
  eft:
    type: String
    label: "EFT"
    autoform:
      rows: 5
  links:
    type: String
    allowedValues: ['none', 'kiting', 'armor', 'shield']
    label: 'Links'
    autoform:
      label: false
      afFieldInput:
        type: 'hidden'
  doctrine:
    type: String
    label: 'Doctrine'
    autoform:
      label: false
      afFieldInput:
        type: 'hidden'

eftSchemaOptional = new SimpleSchema
  eft:
    type: String
    label: "EFT"
    optional: true
    autoform:
      rows: 5

StoreFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, loadoutSchema])

@AddFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, eftSchema])

@UpdateFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, eftSchemaOptional])

Fittings.attachSchema StoreFittingsSchema

if Meteor.isServer
  Fittings.allow
    insert: ->
      true
    update: ->
      true
    remove: ->
      true

  transformStats = (obj) ->
    Desc.init()
    parse = Desc.ParseEFT obj.eft
    fit = Desc.FromParse parse

    unless obj.links == 'none'
      fleet = new DescFleet()
      fleet.setSquadCommander Desc.getSkirmishLoki()
      if obj.links == 'armor'
        fleet.setWingCommander Desc.getArmorLoki()
      else if obj.links == 'shield'
        fleet.setWingCommander Desc.getSiegeLoki()

      fleet.addFit fit

    delete obj.eft
    delete obj.links
    _.extend obj, parse
    obj.stats = fit.getStats()
    return obj

  Meteor.methods
    addFitting: (document) ->
      check document, AddFittingsSchema
      doctrineID = document.doctrine
      delete document.doctrine
      document = transformStats document
      check document, StoreFittingsSchema
      fitID = Fittings.insert document
      Doctrines.update doctrineID, {$push: {fittings: fitID}}
