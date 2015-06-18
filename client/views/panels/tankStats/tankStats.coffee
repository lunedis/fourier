UI.registerHelper 'formatNumber', (context, options) ->
  if context
    decimals = 0
    if typeof options == 'number'
      decimals = options
     
    context.toFixed(decimals).replace /\d(?=(\d{3})+$)/g, '$&,'

Template.tankStatsTable.helpers
  fittingsWithTank: ->
    fitData = @data.fittings

    if !fitData?
      return [];

    fitList = _.pluck fitData, 'id'
    counts = {}
    for fit in fitData
      counts[fit.id] = fit.count

    fittings = Fittings.find({_id: {$in: fitList}}).fetch()
    totalRep = _.reduce fittings, (memo, ship) =>
      if ship.stats.outgoing.shield?
        memo + ship.stats.outgoing.shield.rr * counts[ship._id]
      else if ship.stats.outgoing.armor?
        memo + ship.stats.outgoing.armor.rr * counts[ship._id]
      else
        return memo
    , 0

    _.each fittings, (ship) =>
      rep = 0;
      if ship.stats.outgoing.shield?
        rep = ship.stats.outgoing.shield.rr

      if ship.stats.outgoing.armor?
        rep = ship.stats.outgoing.armor.rr

      ship.tank = ship.stats.tank.resishield * (totalRep - rep)
      ship.ttl = ship.stats.tank.ehpshield / ship.tank
      ship.count = counts[ship._id]

    return fittings

  range: ->
      d = @stats.damage
      if d.turret?
        optimal = (d.turret.optimal / 1000).toFixed(0)
        falloff = (d.turret.falloff / 1000).toFixed(0)
        return "#{optimal}+#{falloff}"
      else if d.missile?
        range = (d.missile.range / 1000).toFixed(0)
        return "#{range}k"

Template.tankStatsTable.events
  'click .countUp': (event) ->
    panel = Template.parentData(2).data

    Meteor.call 'updateFittingCount', panel._id, @_id, 1

  'click .countDown': (event) ->
    panel = Template.parentData(2).data
    count = (_.findWhere panel.data.fittings, {id: @_id}).count

    unless count <= 0
      Meteor.call 'updateFittingCount', panel._id, @_id, -1