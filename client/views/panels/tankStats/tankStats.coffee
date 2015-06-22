Template.tankStats.helpers
  fittingsWithTank: ->
    fitData = @data.fittings

    if !fitData?
      return []

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

    minEHP = {name: '', value: Number.MAX_VALUE}
    minTank = {name: '', value: Number.MAX_VALUE}
    minTTL = {name: '', value: Number.MAX_VALUE}

    min = (variable, ship, attribute) ->
      if ship[attribute] < variable.value
        variable.value = ship[attribute]
        variable.name = "#{ship.shipTypeName} (#{ship.subtitle})"
      return variable

    _.each fittings, (ship) =>
      rep = 0;
      if ship.stats.outgoing.shield?
        rep = ship.stats.outgoing.shield.rr

      if ship.stats.outgoing.armor?
        rep = ship.stats.outgoing.armor.rr

      ship.tank = ship.stats.tank.resishield * (totalRep - rep)
      ship.ttl = ship.stats.tank.ehpshield / ship.tank
      ship.count = counts[ship._id]

      if ship.stats.tank.ehpshield < minEHP.value
        minEHP.value = ship.stats.tank.ehpshield
        minEHP.name = "#{ship.shipTypeName} (#{ship.subtitle})"

      minTank = min minTank, ship, 'tank'
      minTTL = min minTTL, ship, 'ttl'

    ret = {}
    ret.fittings = fittings
    ret.totalRep = totalRep
    ret.minEHP = minEHP
    ret.minTank = minTank
    ret.minTTL = minTTL
    return ret

Template.tankStatsTable.events
  'click .countUp': (event) ->
    panel = Template.parentData()

    Meteor.call 'updateFittingCount', panel._id, @_id, 1

  'click .countDown': (event) ->
    panel = Template.parentData()
    count = (_.findWhere panel.data.fittings, {id: @_id}).count

    unless count <= 0
      Meteor.call 'updateFittingCount', panel._id, @_id, -1