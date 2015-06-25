Template.overview.helpers
	fittings: ->
    fitData = @data.fittings

    if !fitData?
      return []

    fitList = _.pluck fitData, 'id'
    counts = {}
    for fit in fitData
      counts[fit.id] = fit.count

    fittings = Fittings.find({_id: {$in: fitList}}).fetch()
    totalDPS = _.reduce fittings, (memo, ship) =>
      return memo + ship.stats.damage.total * counts[ship._id]
    , 0

    minEHP = {name: '', value: Number.MAX_VALUE}
    minSpeed = {name: '', value: Number.MAX_VALUE}

    _.each fittings, (ship) =>
      ehp = ship.stats.tank.ehp
      if ehp < minEHP.value
        minEHP.value = ehp
        minEHP.name = "#{ship.shipTypeName} (#{ship.name})"

      speed = ship.stats.navigation[1].speed
      if speed < minSpeed.value
        minSpeed.value = speed
        minSpeed.name = "#{ship.shipTypeName} (#{ship.name})"

      ship.count = counts[ship._id]

    ret = {}
    ret.fittings = fittings
    ret.totalDPS = totalDPS
    ret.minEHP = minEHP
    ret.minSpeed = minSpeed
    return ret

Template.overviewTable.helpers
  navigation: ->
    return @stats.navigation[1]