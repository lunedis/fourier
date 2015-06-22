Meteor.publish 'fittings', ->
  Desc.init()

  # Transform function
  calculateStats = (doc) ->
    fit = Desc.FromParse doc
    fleet = new DescFleet
    fleet.setSquadCommander Desc.getSkirmishLoki()
    fleet.setWingCommander Desc.getSiegeLoki()
    fleet.addFit fit
    doc.stats = fit.getStats()
    if doc.stats.sharpshooter?
      doc.stats = doc.stats.defense
    return doc

  observer = Fittings.find().observe
    added: (document) =>
      @added 'fittings', document._id, calculateStats document
    changed: (newDocument, oldDocument) =>
      @changed 'fittings', oldDocument._id, calculateStats newDocument
    removed: (oldDocument) =>
      @removed 'fittings', oldDocument._id
  

  @onStop ->
    observer.stop()

  @ready()

Meteor.publish 'doctrines', ->
  Doctrines.find()

Meteor.publish 'views', ->
  Views.find()

Meteor.publish 'panels', (view) ->
  check(view, String)
  Panels.find view: view

Meteor.publish 'targetpresets', ->
  TargetPresets.find {}

Meteor.publish 'attackerpresets', ->
  AttackerPresets.find {}