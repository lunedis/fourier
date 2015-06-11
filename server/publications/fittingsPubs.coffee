Meteor.publish 'fittings', ->
  Desc.init()

  # Transform function
  calculateStats = (doc) ->
    fit = Desc.FromParse doc
    #fleet = new DescFleet
    #fleet.setSquadCommander Desc.getSkirmishLoki()
    #fleet.setWingCommander Desc.getSiegeLoki()
    #fleet.addFit fit
    doc.stats = fit.getStats()
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