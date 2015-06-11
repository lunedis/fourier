@Fittings = new Mongo.Collection 'fittings'

mandatoryDescriptionSchema = new SimpleSchema
  subtitle:
    type: String
    max: 100
    label: "Subtitle"
  role:
    type: String
    label: "Role"
    max: 50

descriptionSchema = new SimpleSchema
  description:
    type: String
    label: "Description"
    optional: true
  count:
    type: Number
    label: "Count"
    optional: true

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

eftSchema = new SimpleSchema
  eft:
    type: String
    label: "EFT"
    autoform:
      rows: 5

eftSchemaOptional = new SimpleSchema
  eft:
    type: String
    label: "EFT"
    optional: true
    autoform:
      rows: 5

StoreFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, descriptionSchema, loadoutSchema])

@AddFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, eftSchema])

@UpdateFittingsSchema = new SimpleSchema(
  [mandatoryDescriptionSchema, descriptionSchema, eftSchemaOptional])

Fittings.attachSchema StoreFittingsSchema

Fittings.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true

if Meteor.isServer
  Meteor.methods
    'addFitting': (document) ->
      check document, AddFittingsSchema 

      Desc.init()
      parse = Desc.ParseEFT document.eft
      dbEntry = subtitle: document.subtitle, role: document.role, description: ""

      _.extend dbEntry, parse

      Fittings.insert dbEntry

    'updateFitting': (modifier, documentID) ->
      check modifier, UpdateFittingsSchema
      check documentID, String

      if modifier.$set.eft?
        eft = modifier.$set.eft
        Desc.init()

        parse = Desc.parseEFT eft

        delete modifier.$set.eft
        _.extend modifier.$set, parse

      Fittings.update documentID, modifier